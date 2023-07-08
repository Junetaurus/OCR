//
//  OCRDevice.m
//  OCR
//
//  Created by June on 2023/6/10.
//

#import "OCRDevice.h"
#import <AVFoundation/AVFoundation.h>
#import "UIDevice+Direction.h"

@interface OCRDevice () <AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
//设备
@property (nonatomic, strong) AVCaptureDevice *device;
//输入
@property (nonatomic, strong) AVCaptureDeviceInput *input;
//输出
@property (nonatomic ,strong) AVCapturePhotoOutput *photoOutput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *dataOutput;
@property (nonatomic, strong) NSMutableArray <NSData *> *dataArray;
//connection
@property (nonatomic, strong) AVCaptureConnection *connection;
//session
@property (nonatomic, strong) AVCaptureSession *session;
//图像预览层
@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *previewLayer;
//
@property (nonatomic, assign) OCRDeviceType type;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, copy) photoBlock block;

@end

@implementation OCRDevice

- (instancetype)initWithView:(UIView *)view deviceType:(OCRDeviceType)type {
    self = [super init];
    if (self) {
        if ([self authorizationStatus]) {
            _view = view;
            _type = type;
            //
            if ([self.session canAddInput:self.input]) {
                [self.session addInput:self.input];
            }
            if (type == OCRDeviceFront) {
                if ([self.session canAddOutput:self.dataOutput]) {
                    [self.session addOutput:self.dataOutput];
                }
            } else if (type == OCRDeviceBack) {
                if ([self.session canAddOutput:self.photoOutput]) {
                    [self.session addOutput:self.photoOutput];
                }
            }
            //
            [view.layer addSublayer:self.previewLayer];
        }
    }
    return self;
}

- (void)updateFrame {
    self.previewLayer.frame = _view.bounds;
}

- (void)startRunning {
    [self.session startRunning];
}

- (void)stopRunning {
    [self.session stopRunning];
}

- (void)getPhoto:(photoBlock)block {
    _block = block;
    if (_type == OCRDeviceBack) {
        AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettings];
        [_photoOutput capturePhotoWithSettings:settings delegate:self];
    } else if (_type == OCRDeviceFront) {
        if (self.dataArray.count) {
            [self stopRunning];
            !_block ? : _block(_dataArray[_dataArray.count / 2]);
            return;
        }
        !_block ? : _block(_dataArray.firstObject);
    }
}

#pragma mark - 相机权限
- (BOOL)authorizationStatus {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    if (!error) {
        [self stopRunning];
        NSData *data = [photo fileDataRepresentation];
        !_block ? : _block(data);
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    CVImageBufferRef buffer;
    buffer = CMSampleBufferGetImageBuffer(sampleBuffer);

    CVPixelBufferLockBaseAddress(buffer, 0);
    uint8_t *base;
    size_t width, height, bytesPerRow;
    base = (uint8_t *)CVPixelBufferGetBaseAddress(buffer);
    width = CVPixelBufferGetWidth(buffer);
    height = CVPixelBufferGetHeight(buffer);
    bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);

    CGColorSpaceRef colorSpace;
    CGContextRef cgContext;
    colorSpace = CGColorSpaceCreateDeviceRGB();
    cgContext = CGBitmapContextCreate(base, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);

    CGImageRef cgImage;
    UIImage *image;
    cgImage = CGBitmapContextCreateImage(cgContext);
    image = [UIImage imageWithCGImage:cgImage];
    
    [self detectFaceWithImage:image];
    
    CGImageRelease(cgImage);
    CGContextRelease(cgContext);
    CVPixelBufferUnlockBaseAddress(buffer, 0);
}

- (void)detectFaceWithImage:(UIImage *)image {
    //图像识别能力：可以在CIDetectorAccuracyHigh(较强的处理能力)与CIDetectorAccuracyLow(较弱的处理能力)中选择，因为想让准确度高一些在这里选择CIDetectorAccuracyHigh
    NSDictionary *opts = [NSDictionary dictionaryWithObject:
                          CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    // 将图像转换为CIImage
    CIImage *faceImage = [CIImage imageWithCGImage:image.CGImage];
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:opts];
    // 识别出人脸数组
    NSArray *features = [faceDetector featuresInImage:faceImage];
    // 得到图片的尺寸
    CGSize inputImageSize = [faceImage extent].size;
    //将image沿y轴对称
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
    //将图片上移
    transform = CGAffineTransformTranslate(transform, 0, -inputImageSize.height);
    //清空数组
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataArray removeAllObjects];
    });
    //取出人脸
    CIFaceFeature *faceFeature = features.firstObject;
    if (faceFeature && faceFeature.hasLeftEyePosition && faceFeature.hasRightEyePosition && faceFeature.hasMouthPosition) {
        NSData *data = UIImagePNGRepresentation(image);
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"检测到人脸");
            [self.dataArray addObject:data];
        });
    }
}

#pragma mark - getter
- (AVCaptureDevice *)device {
    if (!_device) {
        AVCaptureDevicePosition position = AVCaptureDevicePositionUnspecified;
        if (_type == OCRDeviceFront) {
            position = AVCaptureDevicePositionFront;
        } else if (_type == OCRDeviceBack) {
            position = AVCaptureDevicePositionBack;
        }
        _device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:position];
    }
    return _device;
}

- (AVCaptureDeviceInput *)input {
    if (!_input) {
        NSError *error;
        _input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:&error];
        if (error) {
            NSLog(@"AVCaptureDeviceInput = %@", error.description);
        }
    }
    return _input;
}

- (AVCapturePhotoOutput *)photoOutput {
    if (!_photoOutput) {
        _photoOutput = [[AVCapturePhotoOutput alloc] init];
    }
    return _photoOutput;
}

- (AVCaptureVideoDataOutput *)dataOutput {
    if (!_dataOutput) {
        _dataOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_dataOutput setSampleBufferDelegate:self queue:dispatch_get_global_queue(0, 0)];
        _dataOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA], (id)kCVPixelBufferPixelFormatTypeKey, nil];
        self.connection = [_dataOutput connectionWithMediaType:AVMediaTypeVideo];
    }
    return _dataOutput;
}

- (NSMutableArray<NSData *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (AVCaptureConnection *)connection {
    if (!_connection) {
        _connection.videoScaleAndCropFactor = _connection.videoMaxScaleAndCropFactor;
        if ([_connection isVideoStabilizationSupported]) {
            _connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    return _connection;
}

- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
//        _session.sessionPreset = AVCaptureSessionPreset640x480;
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        AVCaptureVideoOrientation videoOrientation = AVCaptureVideoOrientationPortrait;
        if (_type == OCRDeviceBack) {
            videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        }
        _previewLayer.connection.videoOrientation = videoOrientation;
    }
    return _previewLayer;
}

@end

//
//  OCRDevice.m
//  OCR
//
//  Created by June on 2023/6/10.
//

#import "OCRDevice.h"
#import <AVFoundation/AVFoundation.h>

@interface OCRDevice () <AVCapturePhotoCaptureDelegate>

//设备
@property (nonatomic, strong) AVCaptureDevice *device;
//输入
@property (nonatomic, strong) AVCaptureDeviceInput *input;
//输出
@property (nonatomic ,strong) AVCapturePhotoOutput *output;
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
            if ([self.session canAddOutput:self.output]) {
                [self.session addOutput:self.output];
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
    AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettings];
    [_output capturePhotoWithSettings:settings delegate:self];
}

#pragma mark - 权限
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
        NSData *data = [photo fileDataRepresentation];
        NSLog(@"%@", data.description);
        !_block ? : _block(data);
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

- (AVCapturePhotoOutput *)output {
    if (!_output) {
        _output = [[AVCapturePhotoOutput alloc] init];
    }
    return _output;
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


//
//  OCRDevice.m
//  OCR
//
//  Created by June on 2023/6/10.
//

#import "OCRDevice.h"
#import <AVFoundation/AVFoundation.h>

@interface OCRDevice ()

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

@end

@implementation OCRDevice

- (instancetype)initWithView:(UIView *)view deviceType:(OCRDeviceType)type {
    self = [super init];
    if (self) {
        if ([self authorizationStatus]) {
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

- (void)updateFrame:(CGRect)frame {
    self.previewLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)startRunning {
    [self.session startRunning];
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
    }
    return _previewLayer;
}

@end

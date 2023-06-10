//
//  OCRFaceView.m
//  OCR
//
//  Created by June on 2023/6/10.
//

#import "OCRFaceView.h"
#import "OCRDevice.h"
#import "UIView+Frame.h"

@interface OCRFaceView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *faceView;
@property (nonatomic, strong) OCRDevice *device;


@end

@implementation OCRFaceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        
        [self addSubview:self.faceView];
        [self.device startRunning];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_faceView sizeToFit];
    _faceView.center = self.center;
    [_device updateFrame:_faceView.frame];
}

#pragma mark - getter
- (UIImageView *)faceView {
    if (!_faceView) {
        _faceView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ocr_face_frame"]];
    }
    return _faceView;
}

- (OCRDevice *)device {
    if (!_device) {
        _device = [[OCRDevice alloc] initWithView:self.faceView deviceType:OCRDeviceFront];
    }
    return _device;
}

@end

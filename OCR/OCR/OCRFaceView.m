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

@property (nonatomic, strong) UIView *faceView;
@property (nonatomic, strong) UIImageView *limitView;
@property (nonatomic, strong) UIButton *photoBtn;
@property (nonatomic, strong) OCRDevice *device;

@end

@implementation OCRFaceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        
        [self addSubview:self.faceView];
        [self.device startRunning];
        [self addSubview:self.limitView];
        [self addSubview:self.photoBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_limitView sizeToFit];
    _limitView.center = self.center;
    //
    _faceView.frame = _limitView.frame;
    //
    [_device updateFrame];
    //
    [_photoBtn sizeToFit];
    _photoBtn.centerX = _faceView.centerX;
    _photoBtn.y = self.height - _photoBtn.height - 30;
}

#pragma mark - photoClick
- (void)photoClick:(UIButton *)btn {
    [_device getPhoto:^(NSData * _Nonnull photoData) {
        
    }];
}

#pragma mark - getter
- (UIView *)faceView {
    if (!_faceView) {
        _faceView = [[UIView alloc] init];
    }
    return _faceView;
}

- (UIImageView *)limitView {
    if (!_limitView) {
        _limitView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ocr_face_frame"]];
    }
    return _limitView;
}

- (UIButton *)photoBtn {
    if (!_photoBtn) {
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoBtn setImage:[UIImage imageNamed:@"ocr_id_photo"] forState:UIControlStateNormal];
        [_photoBtn setImage:[UIImage imageNamed:@"ocr_id_photo"] forState:UIControlStateHighlighted];
        [_photoBtn addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoBtn;
}

- (OCRDevice *)device {
    if (!_device) {
        _device = [[OCRDevice alloc] initWithView:self.faceView deviceType:OCRDeviceFront];
    }
    return _device;
}

@end


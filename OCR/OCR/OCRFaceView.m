//
//  OCRFaceView.m
//  OCR
//
//  Created by June on 2023/6/10.
//

#import "OCRFaceView.h"
#import "OCRDevice.h"
#import "UIView+Frame.h"
#import "General.h"

@interface OCRFaceView ()

@property (nonatomic, strong) UIButton *xBtn;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIView *faceView;
@property (nonatomic, strong) UIImageView *limitView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) OCRDevice *device;
//提示及动画
@property (nonatomic, strong) UILabel *aniLabel;
@property (nonatomic, strong) UIImageView *aniImgView;

@end

@implementation OCRFaceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.xBtn];
        [self addSubview:self.tipLabel];
        [self addSubview:self.faceView];
        [self addSubview:self.limitView];
        [self addSubview:self.aniLabel];
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.aniImgView];
        //
        [self.device startRunning];
        [self searchPhoto];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _xBtn.width = DesignScaleWidth(21);
    _xBtn.height = DesignScaleHeight(21);
    _xBtn.x = self.width - DesignScaleWidth(20) - _xBtn.width;
    
    [_tipLabel sizeToFit];
    _tipLabel.centerX = self.width * 0.5;
    _tipLabel.y = _xBtn.y + _xBtn.height + DesignScaleHeight(26);
    
    _limitView.width = DesignScaleWidth(360);
    _limitView.height = DesignScaleHeight(324);
    _limitView.centerX = _tipLabel.centerX;
    _limitView.y = _tipLabel.y + _tipLabel.height + DesignScaleHeight(22);
    
    _faceView.frame = _limitView.frame;
    
    [_device updateFrame];
    
    _bgView.width = self.width;
    _bgView.height = DesignScaleHeight(124);
    _bgView.y = self.height - _bgView.height;
    
    _aniLabel.height = _aniLabel.font.lineHeight;
    _aniLabel.width = self.width;
    _aniLabel.y = _limitView.y + _limitView.height + DesignScaleHeight(22);
    
    _aniImgView.size = CGSizeMake(DesignScaleWidth(100), DesignScaleHeight(100));
    _aniImgView.centerX = _bgView.width * 0.5;
    _aniImgView.y = DesignScaleHeight(12);
}

#pragma mark - animation
- (void)startAnimation {
    NSInteger random = (arc4random() % 3);
    NSString *imgName = @"";
    if (random == 0) {
        imgName = @"ocr_turn_head";
        _aniLabel.text = @"Please look left or right (<30 degrees)";
    } else if (random == 1) {
        imgName = @"ocr_blink";
        _aniLabel.text = @"Please blink";
    } else if (random == 2) {
        imgName = @"ocr_open_mouth";
        _aniLabel.text = @"Please open and close your mouth";
    }
    NSMutableArray *imgArray = [NSMutableArray array];
    for (int i = 1; i <= 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%d", imgName ,i]];
        if (image) {
            [imgArray addObject:image];
        }
    }
    _aniImgView.animationImages = imgArray;
    _aniImgView.animationDuration = 2;
    _aniImgView.animationRepeatCount = 0;
    [_aniImgView startAnimating];
}

- (void)stopAnimation {
    [_aniImgView stopAnimating];
}

#pragma mark - btnClick
- (void)btnClick:(UIButton *)btn {
    if (btn == _xBtn) {
        [_device stopRunning];
        [self stopAnimation];
        !_faceCloseBlock ? : _faceCloseBlock(nil);
    }
}

- (void)searchPhoto {
    [self startAnimation];
    WeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakself stopAnimation];
        [weakself getPhoto];
    });
}

- (void)getPhoto {
    WeakSelf(self);
    [_device getPhoto:^(NSData * _Nonnull photoData) {
        NSLog(@"%@", photoData.description);
        if (photoData) {
            !weakself.faceCloseBlock ? : weakself.faceCloseBlock(photoData);
        } else {
            [weakself searchPhoto];
        }
    }];
}

#pragma mark - getter
- (UIButton *)xBtn {
    if (!_xBtn) {
        _xBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xBtn setBackgroundImage:[UIImage imageNamed:@"ocr_x"] forState:UIControlStateNormal];
        [_xBtn setBackgroundImage:[UIImage imageNamed:@"ocr_x"] forState:UIControlStateHighlighted];
        [_xBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xBtn;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textColor = UIColorFromRGB(0x323233);
        _tipLabel.text = @"Please place your avatar in the viewfinder";
    }
    return _tipLabel;
}

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

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = BackGroundColorGreen;
    }
    return _bgView;
}

- (OCRDevice *)device {
    if (!_device) {
        _device = [[OCRDevice alloc] initWithView:self.faceView deviceType:OCRDeviceFront];
    }
    return _device;
}

- (UILabel *)aniLabel {
    if (!_aniLabel) {
        _aniLabel = [[UILabel alloc] init];
        _aniLabel.textColor = UIColorFromRGB(0x323233);
        _aniLabel.font = [UIFont systemFontOfSize:14];
        _aniLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _aniLabel;
}

- (UIImageView *)aniImgView {
    if (!_aniImgView) {
        _aniImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ocr_blink_1"]];
        _aniImgView.layer.masksToBounds = YES;
        _aniImgView.layer.cornerRadius = DesignScaleHeight(50);
    }
    return _aniImgView;
}

@end

//
//  OCRIdentityView.m
//  OCR
//
//  Created by June on 2023/6/10.
//

#import "OCRIdentityView.h"
#import "OCRDevice.h"
#import "UIView+Frame.h"
#import "General.h"

@interface OCRIdentityTipView : UIView

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation OCRIdentityTipView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.imgView];
        [self addSubview:self.tipLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imgView.width = self.height;
    _imgView.height = self.height;
    
    [_tipLabel sizeToFit];
    _tipLabel.centerY = _imgView.centerY;
    _tipLabel.x = _imgView.width + 2.5;
}

#pragma mark - getter
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ocr_id_x"]];
    }
    return _imgView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:16];
        _tipLabel.textColor = UIColorFromRGB(0x323233);
    }
    return _tipLabel;
}

@end

@interface OCRIdentityView ()

@property (nonatomic, strong) UIButton *xBtn;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIView *picView;
@property (nonatomic, strong) UIImageView *limitView;
@property (nonatomic, strong) UIButton *photoBtn;
@property (nonatomic, strong) UIButton *succBtn;
@property (nonatomic, strong) UIButton *failBtn;
@property (nonatomic, strong) OCRIdentityTipView *tipView1;
@property (nonatomic, strong) OCRIdentityTipView *tipView2;
@property (nonatomic, strong) OCRIdentityTipView *tipView3;
@property (nonatomic, strong) OCRDevice *device;
@property (nonatomic, strong) NSData *photoData;

@end

@implementation OCRIdentityView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.xBtn];
        [self addSubview:self.tipLabel];
        [self addSubview:self.picView];
        [self addSubview:self.limitView];
        [self addSubview:self.photoBtn];
        [self addSubview:self.succBtn];
        [self addSubview:self.failBtn];
        [self addSubview:self.tipView1];
        [self addSubview:self.tipView2];
        [self addSubview:self.tipView3];
        //
        [self.device startRunning];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _xBtn.x = [self scaleWidth:14];
    _xBtn.y = [self scaleHeight:14];
    _xBtn.width = [self scaleWidth:21];
    _xBtn.height = [self scaleHeight:21];
    
    [_tipLabel sizeToFit];
    _tipLabel.centerX = self.width * 0.5;
    _tipLabel.centerY = _xBtn.centerY;
    
    _limitView.width = [self scaleWidth:414];
    _limitView.height = [self scaleHeight:260];
    _limitView.centerX = self.width * 0.5;
    _limitView.centerY = self.height * 0.5;
    
    _picView.frame = _limitView.frame;
    
    [_device updateFrame];
    
    _photoBtn.width = [self scaleWidth:64];
    _photoBtn.height = [self scaleHeight:64];
    _photoBtn.x = _limitView.x + _limitView.width + [self scaleWidth:30];
    _photoBtn.centerY = _limitView.centerY;
    
    _succBtn.size = _photoBtn.size;
    _succBtn.x = _photoBtn.x;
    _succBtn.y = [self scaleHeight:80];
    
    _failBtn.size = _photoBtn.size;
    _failBtn.x = _photoBtn.x;
    _failBtn.y = self.height - [self scaleHeight:80] - _failBtn.height;
    
    _tipView1.x = _limitView.x;
    _tipView1.y = _limitView.y + _limitView.height + [self scaleHeight:16];
    _tipView1.width = [self scaleWidth:100];
    _tipView1.height = [self scaleHeight:16];
    
    _tipView2.x = _tipView1.x + [self scaleWidth:126];
    _tipView2.y = _tipView1.y;
    _tipView2.width = [self scaleWidth:100];
    _tipView2.height = _tipView1.height;
    
    _tipView3.x = _tipView1.x + [self scaleWidth:229];
    _tipView3.y = _tipView1.y;
    _tipView3.width = [self scaleWidth:200];
    _tipView3.height = _tipView1.height;
}

- (CGFloat)scaleWidth:(CGFloat)width {
    return [self scaleHeight:width];
}

- (CGFloat)scaleHeight:(CGFloat)height {
    CGFloat designHeight = 360;
    return roundf(self.height == designHeight ? (CGFloat)height : (CGFloat)(self.height*(CGFloat)height/(CGFloat)designHeight));
}

#pragma mark - btnClick
- (void)btnClick:(UIButton *)btn {
    if (btn == _xBtn) {
        [_device stopRunning];
        !_picCloseBlock ? : _picCloseBlock(nil);
    }
    if (btn == _photoBtn) {
        WeakSelf(self);
        [_device getPhoto:^(NSData * _Nonnull photoData) {
            NSLog(@"%@", photoData.description);
            weakself.photoData = photoData;
        }];
        //
        _photoBtn.hidden = YES;
        _succBtn.hidden = NO;
        _failBtn.hidden = NO;
    }
    if (btn == _succBtn) {
        !_picCloseBlock ? : _picCloseBlock(_photoData);
    }
    if (btn == _failBtn) {
        _photoData = nil;
        [_device startRunning];
        //
        _photoBtn.hidden = NO;
        _succBtn.hidden = YES;
        _failBtn.hidden = YES;
    }
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
        _tipLabel.font = [UIFont systemFontOfSize:18];
        _tipLabel.text = @"Take a photo of your ID in a bright area";
        _tipLabel.textColor = UIColorFromRGB(0x323233);
    }
    return _tipLabel;
}

- (UIView *)picView {
    if (!_picView) {
        _picView = [[UIView alloc] init];
    }
    return _picView;
}

- (UIImageView *)limitView {
    if (!_limitView) {
        _limitView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ocr_id_frame"]];
    }
    return _limitView;
}

- (UIButton *)photoBtn {
    if (!_photoBtn) {
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoBtn setBackgroundImage:[UIImage imageNamed:@"ocr_id_photo"] forState:UIControlStateNormal];
        [_photoBtn setBackgroundImage:[UIImage imageNamed:@"ocr_id_photo"] forState:UIControlStateHighlighted];
        [_photoBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoBtn;
}

- (UIButton *)succBtn {
    if (!_succBtn) {
        _succBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_succBtn setBackgroundImage:[UIImage imageNamed:@"ocr_id_s"] forState:UIControlStateNormal];
        [_succBtn setBackgroundImage:[UIImage imageNamed:@"ocr_id_s"] forState:UIControlStateHighlighted];
        [_succBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _succBtn.hidden = YES;
    }
    return _succBtn;
}

- (UIButton *)failBtn {
    if (!_failBtn) {
        _failBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_failBtn setBackgroundImage:[UIImage imageNamed:@"ocr_id_f"] forState:UIControlStateNormal];
        [_failBtn setBackgroundImage:[UIImage imageNamed:@"ocr_id_f"] forState:UIControlStateHighlighted];
        [_failBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _failBtn.hidden = YES;
    }
    return _failBtn;
}

- (OCRIdentityTipView *)tipView1 {
    if (!_tipView1) {
        _tipView1 = [[OCRIdentityTipView alloc] init];
        _tipView1.tipLabel.text = @"Incomplete";
    }
    return _tipView1;
}

- (OCRIdentityTipView *)tipView2 {
    if (!_tipView2) {
        _tipView2 = [[OCRIdentityTipView alloc] init];
        _tipView2.tipLabel.text = @"Blur";
    }
    return _tipView2;
}

- (OCRIdentityTipView *)tipView3 {
    if (!_tipView3) {
        _tipView3 = [[OCRIdentityTipView alloc] init];
        _tipView3.tipLabel.text = @"Overexposure";
    }
    return _tipView3;
}

- (OCRDevice *)device {
    if (!_device) {
        _device = [[OCRDevice alloc] initWithView:self.picView deviceType:OCRDeviceBack];
    }
    return _device;
}

@end

//
//  ViewController.m
//  OCR
//
//  Created by June on 2023/6/10.
//

#import "ViewController.h"
#import "UIView+Frame.h"
#import "General.h"
#import "OCRViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *faceBtn;
@property (nonatomic, strong) UIButton *idBtn;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.faceBtn];
    [self.view addSubview:self.idBtn];
    [self.view addSubview:self.imgView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //
    _faceBtn.y = 100;
    _faceBtn.size = CGSizeMake(150, 50);
    _faceBtn.centerX = self.view.width * 0.5;
    //
    _idBtn.size = _faceBtn.size;
    _idBtn.centerX = _faceBtn.centerX;
    _idBtn.y = _faceBtn.y + _faceBtn.height + 20;
    //
    _imgView.y = _idBtn.y + _idBtn.height + 20;
    _imgView.size = CGSizeMake(self.view.width - 40, 400);
    _imgView.centerX = _faceBtn.centerX;
}

- (void)btnClick:(UIButton *)btn {
    WeakSelf(self);
    if (btn == _faceBtn) {
        [OCRViewController ocrVCWithType:OCRFace currentVC:self].alertDismissBlock = ^(NSData * _Nullable photoData) {
            weakself.imgView.image = [UIImage imageWithData:photoData];
        };
    }
    if (btn == _idBtn) {
        [OCRViewController ocrVCWithType:OCRId currentVC:self].alertDismissBlock = ^(NSData * _Nullable photoData) {
            weakself.imgView.image = [UIImage imageWithData:photoData];
        };
    }
}

#pragma mark - getter
- (UIButton *)faceBtn {
    if (!_faceBtn) {
        _faceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_faceBtn setTitle:@"Face" forState:UIControlStateNormal];
        [_faceBtn setTitle:@"Face" forState:UIControlStateHighlighted];
        [_faceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _faceBtn.layer.borderWidth = 1;
        _faceBtn.layer.borderColor = BackGroundColorGreen.CGColor;
    }
    return _faceBtn;
}

- (UIButton *)idBtn {
    if (!_idBtn) {
        _idBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_idBtn setTitle:@"ID" forState:UIControlStateNormal];
        [_idBtn setTitle:@"ID" forState:UIControlStateHighlighted];
        [_idBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _idBtn.layer.borderWidth = 1;
        _idBtn.layer.borderColor = BackGroundColorGreen.CGColor;
    }
    return _idBtn;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.layer.borderWidth = 1;
        _imgView.layer.borderColor = BackGroundColorGreen.CGColor;
    }
    return _imgView;
}

@end

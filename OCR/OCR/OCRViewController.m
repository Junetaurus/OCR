//
//  OCRViewController.m
//  OCR
//
//  Created by June on 2023/6/10.
//

#import "OCRViewController.h"
#import "UIDevice+Direction.h"
#import "OCRFaceView.h"
#import "OCRIdentityView.h"
#import "AppDelegate.h"
#import "General.h"
#import "UIView+Frame.h"

@interface OCRViewController ()

@property (nonatomic, assign) OCRType type;
@property (nonatomic, strong) OCRFaceView *faceView;
@property (nonatomic, strong) OCRIdentityView *idView;

@end

@implementation OCRViewController

+ (instancetype)ocrVCWithType:(OCRType)type currentVC:(UIViewController *)currentVC {
    OCRViewController *ocrVC = [[OCRViewController alloc] init];
    ocrVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    ocrVC.type = type;
    [currentVC presentViewController:ocrVC animated:NO completion:nil];
    return ocrVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if (_type == OCRFace) {
        [self.view addSubview:self.faceView];
    } else if (_type == OCRId) {
        //强制横屏
        AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
        appDelegate.allowRotation = YES;
        [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
        //
        [self.view addSubview:self.idView];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect layoutFrame = self.view.safeAreaLayoutGuide.layoutFrame;
    UIEdgeInsets insets = self.view.safeAreaInsets;
    
    _faceView.frame = CGRectMake(insets.left, insets.top, layoutFrame.size.width, layoutFrame.size.width);
    _idView.frame = CGRectMake(insets.left, 0, layoutFrame.size.width, self.view.height);
}

#pragma mark - getter
- (OCRFaceView *)faceView {
    if (!_faceView) {
        _faceView = [[OCRFaceView alloc] init];
        WeakSelf(self);
        _faceView.faceCloseBlock = ^(NSData * _Nullable photoData) {
            !weakself.alertDismissBlock ? : weakself.alertDismissBlock(photoData);
            [weakself dismissViewControllerAnimated:NO completion:nil];
        };
    }
    return _faceView;
}

- (OCRIdentityView *)idView {
    if (!_idView) {
        _idView = [[OCRIdentityView alloc] init];
        WeakSelf(self);
        _idView.picCloseBlock = ^(NSData * _Nullable photoData) {
            //强制竖屏
            AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
            appDelegate.allowRotation = NO;
            [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
            //
            !weakself.alertDismissBlock ? : weakself.alertDismissBlock(photoData);
            [weakself dismissViewControllerAnimated:NO completion:nil];
        };
    }
    return _idView;
}

@end

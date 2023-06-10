//
//  ViewController.m
//  OCR
//
//  Created by June on 2023/6/10.
//

#import "ViewController.h"
#import "UIDevice+Direction.h"
#import "OCRFaceView.h"
#import "OCRIdentityView.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (nonatomic, strong) OCRFaceView *faceView;
@property (nonatomic, strong) OCRIdentityView *idView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self ocrFace];
    //
//    [self ocrId];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _idView.frame = self.view.bounds;
}

- (void)ocrFace {
    _faceView = [[OCRFaceView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_faceView];
}

- (void)ocrId {
    [self appDelegate].allowRotation = YES;
    [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
    _idView = [[OCRIdentityView alloc] init];
    [self.view addSubview:_idView];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)(UIApplication.sharedApplication.delegate);
}

@end

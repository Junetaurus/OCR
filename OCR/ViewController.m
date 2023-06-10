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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    OCRFaceView *faceView = [[OCRFaceView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:faceView];
    //
    OCRIdentityView *idView = [[OCRIdentityView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:idView];
}

@end

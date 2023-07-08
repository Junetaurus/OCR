//
//  OCRViewController.h
//  OCR
//
//  Created by June on 2023/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OCRType) {
    OCRFace,
    OCRId,
};

@interface OCRViewController : UIViewController

+ (instancetype)ocrVCWithType:(OCRType)type currentVC:(UIViewController *)currentVC;

@property (nonatomic, copy) void(^alertDismissBlock)(NSData *__nullable photoData);

@end

NS_ASSUME_NONNULL_END

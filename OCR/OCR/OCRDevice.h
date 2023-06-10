//
//  OCRDevice.h
//  OCR
//
//  Created by June on 2023/6/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OCRDeviceType) {
    OCRDeviceNone,
    OCRDeviceFront,
    OCRDeviceBack,
};

@interface OCRDevice : NSObject

- (instancetype)initWithView:(UIView *)view deviceType:(OCRDeviceType)type;

- (void)updateFrame;

- (void)startRunning;

@end

NS_ASSUME_NONNULL_END


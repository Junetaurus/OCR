//
//  OCRFaceView.h
//  OCR
//
//  Created by June on 2023/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCRFaceView : UIView

@property (nonatomic, copy) void(^faceCloseBlock)(NSData *__nullable photoData);

@end

NS_ASSUME_NONNULL_END

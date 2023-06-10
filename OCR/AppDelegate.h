//
//  AppDelegate.h
//  OCR
//
//  Created by June on 2023/6/10.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

/**
 * 是否允许转向
 */
@property(nonatomic, assign) BOOL allowRotation;

@end



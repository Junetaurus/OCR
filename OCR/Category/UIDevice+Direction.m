//
//  UIDevice+Direction.m
//  OCR
//
//  Created by June on 2023/6/10.
//

#import "UIDevice+Direction.h"

@implementation UIDevice (Direction)

+ (void)switchNewOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //
    NSNumber *resetOrientationTarget = [NSNumber numberWithInteger:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    //
    NSNumber *orientationTarget = [NSNumber numberWithInteger:interfaceOrientation];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

@end

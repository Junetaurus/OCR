//
//  General.h
//  OCR
//
//  Created by June on 2023/7/7.
//

#ifndef General_h
#define General_h

//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

/*
 通过比例尺计算相对宽高函数
 */
#define DesignWidth 375.0f    //设计图依据屏幕宽度为375
#define DesignScaleWidth(w) roundf(ScreenWidth == DesignWidth ? (CGFloat)w : (CGFloat)ScreenWidth*((CGFloat)w/(CGFloat)DesignWidth))
#define DesignScaleHeight(h) roundf(ScreenWidth == DesignWidth ? (CGFloat)h : (CGFloat)(ScreenWidth*(CGFloat)h/(CGFloat)DesignWidth))
#define DesignScaleFontSize(s) roundf(ScreenWidth == DesignWidth ? s : (CGFloat)((ScreenWidth / DesignWidth) * s))

//WeakSelf
#define WeakSelf(type)  __weak typeof(type) weak##type = type;

//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define BackGroundColorGreen UIColorFromRGB(0x008247)

#endif /* General_h */

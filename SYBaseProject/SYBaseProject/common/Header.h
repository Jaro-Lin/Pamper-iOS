//
//  Header.h
//  magicShop
//
//  Created by apple on 2019/10/31.
//  Copyright © 2019 YYB. All rights reserved.
//

#ifndef Header_h
#define Header_h

//-------------------打印日志-------------------------
#ifdef DEBUG
#define LOG(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define LOG(...)
#endif

#define  kPlaceHoldImage   [UIImage imageNamed:@"placeholder"]
#define  kPlaceHoldImageUser   [UIImage imageNamed:@"head_user"]

#define  kImageWithName(a)   [UIImage imageNamed:a]
#define  KFont_M(a)  [UIFont fontWithName:@"pingFangSC-Medium" size:a]
#define  kModuleBundleUIImageNamed(a)  [UIImage imageNamed:a]

// 基准屏幕宽度
#define kRefereWidth 414.0
//以屏幕宽度为固定比例关系，来计算对应的值。假设：基准屏幕宽度414，floatV=10；当前屏幕宽度为375时，那么返回的值为9.05
//#define KAdaptW(floatValue) (floatValue*[[UIScreen mainScreen] bounds].size.width/kRefereWidth)
#define KAdaptW(floatValue) (floatValue)

/** 颜色 */
#define KUIColorFromRGBWithAlpha(rgbValue,ala) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:ala]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

#define KUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBOF(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]


#define KScreenWidth [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height

//适配x xr xs xsMax
//判断是否是ipad
#define KisPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define KiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !KisPad : NO)
//判断iPhone5系列
#define KiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !KisPad : NO)
//判断iPhone6系列
#define KiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !KisPad : NO)
//判断iphone6+系列
#define KiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !KisPad : NO)
//判断iPhoneX
#define KIS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !KisPad : NO)
//判断iPHoneXr
#define KIS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !KisPad : NO)
//判断iPhoneXs
#define KIS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !KisPad : NO)
//判断iPhoneXs Max
#define KIS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !KisPad : NO)

// 判断iPhone11
#define KIS_IPHONE_11 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !KisPad : NO)

#define KIS_IPHONE_11_Pro ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !KisPad : NO)

#define KIS_IPHONE_11_Pro_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !KisPad : NO)

//iPhoneX系列
//判断iPhoneX所有系列
#define KIS_PhoneXAll (KIS_IPHONE_X==YES || KIS_IPHONE_Xr ==YES || KIS_IPHONE_Xs== YES || KIS_IPHONE_Xs_Max== YES || KIS_IPHONE_11== YES || KIS_IPHONE_11_Pro== YES || KIS_IPHONE_11_Pro_Max == YES)

#define KStatusBarHeight (KIS_PhoneXAll ? 44.0 : 20.0)
#define KNavBarHeight (KIS_PhoneXAll ? 88.0 : 64.0)
#define KTabBarHeight (KIS_PhoneXAll ? 83.0 : 49.0)
#define KTabBarSafe_Height (KIS_PhoneXAll ? 34.0 : 0.0)

//View 圆角和加边框
#define KViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define KViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//拼接字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]
/**
 字符串判空
 */
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

/** 获取系统对象 */
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kScreen_Bounds [UIScreen mainScreen].bounds

#define kSelfWeak __weak typeof(self) weakSelf = self
#define kSelfStrong __strong __typeof__(self) strongSelf = weakSelf

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//动态图片宽度
#define KCollectionWidth  (KScreenWidth-KAdaptW(20)*2-KAdaptW(8)*2)

#endif /* Header_h */

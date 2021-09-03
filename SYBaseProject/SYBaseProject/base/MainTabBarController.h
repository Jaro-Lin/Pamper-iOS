//
//  MainTabBarController.h
//  magicShop
//
//  Created by apple on 2019/10/31.
//  Copyright © 2019 YYB. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<CYLTabBarController/CYLTabBarController.h>)
#import <CYLTabBarController/CYLTabBarController.h>
#else
#import "CYLTabBarController.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface MainTabBarController : CYLTabBarController
- (instancetype)initWithContext:(NSString *)context;
@end

NS_ASSUME_NONNULL_END

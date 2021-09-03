//
//  AppDelegate.h
//  SYBaseProject
//
//  Created by apple on 2020/3/18.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) BOOL allowOrentitaionRotation;
@property(nonatomic, strong) MainTabBarController *mainTabBar;
+(AppDelegate *)getAppDelegate;
@end


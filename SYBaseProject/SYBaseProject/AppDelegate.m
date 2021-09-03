//
//  AppDelegate.m
//  SYBaseProject
//
//  Created by apple on 2020/3/18.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+AppService.h"
#import "CYLPlusButtonSubclass.h"

#import "baseNavigationController.h"
#import "MSUserInformation.h"
#import "OpenShare.h"
#import "WXApi.h"
#import "AlipayManager.h"
#import "WechatPayManager.h"
#import <Bugly/Bugly.h>
#import "SYLogManagerViewController.h"

static AppDelegate *_appDelegate;
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _appDelegate = self;
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //    [CYLPlusButtonSubclass registerPlusButton];
    if (!kStringIsEmpty([MSUserInformation sharedManager].user.token)) {//已经登录
        self.mainTabBar = [[MainTabBarController alloc]initWithContext:@""];
        self.window.rootViewController =self.mainTabBar;
        
    }else{
        self.window.rootViewController = [[baseNavigationController alloc]initWithRootViewController:[SYLogManagerViewController new]];
    }
    [self.window makeKeyAndVisible];
    
    [Bugly startWithAppId:@"31b4e532a9"];
    
    [self initWindow];
    [self showFPS:NO];
    return YES;
}
+(AppDelegate *)getAppDelegate{
    return _appDelegate;
}
/// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    // 可以这么写
    if (self.allowOrentitaionRotation) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - 生命周期
- (void)applicationWillEnterForeground:(UIApplication *)application{
    NSLog(@"状态** 将要进入前台");
}
- (void)applicationDidBecomeActive:(UIApplication *)application{
    NSLog(@"状态** 已经活跃");
}
- (void)applicationWillResignActive:(UIApplication *)application{
    NSLog(@"状态** 将要进入后台");
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
    NSLog(@"状态** 已经进入后台");
}
- (void)applicationWillTerminate:(UIApplication *)application{
    NSLog(@"状态** 将要退出程序");
}


// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    
    //
    //    if ([[url absoluteString] hasPrefix:@"meimeila://"]){
    ////        [self.homePage openFromLink:options];
    //
    //        [self.homePage openFromLink:[url absoluteString]];
    //    }
    
    [OpenShare handleOpenURL:url];
    
    if([WXApi handleOpenURL:url delegate:[WechatPayManager shareManager]]){
        return YES;
    }
    if([[AlipayManager shareManager] handleOpenURL:url]){
        return YES;
    }
    
    return YES;
    
}
@end

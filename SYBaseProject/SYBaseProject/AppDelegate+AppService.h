//
//  AppDelegate+AppService.h
//  BaseProject
//
//  Created by Qinz on 2017/11/17.
//  Copyright © 2017年 Qinz. All rights reserved.
//

#import "AppDelegate.h"

/**  包含第三方 和 应用内业务的实现，减轻入口代码压力 */

@interface AppDelegate (AppService)

/** 初始化 window */
-(void)initWindow;

/** 初始化服务 */
//-(void)initService;

/** FPS 监测 */
-(void)showFPS:(BOOL)show;

/** 监听网络状态 */
//- (void)networkStatusChange;

/** 发布到APPStore将isRelease设置为YES */
//-(void)avoidCrash:(BOOL)isRelease;

/** 单例 */
+ (AppDelegate *)shareAppDelegate;

@end

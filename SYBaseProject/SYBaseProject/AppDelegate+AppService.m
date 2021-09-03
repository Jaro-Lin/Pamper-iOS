//
//  AppDelegate+AppService.m
//  BaseProject
//
//  Created by Qinz on 2017/11/17.
//  Copyright © 2017年 Qinz. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "YYFPSLabel.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <SVProgressHUD.h>
#import "TWSNS.h"
#import "WXApi.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
@implementation AppDelegate (AppService)

-(void)initWindow{
    
    // 配置IQKeyboardManager
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.shouldResignOnTouchOutside = YES;  //点击屏幕隐藏键盘，对所有界面生效
    manager.enable = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    manager.toolbarDoneBarButtonItemText = @"完成";
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    //微信注册
    [TWSNS registerWeiXinAppId:KWeiXinAppID secret:KWeiXinAppSecret];
    if([WXApi registerApp:KWeiXinAppID universalLink:@"https://baidu/app/"]) {
        LOG(@"注册成功");
    }else {
        LOG(@"注册失败");
    }
    //QQ注册
    [TWSNS registerQQAppId:KQQAppID secret:KQQAppSecret];
    
    //友盟注册
    [MobClick setCrashReportEnabled:YES];
    [UMConfigure initWithAppkey:KYouMenKey channel:nil];
    
    [self setiOS11];
    
    // 强制关闭暗黑模式
#if defined(__IPHONE_13_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
    if(@available(iOS 13.0,*)){
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
#endif
}

#pragma mark -- FPS 监测
-(void)showFPS:(BOOL)show{
    if (show) {
        YYFPSLabel *_fpsLabel = [YYFPSLabel new];
        [_fpsLabel sizeToFit];
        _fpsLabel.bottom = KScreenHeight - 105;
        _fpsLabel.right = KScreenWidth - 10;
        [kAppWindow addSubview:_fpsLabel];
    }
}

-(void)setiOS11{
    
    //iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
    if (@available(iOS 11, *)) {
        //解决iOS11，仅实现heightForHeaderInSection，没有实现viewForHeaderInSection方法时,section间距大的问题
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
        
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


-(void)dealwithCrashMessage:(NSNotification *)notification {
    
    LOG(@"\n🚫监测到崩溃信息🚫\n");
    //在这里对避免的异常进行一些处理，比如上传到日志服务器等。
}

- (void)dealloc{
    
    
}
@end

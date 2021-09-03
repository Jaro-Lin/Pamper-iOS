//
//  baseNavigationController.m
//  magicShop
//
//  Created by apple on 2019/10/31.
//  Copyright © 2019 YYB. All rights reserved.
//

#import "baseNavigationController.h"
#import "MainTabBarController.h"
#import "CYLPlusButtonSubclass.h"

@interface baseNavigationController ()

@end

@implementation baseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self createNewTabBar];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    //设置导航文字颜色
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: KUIColorFromRGB(0x333333), NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:18], NSFontAttributeName, nil]];
    
    [[UINavigationBar appearance]setShadowImage:[UIImage new]];
    [UINavigationBar appearance].translucent = NO;
    
}

- (CYLTabBarController *)createNewTabBar {
    
    [CYLPlusButtonSubclass registerPlusButton];
    return [self createNewTabBarWithContext:nil];
}

- (CYLTabBarController *)createNewTabBarWithContext:(NSString *)context {
    MainTabBarController *tabBarController = [[MainTabBarController alloc] initWithContext:context];
    self.viewControllers = @[tabBarController];
    return tabBarController;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //隐藏底部tabBar
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
}
@end

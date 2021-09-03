//
//  SYMineCollectionManagerViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/4/9.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYMineCollectionManagerViewController.h"
#import <VTMagic/VTMagic.h>
//#import "SYOrderListViewController.h"
#import "SYMineCollectionMomentViewController.h"
#import "SYCollectionVideosViewController.h"

@interface SYMineCollectionManagerViewController ()<VTMagicViewDelegate,VTMagicViewDataSource>
@property(nonatomic, strong) VTMagicController *magicController;

@end

@implementation SYMineCollectionManagerViewController

- (VTMagicController *)magicController{
    if (!_magicController) {
        
        _magicController = [[VTMagicController alloc]init];
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.sliderExtension =0;
        _magicController.magicView.sliderColor =RGBOF(0x23A0F0);
        _magicController.magicView.sliderOffset = -4;
        
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.navigationHeight= 40;
        _magicController.magicView.separatorHidden = NO;
        _magicController.magicView.delegate = self;
        _magicController.magicView.dataSource = self;
        
    }
    return _magicController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    
    [self addChildViewController:self.magicController];
    [self.view addSubview:self.magicController.view];
    self.magicController.view.frame =CGRectMake(0,0,KScreenWidth, KScreenHeight-KNavBarHeight);
    [self.magicController.magicView reloadData];
    
}
#pragma mark -- VTMagicViewDelegate,VTMagicViewDataSource

- (NSArray<__kindof NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView{
    return @[@"动态",@"视频"];
}

- (nonnull UIButton *)magicView:(nonnull VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBOF(0x333333) forState:UIControlStateNormal];
        [menuItem setTitleColor:RGBOF(0x23A0F0) forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex{
    
    if (pageIndex ==0) {
        SYMineCollectionMomentViewController *momentVC =[[SYMineCollectionMomentViewController alloc]init];
        return momentVC;
    }else{
        SYCollectionVideosViewController *videoListVC = [[SYCollectionVideosViewController alloc]init];
        return videoListVC;
    }
    
}
@end

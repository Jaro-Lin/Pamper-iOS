//
//  SYMainViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/4/4.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYMainViewController.h"
#import "UIButton+JKImagePosition.h"
#import "SYMineUserInfoViewController.h"
#import "SYMineFollowViewController.h"
#import "SYMineMomentViewController.h"

#import "SYMineCollectionManagerViewController.h"
#import "SYMineSocietyViewController.h"
#import "SYMineAllPetViewController.h"

#import "baseNavigationController.h"
#import "SYLogManagerViewController.h"

@interface SYMainViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userHead;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userInfo;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (weak, nonatomic) IBOutlet UILabel *careCount;
@property (weak, nonatomic) IBOutlet UILabel *fansCount;
@property (weak, nonatomic) IBOutlet UILabel *momentCount;
@property (weak, nonatomic) IBOutlet UILabel *cardCount;

@property (weak, nonatomic) IBOutlet UIButton *peterBtn;
@property (weak, nonatomic) IBOutlet UIButton *sheQuBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;

@property (weak, nonatomic) IBOutlet UIButton *shopCareBtn;
@property (weak, nonatomic) IBOutlet UIButton *mineOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *myShouHouBtn;
@property (weak, nonatomic) IBOutlet UIButton *kefuBtn;

@end

@implementation SYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人中心";
    
    [self.peterBtn jk_setImagePosition:LXMImagePositionTop spacing:2];
    [self.sheQuBtn jk_setImagePosition:LXMImagePositionTop spacing:2];
    [self.collectionBtn jk_setImagePosition:LXMImagePositionTop spacing:2];
    
    [self.shopCareBtn jk_setImagePosition:LXMImagePositionTop spacing:2];
    [self.mineOrderBtn jk_setImagePosition:LXMImagePositionTop spacing:2];
    [self.myShouHouBtn jk_setImagePosition:LXMImagePositionTop spacing:2];
    [self.kefuBtn jk_setImagePosition:LXMImagePositionTop spacing:2];
    [self buttonsAction];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithTitle:@"退出登录" Font:KFont_M(14) titlesColor:KUIColorFromRGB(0x333333) target:self action:@selector(logoutAction:)];
    
   KViewRadius(self.userHead, 30);
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //更新用户信息
    [self updataUserInfo];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
     MSUserInfoModel *currentModel = [MSUserInformation sharedManager].userInfo;
    //更新用户信息
     [self.userHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageServer,currentModel.avatar]] placeholderImage:kPlaceHoldImageUser];
     self.userName.text = currentModel.nickname;
     self.userInfo.text = currentModel.spe;
}


- (void)updataUserInfo{
    
    [ShareRequest shareRequestDataWithAppendURL:@"/user/about_user/userinfo" Params:nil IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        
        MSUserInfoModel *infoModel = [MSUserInfoModel mj_objectWithKeyValues:dic];
        [[MSUserInformation sharedManager]saveUserInfo:infoModel];
        
        //更新数据
        self.careCount.text = infoModel.follow_count;
        self.fansCount.text = infoModel.fans_count;
        self.momentCount.text = infoModel.post_count;
        self.cardCount.text = infoModel.coupon_count;
        
    } Fail:^(NSError *error) {
        
    }];
    
}

- (void)logoutAction:(UIButton*)sender{
    
  //退出操作
        [ShareRequest shareRequestDataWithAppendURL:@"/user/about_user/exit_login" Params:nil IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
       
        //清除保存的用户信息
        [[MSUserInformation sharedManager]clearUser];
        [UIApplication sharedApplication].keyWindow.rootViewController =[[baseNavigationController alloc]initWithRootViewController:[SYLogManagerViewController new]];
        
    } Fail:^(NSError *error) {
        
    }];

}

- (void)buttonsAction{
    //个人信息
    [[self.moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.navigationController pushViewController:[SYMineUserInfoViewController new] animated:YES];
    }];
    
    //宠物
    [[self.peterBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
          
        [self.navigationController pushViewController:[SYMineAllPetViewController new] animated:YES];
       }];
    //社区
    [[self.sheQuBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
           [self.navigationController pushViewController:[SYMineSocietyViewController new] animated:YES];
       }];
    //收藏
    [[self.collectionBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
           [self.navigationController pushViewController:[SYMineCollectionManagerViewController new] animated:YES];
       }];
    
    //购物车
    [[self.shopCareBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {

       }];
    //我的订单
    [[self.mineOrderBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {

       }];
    //我的售后
    [[self.myShouHouBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {

       }];
    //联系客服
    [[self.kefuBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"已成功复制客服微信号%@请到微信添加客服好友",KWechatServer] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = KWechatServer;
        }];
        
        [alertVC addAction:sureAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }];

}
- (IBAction)follewAction:(UIButton *)sender {
    SYMineFollowViewController *followVC = [[SYMineFollowViewController alloc]init];
    followVC.pageIndex = 1;
    followVC.title = @"我的关注";
    [self.navigationController pushViewController:followVC animated:YES];
}
- (IBAction)fansAction:(UIButton *)sender {
    SYMineFollowViewController *followVC = [[SYMineFollowViewController alloc]init];
    followVC.pageIndex = 2;
    followVC.title = @"我的粉丝";
       [self.navigationController pushViewController:followVC animated:YES];
}
- (IBAction)momentAction:(UIButton *)sender {
    SYMineMomentViewController *momentVC = [[SYMineMomentViewController alloc]init];
    momentVC.title = @"我的动态";
    [self.navigationController pushViewController:momentVC animated:YES];
    
}
- (IBAction)myCardAction:(UIButton *)sender {
    

}



@end

//
//  SYUserEditeViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/4/4.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYUserEditeViewController.h"
#import "UIButton+JKImagePosition.h"
#import "UITextView+YLTextView.h"

@interface SYUserEditeViewController ()
@property (weak, nonatomic) IBOutlet UIView *editeNameView;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;

@property (weak, nonatomic) IBOutlet UIView *editeUserInfoView;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@end

@implementation SYUserEditeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithTitle:@"确定" Font:[UIFont boldSystemFontOfSize:14] titlesColor:KUIColorFromRGB(0x333333) target:self action:@selector(sureAction:)];
    
    self.editeNameView.hidden = (self.inputMoreOneRow ?YES:NO);
    self.infoTextView.hidden = (self.inputMoreOneRow ?NO:YES);
    
    if (self.inputMoreOneRow) {
        self.editeNameView.hidden = YES;
        self.editeUserInfoView.hidden =NO;
        
        if (![self.currentInfoStr isEqualToString:@"这个人什么都没有留下..."]) {
            self.infoTextView.text = self.currentInfoStr;
        }
        self.infoTextView.placeholder = @"这个人什么都没有留下...";
        self.infoTextView.limitLength = @60;
        
    }else{
        self.editeUserInfoView.hidden = YES;
        self.editeNameView.hidden = NO;
        
        self.contentTF.text = self.currentInfoStr;
        self.contentTF.placeholder = @"请输入昵称";
    }
    
    
    
}

- (void)sureAction:(UIButton*)sender{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if (self.inputMoreOneRow) {
        if (kStringIsEmpty(self.infoTextView.text)) {
            [self.view makeToast:@"请说点什么..."];
            return;
        }
        [params setObject:self.infoTextView.text forKey:@"spe"];
    }else{
        if (kStringIsEmpty(self.contentTF.text)) {
            [self.view makeToast:@"请输入昵称"];
            return;
        }
        [params setObject:self.contentTF.text forKey:@"nickname"];
    }
    
    [ShareRequest shareRequestDataWithAppendURL:self.inputMoreOneRow ?@"/user/about_user/change_spe":@"/user/about_user/change_nickname" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        [self.view makeToast:@"保存成功"];
        MSUserInfoModel *userInfoModel = [MSUserInformation sharedManager].userInfo;
        
        if (self.inputMoreOneRow) {
            userInfoModel.spe = self.infoTextView.text;
        }else{
            userInfoModel.nickname = self.contentTF.text;
        }
        [[MSUserInformation sharedManager]saveUserInfo:userInfoModel];
        
        [self.navigationController popViewControllerAnimated:YES];
    } Fail:^(NSError *error) {
        
    }];
    
    
}
@end

//
//  SYBindPhoneNumViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/3/29.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYBindPhoneNumViewController.h"
#import "MainTabBarController.h"

@interface SYBindPhoneNumViewController ()
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIButton *bindLogBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneCodeTF;
@end

@implementation SYBindPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机号";
    
    KViewRadius(self.phoneView, 22);
    KViewRadius(self.codeView, 22);
    KViewRadius(self.bindLogBtn, 20);
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    
    
    [[self.phoneCodeTF rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        if (x.length >=11) {
            self.phoneTF.text = [x substringToIndex:11];
        }
    }];
    
    
}
- (IBAction)sendPhoneCode:(id)sender {
    
    if (![NSString isValidateMobile:self.phoneTF.text]) {
        [self.view makeToast:@"请输入正确的手机号码"];
        return;
    }
    [ShareRequest shareRequestDataWithAppendURL:@"/user/verification_code/send" Params:@{@"username":self.phoneTF.text} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        [self.view makeToast:@"发送成功"];
    } Fail:^(NSError *error) {
        [self.view makeToast:@"发送失败，请重试"];
    }];
}
- (IBAction)bindLogAction:(id)sender {
    
    if (![NSString isValidateMobile:self.phoneTF.text]) {
        [self.view makeToast:@"请输入正确的手机号码"];
        return;
    }
    if (kStringIsEmpty(self.phoneCodeTF.text)) {
        [self.view makeToast:@"请输入手机验证码"];
        return;
    }
    NSMutableDictionary *parames = [[NSMutableDictionary alloc]init];
    
    [parames addEntriesFromDictionary:self.params];
    [parames setObject:self.phoneTF.text forKey:@"phone"];
    [parames setObject:self.phoneCodeTF.text forKey:@"verify_code"];
    
    [ShareRequest shareRequestDataWithAppendURL:@"/user/oauth/reg" Params:parames IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        
        MSUserModel *userModel = [MSUserModel mj_objectWithKeyValues:dic];
        [[MSUserInformation sharedManager] saveUser:userModel];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [[MainTabBarController alloc]initWithContext:@""];
        
    } Fail:^(NSError *error) {
       
        
    }];
}

@end

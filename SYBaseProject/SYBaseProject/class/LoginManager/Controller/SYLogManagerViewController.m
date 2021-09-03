//
//  SYLogManagerViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/3/23.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYLogManagerViewController.h"
#import "SYRegeisterViewController.h"
#import "SYForgatPasswordViewController.h"
#import "SYBindPhoneNumViewController.h"
#import "MainTabBarController.h"

#import "WXApi.h"
#import "TWOAuth.h"
//#import "OpenShare.h"
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApiInterface.h>

@interface SYLogManagerViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *inputPhone;
@property (weak, nonatomic) IBOutlet UITextField *inputPassword;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *regeisterBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *thirdView;

@end

@implementation SYLogManagerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = KUIColorFromRGB(0xffffff);
    
    KViewRadius(self.phoneView, 22);
    KViewRadius(self.passwordView, 22);
    KViewRadius(self.loginBtn, 24);
    KViewRadius(self.regeisterBtn, 24);
    
    self.inputPhone.delegate = self;
    self.sendCodeBtn.hidden = YES;
    self.inputPassword.secureTextEntry = YES;
    
    if (![WXApi isWXAppInstalled]) {
        self.thirdView.hidden = YES;
    }
    
    
}

#pragma mark -- 各种按钮操作
- (IBAction)forgetPasswordAction:(UIButton *)sender {
    [self.navigationController pushViewController:[SYForgatPasswordViewController new] animated:YES];
}
- (IBAction)sendPhoneCode:(id)sender {
    
    if (![NSString isValidateMobile:self.inputPhone.text]) {
        [self.view makeToast:@"请输入正确的手机号码"];
        return;
    }
    [ShareRequest shareRequestDataWithAppendURL:@"/user/verification_code/send" Params:@{@"username":self.inputPhone.text} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        [self.view makeToast:@"发送成功"];
    } Fail:^(NSError *error) {
        [self.view makeToast:@"发送失败，请重试"];
    }];
}

//切换为验证码登陆
- (IBAction)changeLogWey:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected ) {
        self.inputPassword.secureTextEntry = NO;
        self.inputPassword.placeholder = @"请输入手机验证码";
        self.sendCodeBtn.hidden = NO;
        
    }else{
        
        self.inputPassword.secureTextEntry = YES;
        self.inputPassword.placeholder = @"请输入登陆密码";
        self.sendCodeBtn.hidden = YES;
    }
}

- (IBAction)loginAction:(UIButton *)sender {
    
    if (![NSString isValidateMobile:self.inputPhone.text]) {
        [self.view makeToast:@"请输入正确的手机号码"];
        return;
    }
    if (kStringIsEmpty(self.inputPassword.text)) {
        [self.view makeToast:@"请输入登录密码"];
        return;
    }
    NSMutableDictionary *parames = [[NSMutableDictionary alloc]init];
    
    [parames setObject:self.inputPhone.text forKey:@"phone"];
    [parames setObject:@"ios" forKey:@"login_phone"];
    
    [parames setObject:(self.sendCodeBtn.hidden?[NSString md5HexDigest:self.inputPassword.text]:self.inputPassword.text) forKey:(self.sendCodeBtn.hidden?@"password":@"code")];
    
    [ShareRequest shareRequestDataWithAppendURL:(self.sendCodeBtn.hidden?@"/user/login/login_psw":@"/user/login/login_send") Params:parames IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        
        //保存用户信息
        MSUserModel *userModel = [MSUserModel mj_objectWithKeyValues:dic];
        [[MSUserInformation sharedManager] saveUser:userModel];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [[MainTabBarController alloc]initWithContext:@""];
        
    } Fail:^(NSError *error) {
        
    }];
    
}
- (IBAction)regeisterAction:(UIButton *)sender {
    SYRegeisterViewController *regeisterVC = [SYRegeisterViewController new];
    [self.navigationController pushViewController:regeisterVC animated:YES];
}
- (IBAction)weChatLogAction:(UIButton *)sender {
    
    
    [TWOAuth loginToPlatform:TWSNSPlatformWeiXin completionHandle:^(NSDictionary *data, NSError *error){
        NSLog(@"data:%@", data);
        NSLog(@"error:%@", error);

        [ShareRequest shareRequestDataWithAppendURL:@"/user/oauth/login" Params:@{@"type":@"wechat",@"open_id":data[@"openid"],@"device_type":@"ios"} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
            
            MSUserModel *userModel = [MSUserModel mj_objectWithKeyValues:dic];
            [[MSUserInformation sharedManager] saveUser:userModel];
            
            if (userModel.is_reg) {
                [UIApplication sharedApplication].keyWindow.rootViewController = [[MainTabBarController alloc]initWithContext:@""];
            }else{
                
                [self regeisterThirdPlatParames:@{@"type":@"wechat",@"open_id":data[@"openid"],@"device_type":@"ios",@"avatar":data[@"headimgurl"],@"sex":[data[@"sex"]intValue]==0 ?@"0":@"1",@"nickname":data[@"nickname"]}];
            }
        } Fail:^(NSError *error) {
            
        }];
        
    }];
}
- (IBAction)qqLogInAction:(UIButton *)sender {
    
    
    [TWOAuth loginToPlatform:TWSNSPlatformQQ completionHandle:^(NSDictionary *data, NSError *error) {
        NSLog(@"data:%@", data);
        NSLog(@"error:%@", error);
        
        [ShareRequest shareRequestDataWithAppendURL:@"/user/oauth/login" Params:@{@"type":@"qq",@"open_id":data[@"openid"],@"device_type":@"ios"} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
            
            MSUserModel *userModel = [MSUserModel mj_objectWithKeyValues:dic];
            [[MSUserInformation sharedManager] saveUser:userModel];
            
            if (userModel.is_reg) {
                [UIApplication sharedApplication].keyWindow.rootViewController = [[MainTabBarController alloc]initWithContext:@""];
            }else{
                [self regeisterThirdPlatParames:@{@"type":@"qq",@"open_id":data[@"openid"],@"device_type":@"ios",@"avatar":data[@"cover"],@"sex":[data[@"gender"] isEqualToString:@"男"]?@"1":@"0",@"nickname":data[@"nickname"]}];
                
            }
        } Fail:^(NSError *error) {
            
            
        }];
        
    }];
    
}
#pragma mark -- 第三方注册
- (void)regeisterThirdPlatParames:(NSDictionary*)param{
    
    SYBindPhoneNumViewController *bindNum = [SYBindPhoneNumViewController new];
    bindNum.params = param;
    [self.navigationController pushViewController:bindNum animated:YES];

}

#pragma mark --
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
@end

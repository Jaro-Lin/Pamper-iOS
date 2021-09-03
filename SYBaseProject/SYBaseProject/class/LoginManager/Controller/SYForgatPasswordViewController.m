//
//  SYForgatPasswordViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/3/29.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYForgatPasswordViewController.h"

@interface SYForgatPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *surePasswordView;
@property (weak, nonatomic) IBOutlet UIButton *backLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *surePasswordTF;

@end

@implementation SYForgatPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    
    KViewRadius(self.phoneView, 22);
     KViewRadius(self.codeView, 22);
     KViewRadius(self.passwordView, 22);
     KViewRadius(self.surePasswordView, 22);
    
     KViewRadius(self.changeBtn, 22);
     KViewRadius(self.backLoginBtn, 22);
    
//    self.passwordTF.secureTextEntry = YES;
//    self.surePasswordTF.secureTextEntry = YES;
    
    
}
- (IBAction)backToLogPage:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendCodeAction:(id)sender {
    
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
- (IBAction)bindAndLogAction:(id)sender {
    
    if (kStringIsEmpty(self.phoneTF.text)) {
              [self.view makeToast:@"请输入手机号码"];
              return;
          }
       if (kStringIsEmpty(self.phoneCodeTF.text)) {
              [self.view makeToast:@"请输入手机验证码"];
              return;
          }
       if (kStringIsEmpty(self.passwordTF.text)) {
              [self.view makeToast:@"请输入登录密码"];
              return;
          }
       if (kStringIsEmpty(self.surePasswordTF.text)) {
              [self.view makeToast:@"请再次输入登录密码"];
              return;
          }
       if (![self.passwordTF.text isEqualToString:self.surePasswordTF.text]) {
            [self.view makeToast:@"两次输入密码不一致，请重新输入"];
           return;
       }
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];

       [params setObject:self.phoneTF.text forKey:@"phone"];
       [params setObject:self.phoneCodeTF.text forKey:@"code"];
       [params setObject:[NSString md5HexDigest:self.passwordTF.text] forKey:@"password"];
       [params setObject:[NSString md5HexDigest:self.surePasswordTF.text] forKey:@"again_password"];
    
    [ShareRequest shareRequestDataWithAppendURL:@"/user/about_user/forget_password" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        [self.navigationController popViewControllerAnimated:YES];
        
    } Fail:^(NSError *error) {
        
    }];

}


@end

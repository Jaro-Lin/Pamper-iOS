//
//  SYRegeisterViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/3/23.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYRegeisterViewController.h"
#import "SYChoosePeterPopView.h"
#import "zhPopupController.h"
#import "BRAddressPickerView.h"
#import "BRDatePickerView.h"

@interface SYRegeisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *surePasswordTF;

@property (weak, nonatomic) IBOutlet UITextField *sexLB;
@property (weak, nonatomic) IBOutlet UITextField *birsityLB;
@property (weak, nonatomic) IBOutlet UITextField *cityLB;
@property (weak, nonatomic) IBOutlet UIButton *regeisterBtn;

@property(nonatomic, strong) SYCommitPopView *popView;
@end

@implementation SYRegeisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
//    self.view.backgroundColor = KUIColorFromRGB(0xffffff);
    
    self.phoneTF.delegate = self;
    KViewBorderRadius(self.regeisterBtn, 20, 0,[UIColor whiteColor]);
    
    KViewRadius(self.nickNameView, 22);
     KViewRadius(self.phoneView, 22);
     KViewRadius(self.codeView, 22);
     KViewRadius(self.passwordView, 22);
     KViewRadius(self.surePasswordView, 22);
     KViewRadius(self.nickNameView, 22);
     KViewRadius(self.sexView, 22);
     KViewRadius(self.birtyView, 22);
     KViewRadius(self.cityView, 22);
    KViewRadius(self.regeisterBtn, 20);
    
    self.sexLB.enabled = NO;
    self.birsityLB.enabled =NO;
    self.cityLB.enabled = NO;
}

#pragma mark -- 各种操作
- (IBAction)regeisterAction:(UIButton *)sender {
    
    if (kStringIsEmpty(self.nickNameTF.text)) {
        [self.view makeToast:@"请输入用户昵称"];
        return;
    }
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
    if (kStringIsEmpty(self.sexLB.text)) {
           [self.view makeToast:@"请选择性别"];
           return;
       }
    if (kStringIsEmpty(self.birsityLB.text)) {
           [self.view makeToast:@"请选择出生日期"];
           return;
       }
    if (kStringIsEmpty(self.cityLB.text)) {
           [self.view makeToast:@"请选择所在城市"];
           return;
       }
    
    
    //将年 月 日 转换为空字符串
    NSString * birthday = [self.birsityLB.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    birthday = [birthday stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    [params setObject:self.nickNameTF.text forKey:@"nickname"];
    [params setObject:self.phoneTF.text forKey:@"phone"];
    [params setObject:self.phoneCodeTF.text forKey:@"code"];
    [params setObject:[NSString md5HexDigest:self.passwordTF.text] forKey:@"password"];
    [params setObject:[NSString md5HexDigest:self.surePasswordTF.text] forKey:@"password_again"];
    [params setObject:[self.sexLB.text isEqualToString:@"男"]?@"1":@"0" forKey:@"sex"];
    [params setObject:birthday forKey:@"birthday"];
    [params setObject:@"ios" forKey:@"login_phone"];
    [params setObject:self.cityLB.text forKey:@"city"];
    
    [ShareRequest shareRequestDataWithAppendURL:@"/user/login/register" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        
        self.popView = [[SYCommitPopView alloc]initWithFrame:CGRectMake(0, 0, 224, 148)];
        self.popView.messageLB.text = @"注册成功！";
        [self.popView.konowedBtn setTitle:@"返回登陆" forState:UIControlStateNormal];
        
        self.zh_popupController = [zhPopupController popupControllerWithMaskType:zhPopupMaskTypeBlackTranslucent];
        self.zh_popupController.layoutType = zhPopupLayoutTypeCenter;
        self.zh_popupController.slideStyle = zhPopupSlideStyleFade;
        [self.zh_popupController presentContentView:self.popView];
        
        [[self->_popView.konowedBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self.zh_popupController dismiss];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    } Fail:^(NSError *error) {
        
    }];
      
}
- (IBAction)sendPhoneCodeAction:(UIButton *)sender {
    [self.view endEditing:YES];
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
- (IBAction)sexChooseBtn:(UIButton *)sender {
    [self chooseSex];
}
- (IBAction)birsityBtn:(UIButton *)sender {
    [self chooseDate];
}
- (IBAction)cityChooseAction:(UIButton *)sender {
    [self chooseCity];
}

#pragma mark -- 选择城市
- (void)chooseCity{
    
    [BRAddressPickerView showAddressPickerWithDefaultSelected:@[@10, @0, @3] isAutoSelect:NO resultBlock:^(NSArray *selectAddressArr) {
        NSString *string = [NSString stringWithFormat:@"%@%@%@", selectAddressArr[0], selectAddressArr[1], selectAddressArr[2]];
        self.cityLB.text = string;
    }];
}
#pragma mark -- 出生日期
- (void)chooseDate{
    
    [BRDatePickerView showDatePickerWithTitle:@"选择出生日期" dateType:UIDatePickerModeDate defaultSelValue:@"" minDateStr:@"" maxDateStr:@"" isAutoSelect:NO resultBlock:^(NSString *selectValue) {
        self.birsityLB.text = selectValue;
    }];

}
#pragma mark -- 性别
- (void)chooseSex{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexLB.text = @"男";
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexLB.text = @"女";
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:photoAction];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
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

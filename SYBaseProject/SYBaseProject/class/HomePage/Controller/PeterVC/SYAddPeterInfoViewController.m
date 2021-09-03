//
//  SYAddPeterInfoViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/3/28.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYAddPeterInfoViewController.h"
#import "SYChoosePeterPopView.h"
#import "BRDatePickerView.h"

@interface SYAddPeterInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation SYAddPeterInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.isEditeAction ?@"修改宠物信息":@"添加宠物";
    
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    
    self.view.backgroundColor = KUIColorFromRGB(0xffffff);
    self.peterWeight.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.peterSex.enabled = NO;
    self.peterEnd.enabled = NO;
    self.peterBirty.enabled = NO;
    self.petHealthTF.enabled = NO;
    
    KViewRadius(self.lastStepBtn, 24);
    KViewRadius(self.sureCommitBtn, 24);
    
    self.peterPhoto.userInteractionEnabled = YES;
    [self.peterPhoto addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(peterImageChooseAction)]];
    
    [[self.peterNickName rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        self.petInfoModel.nickname = x;
    }];
    
    [[self.peterWeight rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        self.petInfoModel.weight = x;
    }];
    
}

- (void)initView{
    
    if (self.isEditeAction) {//将现有的宠物更新更新上来
        
        [self.peterPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.petInfoModel.server,self.petInfoModel.avatar]] placeholderImage:kPlaceHoldImage];
        
        self.peterNickName.text = self.petInfoModel.nickname;
        self.peterSex.text = [self.petInfoModel.sex intValue]==1 ?@"男":@"女";
        self.peterWeight.text = self.petInfoModel.weight;
        self.peterBirty.text = self.petInfoModel.brithday;
        self.peterEnd.text = [self.petInfoModel.sterilization intValue]==1 ?@"是":@"否";
        self.petHealthTF.text = self.petInfoModel.healthy;
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(deletedPetAction:) image:@"icon_deleted_red" highImage:@"icon_deleted_red" horizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
    }else{
        
        self.petInfoModel = [[SYPetModel alloc]init];
        self.petInfoModel.type_id = self.petModel.type_id;
        self.petInfoModel.varieties_id = self.petModel.ID;
        
    }
    
    self.petKindLB.text = [NSString stringWithFormat:@"品种:%@",self.isEditeAction ?self.petInfoModel.varieties_name:self.petModel.varieties_name];
    [self.sureCommitBtn setTitle:self.isEditeAction ?@"确认修改":@"确认添加" forState:UIControlStateNormal];
}

- (void)returnPageWithClick{
    
    if (self.isEditeAction) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
}
- (IBAction)lastStepAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chooseSexAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self chooseSexOrSterilization:YES];
}
- (IBAction)chooseWeightAction:(UIButton *)sender {
    
}
- (IBAction)chooseBirty:(UIButton *)sender {
    [self.view endEditing:YES];
    [self chooseDate];
    
}
- (IBAction)changeBearStatuAcion:(UIButton *)sender {
    [self.view endEditing:YES];
    [self chooseSexOrSterilization:NO];
}
- (IBAction)petHealthChoose:(UIButton *)sender {
    [self.view endEditing:YES];
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"健康" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.petHealthTF.text = @"健康";
        self.petInfoModel.healthy = @"健康";
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"生病" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.petHealthTF.text = @"生病";
        self.petInfoModel.healthy = @"生病";
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:photoAction];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)commitAction:(id)sender {
    if (kStringIsEmpty(self.petInfoModel.avatar)) {
        [self.view makeToast:@"请上传宠物头像"];
        return;
    }
    if (kStringIsEmpty(self.petInfoModel.nickname)) {
        [self.view makeToast:@"请输入宠物昵称"];
        return;
    }
    if (kStringIsEmpty(self.petInfoModel.sex)) {
        [self.view makeToast:@"请选择宠物性别"];
        return;
    }
    if (kStringIsEmpty(self.petInfoModel.weight)) {
        [self.view makeToast:@"请输入宠物体重"];
        return;
    }
    if (kStringIsEmpty(self.petInfoModel.brithday)) {
        [self.view makeToast:@"请选择宠物出生日期"];
        return;
    }
    if (kStringIsEmpty(self.petInfoModel.sterilization)) {
        [self.view makeToast:@"请选择宠物绝育情况"];
        return;
    }
    if (kStringIsEmpty(self.petInfoModel.healthy)) {
        [self.view makeToast:@"请选择宠物健康情况"];
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:self.petInfoModel.avatar forKey:@"avatar"];
    [param setObject:self.petInfoModel.nickname forKey:@"nickname"];
    [param setObject:self.petInfoModel.sex forKey:@"sex"];
    [param setObject:self.petInfoModel.weight forKey:@"weight"];
    [param setObject:self.petInfoModel.brithday forKey:@"brithday"];
    [param setObject:self.petInfoModel.sterilization forKey:@"sterilization"];
    [param setObject:self.petInfoModel.healthy forKey:@"healthy"];
    
    
    if (self.isEditeAction) {//编辑状态
        [param setObject:self.petInfoModel.pid forKey:@"pid"];
    }else{//添加新的
        [param setObject:self.petInfoModel.type_id forKey:@"type_id"];
    }
    
    [param setObject:self.petInfoModel.varieties_id forKey:@"varieties_id"];
    
    [ShareRequest shareRequestDataWithAppendURL:self.isEditeAction ?@"/pets/pets/update_pets":@"/pets/pets/login" Params:param IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        
        if (self.isEditeAction) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alertVC addAction:sureAction];
            [self presentViewController:alertVC animated:YES completion:nil];
            
        }else{
            
            SYCommitPopView *popView = [[SYCommitPopView alloc]initWithFrame:CGRectMake(0, 0, 224, 148)];
            self.zh_popupController = [zhPopupController popupControllerWithMaskType:zhPopupMaskTypeBlackTranslucent];
            self.zh_popupController.layoutType = zhPopupLayoutTypeCenter;
            self.zh_popupController.slideStyle = zhPopupSlideStyleFade;
            [self.zh_popupController presentContentView:popView];
            [[popView.konowedBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                [self.zh_popupController dismiss];
            }];
            
        }
        
    } Fail:^(NSError *error) {
        
    }];
    
}
#pragma mark -- 删除宠物
- (void)deletedPetAction:(UIButton*)sender{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"删除提示" message:@"是否删除该宠物信息?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
        [ShareRequest shareRequestDataWithAppendURL:@"/pets/pets/del" Params:@{@"pid":self.petInfoModel.pid} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除成功！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alertVC addAction:sureAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        } Fail:^(NSError *error) {
            
        }];
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:sureAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark -- 挑选头像
- (void)peterImageChooseAction {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePicker.delegate = self;
    imagePicker.navigationBar.translucent = NO; //去除毛玻璃效果
    
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"从相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:photoAction];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

#pragma mark - =======UIImagePickerControllerDelegate=========
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (@available(iOS 11.0, *)) {
            [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
        [self updataImageToSever:[info objectForKey:UIImagePickerControllerOriginalImage]];
    }];
    
}

// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 上传头像
- (void)updataImageToSever:(UIImage*)image{
    
    [ShareRequest uploadImg:image appendURL:@"/pets/pets/avatar" IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        //                    NSString *imageUrl =dic[@"data"][@"img"];
        //            [NSString stringWithFormat:@"%@%@",dic[@"data"][@"server"],dic[@"data"][@"img"]];
        self.petInfoModel.avatar = dic[@"data"][@"img"];
        self.peterPhoto.image = image;
    } Fail:^(NSError *error) {
        
    }];
    
}
#pragma mark -- 性别/绝育情况
- (void)chooseSexOrSterilization:(BOOL)isSex{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:isSex ?@"男":@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (isSex) {
            self.petInfoModel.sex = @"1";
            self.peterSex.text = @"男";
        }else{
            self.petInfoModel.sterilization = @"1";
            self.peterEnd.text = @"是";
        }
        
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:isSex ?@"女":@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (isSex) {
            self.petInfoModel.sex = @"0";
            self.peterSex.text = @"女";
        }else{
            self.petInfoModel.sterilization = @"0";
            self.peterEnd.text = @"否";
        }
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:photoAction];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark -- 出生日期
- (void)chooseDate{
    
    [BRDatePickerView showDatePickerWithTitle:@"选择出生日期" dateType:UIDatePickerModeDate defaultSelValue:self.petInfoModel.birthdayStr ?:@"" minDateStr:@"" maxDateStr:@"" isAutoSelect:NO resultBlock:^(NSString *selectValue) {
        if (kStringIsEmpty(selectValue)) return;
        self.petInfoModel.birthdayStr = selectValue;
        NSString *string = [selectValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        self.petInfoModel.brithday = string;
        self.peterBirty.text = selectValue;
    }];
    
}
@end

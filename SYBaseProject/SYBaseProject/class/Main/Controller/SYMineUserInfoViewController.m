//
//  SYMineUserInfoViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/4/4.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYMineUserInfoViewController.h"
#import "SYMineUserInfoTableViewCell.h"
#import "SYUserEditeViewController.h"
#import "BRAddressPickerView.h"
#import "BRDatePickerView.h"

@interface SYMineUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic, strong) NSArray *leftTitlesArr;
@property(nonatomic, strong) MSUserInfoModel *userInfoModel;
@property(nonatomic, strong) NSString *birthdayStr;
@end

@implementation SYMineUserInfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    
    self.title = @"个人信息";
    self.leftTitlesArr = @[@[@"头像"],@[@"昵称",@"性别",@"手机号码",@"出生日期",@"城市",@"简介"]];
    self.mainTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-KNavBarHeight);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView.mj_header beginRefreshing];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.userInfoModel = [MSUserInformation sharedManager].userInfo;
    [self.mainTableView reloadData];
}
- (void)headerRereshing{
    [self.mainTableView.mj_header endRefreshing];
}
- (void)footerRereshing{
    [self.mainTableView.mj_footer endRefreshing];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.leftTitlesArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.leftTitlesArr[section]count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SYMineUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYMineUserInfoTableViewCell"];
    if (!cell) {
        
        cell = (SYMineUserInfoTableViewCell*)[UIView instancesWithNib:@"SYMineUserInfoTableViewCell" index:0];
    }
    cell.staticLB.text = self.leftTitlesArr[indexPath.section][indexPath.row];
    cell.userHead.hidden = indexPath.section == 0 ?NO:YES;
    
    
    cell.rightBtn.hidden = (indexPath.row ==2?YES:NO);
    cell.contentLBMargin.constant = (indexPath.row ==2?22:35);
    
    if (indexPath.section ==0) {
        [cell.userHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageServer,self.userInfoModel.avatar]] placeholderImage:kPlaceHoldImageUser];
        cell.contentLB.text = @"";
    }
    if (indexPath.section ==1) {
        if (indexPath.row ==0) {
            cell.contentLB.text = self.userInfoModel.nickname;
        }else if (indexPath.row ==1) {
            cell.contentLB.text = [self.userInfoModel.sex intValue]==0 ?@"女":@"男";
        }else if (indexPath.row ==2) {
            cell.contentLB.text = self.userInfoModel.phone;
        }else if (indexPath.row ==3) {
            cell.contentLB.text = self.userInfoModel.birthdayStr;
        }else if (indexPath.row ==4) {
            cell.contentLB.text = self.userInfoModel.city;
        }else if (indexPath.row ==5) {
            cell.contentLB.text = self.userInfoModel.spe;
        }
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section ==0 && indexPath.row ==0) {//修改头像
        [self selectImageSource];
    }
    
    if (indexPath.section ==1) {
        if (indexPath.row ==0 || indexPath.row == 5) {//修改昵称--简介
            SYUserEditeViewController *userEditeVC = [[SYUserEditeViewController alloc]init];
            userEditeVC.title =[@"修改" stringByAppendingString:self.leftTitlesArr[indexPath.section][indexPath.row]];
            userEditeVC.currentInfoStr = (indexPath.row ==0 ?self.userInfoModel.nickname:self.userInfoModel.spe);
            userEditeVC.inputMoreOneRow = (indexPath.row ==0 ? NO:YES);
            [self.navigationController pushViewController:userEditeVC animated:YES];
        }else if (indexPath.row ==1){//修改性别
            [self chooseSex];
        }else if (indexPath.row ==3){//修改出生日期
            [self chooseDate];
        }else if (indexPath.row ==4){//修改城市
            [self chooseCity];
        }
    }

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.section == 0 ?68:50;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;;
}

#pragma mark -- 选择城市
- (void)chooseCity{
    
    [BRAddressPickerView showAddressPickerWithDefaultSelected:@[@10, @0, @3] isAutoSelect:NO resultBlock:^(NSArray *selectAddressArr) {
//        NSString *string = [NSString stringWithFormat:@"%@%@%@", selectAddressArr[0], selectAddressArr[1], selectAddressArr[2]];
      
        //目前只上传市
        [self upDataUserInfo:@{@"city":selectAddressArr[1]} urlStr:@"/user/about_user/change_city"];
        
    }];
}
#pragma mark -- 出生日期
- (void)chooseDate{
    
    [BRDatePickerView showDatePickerWithTitle:@"选择出生日期" dateType:UIDatePickerModeDate defaultSelValue:self.userInfoModel.birthdayStr minDateStr:@"" maxDateStr:@"" isAutoSelect:NO resultBlock:^(NSString *selectValue) {
        if (kStringIsEmpty(selectValue)) return;
        self.birthdayStr = selectValue;
        NSString *string = [selectValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self upDataUserInfo:@{@"birthday":string} urlStr:@"/user/about_user/change_birthday"];
    }];

}
#pragma mark -- 性别
- (void)chooseSex{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
   
        [self upDataUserInfo:@{@"sex":@"1"} urlStr:@"/user/about_user/change_sex"];
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       [self upDataUserInfo:@{@"sex":@"0"} urlStr:@"/user/about_user/change_sex"];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:photoAction];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}
#pragma mark -- 挑选头像
- (void)selectImageSource {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePicker.delegate = self;
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"从相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.navigationBar.translucent = NO; 
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
        [self updataImageToSever:[info objectForKey:UIImagePickerControllerOriginalImage]];
       
        if (@available(iOS 11.0, *)) {
            [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
    }];
    
}

// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 上传头像
- (void)updataImageToSever:(UIImage*)image{
    
    [ShareRequest uploadImg:image appendURL:@"/user/about_user/avatar" IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        if([dic[@"code"]integerValue] ==1) {
            
            [self.view makeToast:dic[@"message"]];
            NSString *imageUrl =dic[@"data"][@"img"];
//            [NSString stringWithFormat:@"%@%@",dic[@"data"][@"server"],dic[@"data"][@"img"]];
            [self upDataUserInfo:@{@"file":imageUrl} urlStr:@"/user/about_user/avatar_update"];
        }
        
    } Fail:^(NSError *error) {
        
    }];
}
#pragma mark -- 更新头像到数据库
- (void)upDataUserInfo:(NSDictionary*)param urlStr:(NSString*)url{
    
    [ShareRequest shareRequestDataWithAppendURL:url Params:param IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
       
        if ([url isEqualToString:@"/user/about_user/avatar_update"]) {
            self.userInfoModel.avatar = param[@"file"];
            [self.mainTableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationFade];
        }
        if ([url isEqualToString:@"/user/about_user/change_sex"]) {
             self.userInfoModel.sex = param[@"sex"];
            [self.mainTableView reloadRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationFade];
        }
        if ([url isEqualToString:@"/user/about_user/change_birthday"]) {//出生日期
            self.userInfoModel.birthday = param[@"birthday"];
            self.userInfoModel.birthdayStr =self.birthdayStr;
            [self.mainTableView reloadRow:3 inSection:1 withRowAnimation:UITableViewRowAnimationFade];
        }
        if ([url isEqualToString:@"/user/about_user/change_city"]) {
            self.userInfoModel.city = param[@"city"];
            [self.mainTableView reloadRow:4 inSection:1 withRowAnimation:UITableViewRowAnimationFade];
        }
        
        [[MSUserInformation sharedManager]saveUserInfo:self.userInfoModel];
        
    } Fail:^(NSError *error) {
        
    }];
    
}
@end

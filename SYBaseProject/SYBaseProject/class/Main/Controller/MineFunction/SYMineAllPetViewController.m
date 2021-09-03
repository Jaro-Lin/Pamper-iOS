//
//  SYMineAllPetViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/5/21.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYMineAllPetViewController.h"
#import "SYPetModel.h"
#import "SYAllPetTableViewCell.h"
#import "UIBarButtonItem+Extension.h"
#import "SYAddPeterViewController.h"
#import "SYAddPeterInfoViewController.h"

@interface SYMineAllPetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) NSArray *allPetsArr;
@end

@implementation SYMineAllPetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的宠物";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithTitle:@"添加" Font:KFont_M(14) titlesColor:KUIColorFromRGB(0x333333) target:self action:@selector(addPetAction:)];
    
    self.mainTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-KNavBarHeight);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView.mj_header beginRefreshing];
    
}

- (void)headerRereshing{
    [self requestNetWork];
    
}
- (void)footerRereshing{
    [self requestNetWork];
    
}
- (void)requestNetWork{
    
    //获取所有的宠物信息
    [ShareRequest shareRequestDataWithAppendURL:@"/pets/pets/pets_info" Params:nil IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        self.allPetsArr = [SYPetModel mj_objectArrayWithKeyValuesArray:dic];
        [self.mainTableView reloadData];
        if (self.allPetsArr.count <=0) {
            [self.mainTableView showNoDataStatusWithString:@"还未添加任何宠物" imageName:@"" withOfffset:0];
        }
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    } Fail:^(NSError *error) {
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }];
    
    
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allPetsArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SYAllPetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYAllPetTableViewCell"];
    if (!cell) {
        
        cell = (SYAllPetTableViewCell*)[UIView instancesWithNib:@"SYAllPetTableViewCell" index:0];
    }
    cell.petModel = self.allPetsArr[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SYAddPeterInfoViewController *peterInfoVC = [[SYAddPeterInfoViewController alloc]init];
    peterInfoVC.petInfoModel = self.allPetsArr[indexPath.section];
    peterInfoVC.isEditeAction = YES;
    [self.navigationController pushViewController:peterInfoVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    if (section ==0) {
    //        return 0;
    //    }
    return 5;
}

#pragma mark --
- (void)addPetAction:(UIButton*)sender{
    SYAddPeterViewController *addVC = [[SYAddPeterViewController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
    
}
@end

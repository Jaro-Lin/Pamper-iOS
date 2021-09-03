//
//  SYMineFollowViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/4/7.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYMineFollowViewController.h"
#import "SYMineFollowTableViewCell.h"
#import "SYFansCollectionModel.h"
#import "SYUserDetailViewController.h"
#import "SYHomeThemeModel.h"

@interface SYMineFollowViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) NSMutableArray *dataArrM;
@end

@implementation SYMineFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-KNavBarHeight);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
  
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.mainTableView.mj_header beginRefreshing];
}

- (void)headerRereshing{
    self.currrentPage = 1;
    [self requestNetWork];
}
- (void)footerRereshing{
    if (self.totalCount == self.dataArrM.count) {
        [self.mainTableView.mj_footer endRefreshing];
        return;
    }
    self.currrentPage ++;
    [self requestNetWork];
    
}
- (void)requestNetWork{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSNumber numberWithInteger:self.currrentPage] forKey:@"page"];
    [params setObject:KLimitCount forKey:@"limit"];
    
    [ShareRequest shareRequestDataWithAppendURL:self.pageIndex == 1?@"/user/personal/follow":@"/user/personal/fans" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        if (self.currrentPage ==1) {
            [self.dataArrM removeAllObjects];
        }
        self.totalCount = [dic[@"total"] integerValue];
        [self.dataArrM addObjectsFromArray:[SYFansCollectionModel mj_objectArrayWithKeyValuesArray:dic[@"list"]]];
        if (self.dataArrM.count ==0) {
            [self.mainTableView showNoDataStatusWithString:self.pageIndex == 1?@"未关注其他人":@"未关注任何人" withOfffset:-80];
        }
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
    } Fail:^(NSError *error) {
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }];
}


#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArrM.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SYMineFollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYMineFollowTableViewCell"];
    if (!cell) {
        
        cell = (SYMineFollowTableViewCell*)[UIView instancesWithNib:@"SYMineFollowTableViewCell" index:0];
    }
    cell.fansCollectionModel = self.dataArrM[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SYUserDetailViewController *detailVC = [[SYUserDetailViewController alloc]init];
    SYHomeThemeModel *themeModel = [[SYHomeThemeModel alloc]init];
    SYFansCollectionModel *fansCollectionModel = self.dataArrM[indexPath.section];
    themeModel.uid =fansCollectionModel.uid;
    detailVC.momentModel = themeModel;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 68;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 4;
}
- (NSMutableArray *)dataArrM{
    if (!_dataArrM) {
        _dataArrM = [[NSMutableArray alloc]init];
    }
    return _dataArrM;
}
@end

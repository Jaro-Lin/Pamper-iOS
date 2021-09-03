//
//  SYRecordHealthViewController.m
//  SYBaseProject
//
//  Created by apple on 2020/7/21.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYRecordHealthViewController.h"
#import "SYRecordNoticeTableViewCell.h"
#import "SYRecoedHealthModel.h"

@interface SYRecordHealthViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation SYRecordHealthViewController
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身体状况";
    
    self.mainTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-KNavBarHeight);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.mainTableView registerNib:[UINib nibWithNibName:@"SYRecordNoticeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SYRecordNoticeTableViewCell"];
    [self.view addSubview:self.mainTableView];
   
    [self.mainTableView.mj_header beginRefreshing];
    self.mainTableView.mj_header.automaticallyChangeAlpha = YES;
}

- (void)headerRereshing{
    [self getAllSeak];
    
}
- (void)footerRereshing{
    [self.mainTableView.mj_footer endRefreshing];
}

- (void)getAllSeak{

    [ShareRequest shareRequestDataWithAppendURL:@"/pets/malady/all" Params:@{} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:[SYRecoedHealthModel mj_objectArrayWithKeyValuesArray:dic[@"datalist"]]];
        
        if (self.dataSource.count <=0) {
            [self.mainTableView showNoDataStatusWithString:@"未获取到健康状况，请重试" withOfffset:0];
        }
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
    } Fail:^(NSError *error) {
        [self.mainTableView.mj_header endRefreshing];
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SYRecordNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYRecordNoticeTableViewCell"];
    cell.healthModel = self.dataSource[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   SYRecoedHealthModel *healthModel = self.dataSource[indexPath.row];
    
    return 70 +ceil(healthModel.child.count/3.0)*40;
}
@end

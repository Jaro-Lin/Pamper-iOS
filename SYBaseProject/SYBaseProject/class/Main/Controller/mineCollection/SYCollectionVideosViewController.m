//
//  SYCollectionVideosViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/4/9.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYCollectionVideosViewController.h"
#import "SYCollectionVideosTableViewCell.h"
#import "SYCollectionVideoModel.h"
#import "SYClassPlayViewController.h"

@interface SYCollectionVideosViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) NSMutableArray *dataArrM;
@end

@implementation SYCollectionVideosViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-KNavBarHeight-40);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor];
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

    [ShareRequest shareRequestDataWithAppendURL:@"/user/personal/video" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        if (self.currrentPage ==1) {
            [self.dataArrM removeAllObjects];
        }
        self.totalCount = [dic[@"total"] integerValue];
        [self.dataArrM addObjectsFromArray:[SYCollectionVideoModel mj_objectArrayWithKeyValuesArray:dic[@"list"]]];
        if (self.dataArrM.count ==0) {
            [self.mainTableView showNoDataStatusWithString:@"未收藏任何视频" withOfffset:-80];
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
    
    SYCollectionVideosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYCollectionVideosTableViewCell"];
    if (!cell) {
        
        cell = (SYCollectionVideosTableViewCell*)[UIView instancesWithNib:@"SYCollectionVideosTableViewCell" index:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.videoModel = self.dataArrM[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SYCollectionVideoModel *classModel = self.dataArrM[indexPath.row];
    SYClassPlayViewController *playVC = [[SYClassPlayViewController alloc]init];
   
    playVC.course_id = classModel.video_id;
    playVC.type_id = classModel.type_id;
    [self.navigationController pushViewController:playVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 99;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section ==0 ?10:4;
}
- (NSMutableArray *)dataArrM{
    if (!_dataArrM) {
        _dataArrM = [[NSMutableArray alloc]init];
    }
    return _dataArrM;
}
@end

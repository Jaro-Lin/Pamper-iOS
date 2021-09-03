//
//  SYMineCollectionMomentViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/4/9.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYMineCollectionMomentViewController.h"
#import "SYHomeThemeModel.h"
#import "SYCustomTableViewCell.h"
#import "SYUserDetailViewController.h"
#import "SYTopicListViewController.h"
#import "SYMomentDetailViewController.h"
#import "MSShareView.h"

@interface SYMineCollectionMomentViewController () <UITableViewDataSource, UITableViewDelegate,YjxCustomTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArrM;

@end
@implementation SYMineCollectionMomentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-KNavBarHeight-40);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    
    _dataArrM = @[].mutableCopy;
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
    
    [ShareRequest shareRequestDataWithAppendURL:@"/user/personal/post" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        if (self.currrentPage ==1) {
            [self.dataArrM removeAllObjects];
        }
        self.totalCount = [dic[@"total"] integerValue];
        [self.dataArrM addObjectsFromArray:[SYHomeThemeModel mj_objectArrayWithKeyValuesArray:dic[@"list"]]];
        if (self.dataArrM.count ==0) {
            [self.mainTableView showNoDataStatusWithString:@"未收藏任何动态" withOfffset:-80];
        }
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
    } Fail:^(NSError *error) {
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }];
}
#pragma mark - UITableViewDelegate  UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KAdaptW(10);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArrM.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYHomeThemeModel *model = self.dataArrM[indexPath.section];
    CGFloat height = 0;
    NSArray*imagesArr = (model.images.count >0 ?model.images:model.image);
    if (imagesArr.count >0) {
        height = ceil(imagesArr.count/3.0)*KCollectionWidth/3.0+((ceil(imagesArr.count/3.0)-1))*KAdaptW(8);
    }
    if (model.video.count >0) {
        height =(KCollectionWidth/3.0)*2;
    }
    return KAdaptW(120)+height+30+[UILabel getDynamicSizeText:model.content WithFrame:CGSizeMake(KScreenWidth-KAdaptW(35), MAXFLOAT) WithFont:12];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    SYCustomTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[SYCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = NO;
    SYHomeThemeModel *model = self.dataArrM[indexPath.section];
    cell.cellDelegate = self;
    cell.momentModel = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYMomentDetailViewController *momentDetailVC = [[SYMomentDetailViewController alloc]init];
    momentDetailVC.momentModel = self.dataArrM[indexPath.section];
    [self.navigationController pushViewController:momentDetailVC animated:YES];
}

#pragma mark --YjxCustomTableViewCellDelegate
- (void)topicBtnClick:(SYCustomTableViewCell *)cell{
    
    SYTopicListViewController *topicVC = [[SYTopicListViewController alloc]init];
    [self.navigationController pushViewController:topicVC animated:YES];
    
}

- (void)commontAction:(SYCustomTableViewCell *)cell{
    SYMomentDetailViewController *momentDetailVC = [[SYMomentDetailViewController alloc]init];
    momentDetailVC.momentModel = cell.momentModel;
    [self.navigationController pushViewController:momentDetailVC animated:YES];
}
- (void)starAction:(SYCustomTableViewCell *)cell{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"post" forKey:@"module"];
    [params setObject:cell.momentModel.post_id forKey:@"module_id"];
    [params setObject:cell.momentModel.comment_id forKey:@"comment_id"];
    [params setObject:(cell.momentModel.if_good?@"0":@"1") forKey:@"good"];
    
    [ShareRequest shareRequestDataWithAppendURL:@"/comment/comment/good" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        cell.momentModel.if_good = !cell.momentModel.if_good;
        cell.toolbar.starBtn.selected = cell.momentModel.if_good;
        [cell.toolbar.starBtn setTitle:[NSString stringWithFormat:@"%ld",(long)[cell.momentModel.good integerValue]+(cell.momentModel.if_good ?1:0)] forState:UIControlStateNormal];
    } Fail:^(NSError *error) {
        
    }];
    
    
}
- (void)collectionAction:(SYCustomTableViewCell *)cell{
    
    [ShareRequest shareRequestDataWithAppendURL:@"/post/post_about/collection" Params:@{@"post_id":cell.momentModel.post_id} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        cell.momentModel.if_collection = !cell.momentModel.if_collection;
        cell.toolbar.collectionBtn.selected = cell.momentModel.if_collection;
        [cell.toolbar.collectionBtn setTitle:[NSString stringWithFormat:@"%ld",(long)[cell.momentModel.collection integerValue]+(cell.momentModel.if_collection ?1:0)] forState:UIControlStateNormal];
    } Fail:^(NSError *error) {
        
    }];
    
}
- (void)shareAction:(SYCustomTableViewCell *)cell{
    
    MSShareView *shareView = (MSShareView*)[UIView instancesWithNib:@"MSShareView" index:0];
    [shareView showPopView:@"post"];
}
- (void)headIconTapClick:(SYCustomTableViewCell *)cell{
    
    SYUserDetailViewController *detailVC = [[SYUserDetailViewController alloc]init];
    detailVC.momentModel = cell.momentModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)dealloc {
    NSLog(@"----- %@ delloc", self.class);
}
@end

//
//  SYTopicMomentsViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/3/30.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYTopicMomentsViewController.h"
#import "SYCustomTableViewCell.h"
#import "SYHomeThemeModel.h"
#import "SYTopicListViewController.h"
#import "SYUserDetailViewController.h"
#import "SYMomentDetailViewController.h"
#import "MSShareView.h"
#import "SYMomentDetailViewController.h"

@interface SYTopicMomentsViewController () <UITableViewDataSource, UITableViewDelegate,YjxCustomTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
/// 占位cell高度
@property (nonatomic, assign) CGFloat placeHolderCellHeight;

@end

@implementation SYTopicMomentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-KNavBarHeight);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView.mj_header beginRefreshing];
    
    _dataArray = @[].mutableCopy;
}

- (void)headerRereshing{
    self.currrentPage = 1;
    [self requestNetWork];
}
- (void)footerRereshing{
    if (self.totalCount == self.dataArray.count) {
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
    [params setObject:self.themeID forKey:@"theme_id"];
    
    [ShareRequest shareRequestDataWithAppendURL:@"/post/theme/theme_info" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        if (self.currrentPage ==1) {
            [self.dataArray removeAllObjects];
        }
        self.totalCount = [dic[@"total"] integerValue];
        
        [self.dataArray addObjectsFromArray:[SYHomeThemeModel mj_objectArrayWithKeyValuesArray:dic[@"list"]]];
        
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
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYHomeThemeModel *model = self.dataArray[indexPath.section];
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
    SYHomeThemeModel *model = self.dataArray[indexPath.section];
    cell.cellDelegate = self;
    cell.momentModel = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SYMomentDetailViewController *momentDetailVC = [[SYMomentDetailViewController alloc]init];
    momentDetailVC.momentModel = self.dataArray[indexPath.section];
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
    [params setObject:cell.momentModel.ID forKey:@"module_id"];
    [params setObject:cell.momentModel.comment_id forKey:@"comment_id"];
    [params setObject:(cell.momentModel.if_good?@"0":@"1") forKey:@"good"];
    
    [ShareRequest shareRequestDataWithAppendURL:@"/comment/comment/good" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        cell.momentModel.if_good = !cell.momentModel.if_good;
        cell.toolbar.starBtn.selected = cell.momentModel.if_good;
        [cell.toolbar.starBtn setTitle:[NSString stringWithFormat:@"%ld",(long)[cell.momentModel.good integerValue]+(cell.momentModel.if_good ?1:-1)] forState:UIControlStateNormal];
        cell.momentModel.good = cell.toolbar.starBtn.titleLabel.text;
    } Fail:^(NSError *error) {
        
    }];
    
}
- (void)collectionAction:(SYCustomTableViewCell *)cell{
    
    [ShareRequest shareRequestDataWithAppendURL:@"/post/post_about/collection" Params:@{@"post_id":cell.momentModel.ID} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        cell.momentModel.if_collection = !cell.momentModel.if_collection;
        cell.toolbar.collectionBtn.selected = cell.momentModel.if_collection;
        [cell.toolbar.collectionBtn setTitle:[NSString stringWithFormat:@"%ld",(long)[cell.momentModel.collection integerValue]+(cell.momentModel.if_collection ?1:-1)] forState:UIControlStateNormal];
        cell.momentModel.collection = cell.toolbar.collectionBtn.titleLabel.text;
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
@end

//
//  SYUserMomentDetailViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/3/26.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYUserDetailViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "SYUserDetailHeadView.h"

#import "SYCustomTableViewCell.h"
#import "SYHomeThemeModel.h"
#import "SYMomentDetailViewController.h"
#import "SYTopicListViewController.h"
#import "MSShareView.h"

@interface SYUserDetailViewController ()<UITableViewDelegate,UITableViewDataSource,YjxCustomTableViewCellDelegate>
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) SYUserDetailHeadView *userHeadView;
@property(nonatomic, strong) NSDictionary *userInfoDic;
@end

@implementation SYUserDetailViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (SYUserDetailHeadView *)userHeadView{
    if (!_userHeadView) {
        _userHeadView = (SYUserDetailHeadView*)[UIView instancesWithNib:@"SYUserDetailHeadView" index:0];
        _userHeadView.frame = CGRectMake(0, 0, KScreenWidth, KAdaptW(152));
    }
    return _userHeadView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户详情";
    
    self.mainTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-KNavBarHeight);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.tableHeaderView = self.userHeadView;
    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView.mj_header beginRefreshing];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(shareAction:) image:@"icon_share_big" highImage:@"icon_share_big" horizontalAlignment:UIControlContentHorizontalAlignmentCenter];
}

-(void)headerRereshing{
    self.currrentPage = 1;
    [self requestNetWork];
}

-(void)footerRereshing{
    self.currrentPage ++;
    if (self.totalCount == self.dataArray.count) {
        [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [self requestNetWork];
}

- (void)requestNetWork{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_group_t group = dispatch_group_create();
    for (int i = 0; i < 2; i++) {
        dispatch_group_enter(group);
        
        if (i ==0) {
            
            [ShareRequest shareRequestDataWithAppendURL:@"/user/about_user/userinfo_other" Params:@{@"uid":self.momentModel.uid} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
                self.userInfoDic = dic;
                dispatch_group_leave(group);
            } Fail:^(NSError *error) {
                dispatch_group_leave(group);
            }];
            
        }else{
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setObject:[NSNumber numberWithInteger:self.currrentPage] forKey:@"page"];
            [params setObject:KLimitCount forKey:@"limit"];
            [params setObject:self.momentModel.uid forKey:@"uid"];
            
            [ShareRequest shareRequestDataWithAppendURL:@"/user/personal/other_user_post" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
                
                if (self.currrentPage ==1) {
                    [self.dataArray removeAllObjects];
                }
                self.totalCount = [dic[@"total"] integerValue];
                [self.dataArray addObjectsFromArray:[SYHomeThemeModel mj_objectArrayWithKeyValuesArray:dic[@"list"]]];
                
                
                [self.mainTableView.mj_header endRefreshing];
                [self.mainTableView.mj_footer endRefreshing];
                
                dispatch_group_leave(group);
            } Fail:^(NSError *error) {
                dispatch_group_leave(group);
            }];
        }
        
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{

        //更新数据
        [self.userHeadView.userHeadView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageServer,self.userInfoDic[@"avatar"]]] placeholderImage:kPlaceHoldImageUser];
        self.userHeadView.userName.text = self.userInfoDic[@"nickname"];
        self.userHeadView.userInfoLB.text = self.userInfoDic[@"spe"];
        self.userHeadView.sexImageView.image = ([self.userInfoDic[@"sex"] intValue] ==1 ?kImageWithName(@"icon_man"):kImageWithName(@"icon_woman"));
        
        self.userHeadView.addressLB.text = self.userInfoDic[@"city"];
        self.userHeadView.flowerLB.text = [self.userInfoDic[@"follow"] stringValue];
        self.userHeadView.fansLB.text = [self.userInfoDic[@"fans"]stringValue];
        self.userHeadView.collectionBtn.selected = [self.userInfoDic[@"if_follow"] boolValue];
        
//        if ([self.userInfoDic[@"uid"] isEqualToString:[MSUserInformation sharedManager].user.uid]) {//自己的详情,不显示收藏按钮
//            self.userHeadView.collectionBtn.hidden = YES;
//        }
        
        
        [[self.userHeadView.collectionBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            [ShareRequest shareRequestDataWithAppendURL:@"/user/about_user/follow" Params:@{@"uid":self.userInfoDic[@"uid"]} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
                [self.view makeToast:(self.userHeadView.collectionBtn.selected ?@"取消关注成功":@"关注成功") duration:1.5f position:CSToastPositionCenter];
                 self.userHeadView.collectionBtn.selected = ! self.userHeadView.collectionBtn.selected;
                
            } Fail:^(NSError *error) {
                
            }];
            
        }];
        
        
        [self.mainTableView reloadData];
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    });
    
}

#pragma mark --UITableViewDelegate,UITableViewDataSource
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
@end

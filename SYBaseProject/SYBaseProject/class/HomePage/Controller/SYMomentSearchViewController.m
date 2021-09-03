//
//  SYMomentSearchViewController.m
//  SYBaseProject
//
//  Created by apple on 2020/6/9.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYMomentSearchViewController.h"
#import "SYSearchSubView.h"
#import "SYCustomTableViewCell.h"
#import "SYMomentDetailViewController.h"
#import "SYTopicListViewController.h"
#import "SYUserDetailViewController.h"
#import "MSShareView.h"

@interface SYMomentSearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,YjxCustomTableViewCellDelegate>
@property(nonatomic, strong) SYSearchSubView *searchHeadView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation SYMomentSearchViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (@available(iOS 11.0, *)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.searchHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                make.left.mas_offset(0);
                make.right.mas_equalTo(0);
            }];
        });
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.searchHeadView.searchTF becomeFirstResponder];
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchHeadView = (SYSearchSubView*)[UIView instancesWithNib:@"SYSearchSubView" index:0];
    self.searchHeadView.frame = CGRectMake(0, 0, KScreenWidth, KNavBarHeight);
    self.searchHeadView.searchTF.returnKeyType = UIReturnKeySearch;
    self.searchHeadView.searchTF.delegate = self;
    self.navigationItem.titleView = self.searchHeadView;
    [[self.searchHeadView.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    self.view.backgroundColor = KUIColorFromRGB(0xeeeeee);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.frame = CGRectMake(0,0, KScreenWidth, KScreenHeight-KNavBarHeight);
    [self.mainTableView registerClass:[SYCustomTableViewCell class] forCellReuseIdentifier:@"SYCustomTableViewCell"];
    
    self.mainTableView.backgroundColor= [UIColor clearColor];
    //高度自适应
    self.mainTableView.rowHeight = UITableViewAutomaticDimension;
    self.mainTableView.estimatedRowHeight = 50;
    [self.view addSubview:self.mainTableView];
}

-(void)headerRereshing{
    self.currrentPage = 1;
    [self requestNetWork];
}

-(void)footerRereshing{
    self.currrentPage ++;
    if (self.totalCount == self.dataArray.count) {
        [self.mainTableView.mj_footer endRefreshing];
        return;
    }
    [self requestNetWork];
}

- (void)requestNetWork{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSNumber numberWithInteger:self.currrentPage] forKey:@"page"];
    [params setObject:KLimitCount forKey:@"limit"];
    if (!kStringIsEmpty(self.searchHeadView.searchTF.text)) {
        [params setObject:self.searchHeadView.searchTF.text forKey:@"content"];
        
    }else{
        [self.view makeToast:@"请输入关键词"];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        return;
    }
    
    [ShareRequest shareRequestDataWithAppendURL:@"/post/post_about/search_post" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            if (self.currrentPage ==1) {
                [self.dataArray removeAllObjects];
            }
            self.totalCount = [dic[@"total"] integerValue];
            [self.dataArray addObjectsFromArray:[SYHomeThemeModel mj_objectArrayWithKeyValuesArray:dic[@"list"]]];
            
            if (self.dataArray.count ==0) {
                [self.mainTableView showNoDataStatusWithString:@"没有相关结果" withOfffset:0];
            }
            [self.mainTableView reloadData];
        }
        
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
-(void)clickFoldLabel:(SYCustomTableViewCell *)cell{
    
    NSIndexPath * indexPath = [self.mainTableView indexPathForCell:cell];
    SYHomeThemeModel *model = self.dataArray[indexPath.row];
    [UIView setAnimationsEnabled:NO];
    [self.mainTableView beginUpdates];
    [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.mainTableView endUpdates];
    [UIView setAnimationsEnabled:YES];
    
}

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
        
        [cell.toolbar.collectionBtn setTitle:[NSString stringWithFormat:@"%ld",[cell.momentModel.collection integerValue]+(cell.momentModel.if_collection ?1:0)] forState:UIControlStateNormal];
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
#pragma mark --UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.currrentPage = 1;
    [self.mainTableView.mj_header beginRefreshing];
}
@end

//
//  SYMineMomentViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/4/7.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYMineMomentViewController.h"
#import "SYCustomTableViewCell.h"
#import "SYUserDetailViewController.h"
#import "SYHomeThemeModel.h"
#import "SYTopicListViewController.h"
#import "SYMomentDetailViewController.h"
#import "MSShareView.h"

@interface SYMineMomentViewController () <UITableViewDataSource, UITableViewDelegate,YjxCustomTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArrM;

@end
@implementation SYMineMomentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-KNavBarHeight);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView.mj_header beginRefreshing];
    
    _dataArrM = @[].mutableCopy;
    
    //    [self addTableViewRefresh];
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
    
    [ShareRequest shareRequestDataWithAppendURL:@"/user/personal/post_user" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        if (self.currrentPage ==1) {
            [self.dataArrM removeAllObjects];
        }
        self.totalCount = [dic[@"total"] integerValue];
        [self.dataArrM addObjectsFromArray:[SYHomeThemeModel mj_objectArrayWithKeyValuesArray:dic[@"list"]]];
        if (self.dataArrM.count ==0) {
            [self.mainTableView showNoDataStatusWithString:@"未发布任何动态" withOfffset:-80];
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
    cell.cellDelegate = self;
    cell.momentModel = self.dataArrM[indexPath.section];
    //显示删除按钮
    cell.deletedBtn.hidden = NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SYUserDetailViewController *detailVC = [[SYUserDetailViewController alloc]init];
    detailVC.momentModel = self.dataArrM[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

////侧滑允许编辑cell
//- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath{
//    return YES;
//}
//
////执行删除操作
//- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath{
//     [self.view makeToast:@"删除动态"];
//}
//
////侧滑出现的文字
//- (NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath{
//    return @"删除";
//}


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
- (void)deletedAction:(SYCustomTableViewCell *)cell{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除此动态，删除后不可恢复" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [ShareRequest shareRequestDataWithAppendURL:@"/post/send/del_post" Params:@{@"post_id":cell.momentModel.post_id} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
            
            NSInteger index = [self.dataArrM indexOfObject:cell.momentModel];
            [self.dataArrM removeObjectAtIndex:index];
            [self.mainTableView reloadData];
            [self.view makeToast:@"删除成功"];
            
        } Fail:^(NSError *error) {
            
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:sureAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)dealloc {
    NSLog(@"----- %@ delloc", self.class);
}
@end

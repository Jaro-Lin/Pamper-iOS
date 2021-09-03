//
//  SYMomentDetailViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/3/26.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYMomentDetailViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "SYCustomTableViewCell.h"
#import "SYHomeThemeModel.h"
#import "SYCommontTableViewCell.h"
#import "YBPopupMenu.h"
#import "SYJuBaoViewController.h"
#import "SYCommontModel.h"
#import "SYUserDetailHeadView.h"
#import "SYCommentDetailViewController.h"
#import "UITextView+YLTextView.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import <IQKeyboardManager/IQKeyboardManager.h>
#import "MSShareView.h"
#import "SYChatKeyBoardView.h"
#import "UITextView+WZB.h"
#import "NSObject+getCurrentViewController.h"

#define KchatKeyBoardHeight 40
@interface SYMomentDetailViewController ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate,SYCommontTableViewCellDelegate,SYChatKeyBoardViewDelegate>
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) UIView *tableHeadView;
@property(nonatomic, strong) SYCustomTableViewCell *momentCell;
@property (nonatomic,assign) CGFloat tableHeadViewHeight;
/** 聊天键盘 */
@property(nonatomic, strong) SYChatKeyBoardView *chatBoardView;
///是否是二级评论
@property (nonatomic,assign) BOOL secondLevelCommont;
@property(nonatomic, strong) SYCommontModel *commontModel_current;
@end

@implementation SYMomentDetailViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (UIView *)tableHeadView{
    if (!_tableHeadView) {
        
        _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.tableHeadViewHeight)];
        _tableHeadView.backgroundColor = [UIColor whiteColor];
        
        self.momentCell = [[SYCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableHeadView"];
        self.momentCell.frame = CGRectMake(0, 0, KScreenWidth, self.tableHeadViewHeight);
        self.momentCell.selectionStyle = NO;
        self.momentCell.momentModel = self.momentModel;
        self.momentCell.toolbar.barType = toolBarView_listDetail;
        
        [_tableHeadView addSubview:self.momentCell];
    }
    return _tableHeadView;
}
- (SYChatKeyBoardView *)chatBoardView{
    if (!_chatBoardView) {
        _chatBoardView = (SYChatKeyBoardView*)[UIView instancesLastWithNib:@"SYChatKeyBoardView"];
        _chatBoardView.delegate = self;
    }
    return _chatBoardView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mainTableView.mj_header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItems = [UIBarButtonItem ItemsWithTitles:@[@"icon_threePoint",@"icon_share_big"] Font:[UIFont systemFontOfSize:12] titlesColor:[UIColor whiteColor] target:self action:@selector(rightBarAction:) itemsType:itemType_images];
    
    CGFloat height = 0;
    NSArray*imagesArr = (self.momentModel.images.count >0 ?self.momentModel.images:self.momentModel.image);
    if (imagesArr.count >0) {
        height = ceil(imagesArr.count/3.0)*KCollectionWidth/3.0+((ceil(imagesArr.count/3.0)-1))*KAdaptW(8);
    }
    if (self.momentModel.video.count >0) {
        height =(KCollectionWidth/3.0)*2;
    }
    self.tableHeadViewHeight = KAdaptW(120)+height+30+[UILabel getDynamicSizeText:self.momentModel.content WithFrame:CGSizeMake(KScreenWidth-KAdaptW(35), MAXFLOAT) WithFont:12];
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"SYCommontTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SYCommontTableViewCell"];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.tableHeaderView = self.tableHeadView;
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.topMargin.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(-KTabBarSafe_Height-KchatKeyBoardHeight);
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.chatBoardView.frame = CGRectMake(0,KScreenHeight-KNavBarHeight-KTabBarSafe_Height-KchatKeyBoardHeight, KScreenWidth, KchatKeyBoardHeight);
        [self.view addSubview:self.chatBoardView];
        self.chatBoardView.inputTextView.placeholder = @"请输入评论....";
        [self.chatBoardView.inputTextView autoHeightWithMaxHeight:KchatKeyBoardHeight*2 textViewHeightDidChanged:^(CGFloat currentTextViewHeight) {
            
            NSLog(@"当前输入框:%lf.......父视图:%lf",currentTextViewHeight,self.chatBoardView.height);
            
            self.chatBoardView.inputTextViewHeightMargin.constant = currentTextViewHeight;
            self.chatBoardView.frame = CGRectMake(0, KScreenHeight-KNavBarHeight-KTabBarSafe_Height-KchatKeyBoardHeight/4.0-currentTextViewHeight, KScreenWidth, KchatKeyBoardHeight/4.0+CGRectGetHeight(self.chatBoardView.inputTextView.frame));
            
        }];
        [self.chatBoardView.inputTextView addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(customPrevious) nextAction:@selector(customNext) doneAction:@selector(customDone)];
    });
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
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)self.currrentPage] forKey:@"page"];
    [param setObject:KLimitCount forKey:@"limit"];
    [param setObject:self.momentModel.post_id?:self.momentModel.ID?:self.momentModel.ID forKey:@"module_id"];
    [param setObject:@"post" forKey:@"module"];
    [param setObject:self.momentModel.comment_id forKey:@"comment_id"];
    
    [ShareRequest shareRequestDataWithAppendURL:@"/comment/comment/list" Params:param IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        
        if (self.currrentPage ==1) {
            [self.dataArray removeAllObjects];
        }
        self.totalCount = [dic[@"total"] integerValue];
        [self.momentCell.toolbar.commontBtn setTitle:[NSString stringWithFormat:@"评论(%ld)",self.totalCount] forState:UIControlStateNormal];
        
        [self.dataArray addObjectsFromArray:[SYCommontModel mj_objectArrayWithKeyValuesArray:dic[@"datalist"]]];
        if (self.dataArray.count ==0) {
            [self.mainTableView showNoDataStatusWithString:@"暂无评论" imageName:@"icon_noCommont" withOfffset:self.tableHeadViewHeight/3.0];
        }
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
        
    } Fail:^(NSError *error) {
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }];
    
    
    [self.momentCell.toolbar.commontBtn setTitle:[NSString stringWithFormat:@"评论(%@)",self.momentModel.comment] forState:UIControlStateNormal];
    
    NSString *tltleStr = (self.momentModel.if_good ?[NSString stringWithFormat:@"已点赞(%@)",self.momentModel.good]:[NSString stringWithFormat:@"点赞(%@)",self.momentModel.good]);
    [self.momentCell.toolbar.starBtn setTitle:tltleStr forState:UIControlStateNormal];
    
    NSString *collectionStr = (self.momentModel.collection ?[NSString stringWithFormat:@"已收藏(%@)",self.momentModel.collection]:[NSString stringWithFormat:@"收藏(%@)",self.momentModel.collection]);
    [self.momentCell.toolbar.collectionBtn setTitle:collectionStr forState:UIControlStateNormal];
    
    self.chatBoardView.likeBtn.selected = self.momentModel.if_good;
    self.chatBoardView.collectionBtn.selected = self.momentModel.if_collection;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView fd_heightForCellWithIdentifier:@"SYCommontTableViewCell" cacheByKey:indexPath configuration:^(SYCommontTableViewCell *cell) {
        cell.commontModel = self.dataArray[indexPath.section];
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYCommontTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYCommontTableViewCell"];
    cell.selectionStyle = NO;
    cell.delegate = self;
    cell.commontModel = self.dataArray[indexPath.section];
    
    [[cell.starBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        SYCommontModel *model = self.dataArray[indexPath.section];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:@"post" forKey:@"module"];
        [params setObject:self.momentModel.post_id?:self.momentModel.ID forKey:@"module_id"];
        [params setObject:model.ID forKey:@"comment_id"];
        [params setObject:(model.is_good?@"0":@"1") forKey:@"good"];
        
        [ShareRequest shareRequestDataWithAppendURL:@"/comment/comment/good" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
            model.is_good = !model.is_good;
            cell.starBtn.selected = model.is_good;
            model.total_like = [NSString stringWithFormat:@"%ld",(long)([model.total_like integerValue]+(model.is_good?1:-1))];
        } Fail:^(NSError *error) {
            
        }];
    }];
    
    [[cell.commontBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        //        self.commontModel_current = self.dataArray[indexPath.section];
        //进入二级评论
        if ([[self getCurrentVC]isKindOfClass:[SYCommentDetailViewController class]]) return;
        
        SYCommentDetailViewController *commontDetailVC = [[SYCommentDetailViewController alloc]init];
        commontDetailVC.selectedCommont = self.dataArray[indexPath.section];
        commontDetailVC.post_id = self.momentModel.post_id?:self.momentModel.ID;
        commontDetailVC.tableHeadViewHeight= [tableView.fd_keyedHeightCache heightForKey:indexPath]-40;
        [self.navigationController pushViewController:commontDetailVC animated:YES];
        
    }];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SYCommentDetailViewController *commontDetailVC = [[SYCommentDetailViewController alloc]init];
    commontDetailVC.selectedCommont = self.dataArray[indexPath.section];
    commontDetailVC.post_id = self.momentModel.post_id?:self.momentModel.ID;
    commontDetailVC.tableHeadViewHeight= [tableView.fd_keyedHeightCache heightForKey:indexPath]-40;
    [self.navigationController pushViewController:commontDetailVC animated:YES];
    
}

- (void)rightBarAction:(UIButton*)sender{
    
    if (sender.tag == 201) {
        [YBPopupMenu showAtPoint:CGPointMake(KScreenWidth-35, KNavBarHeight-10) titles:@[@"举报此动态"] icons:@[@""] menuWidth:110 otherSettings:^(YBPopupMenu *popupMenu) {
            
            popupMenu.dismissOnSelected = YES;
            popupMenu.isShowShadow = YES;
            popupMenu.delegate = self;
            popupMenu.offset = 10;
            popupMenu.type = YBPopupMenuTypeDefault;
            //        popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            
        }];
    }else if (sender.tag == 202){
        MSShareView *shareView = (MSShareView*)[UIView instancesWithNib:@"MSShareView" index:0];
        [shareView showPopView:@"post"];
    }
    
}
#pragma mark -- 举报
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    //进入举报页面
    SYJuBaoViewController *juBaoVC =[[SYJuBaoViewController alloc]init];
    juBaoVC.post_id = self.momentModel.post_id?:self.momentModel.ID;
    juBaoVC.topTitleStr = self.momentModel.nickname;
    juBaoVC.juBaoType = 0;
    [self.navigationController pushViewController:juBaoVC animated:YES];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if ([self.chatBoardView.inputTextView isFirstResponder] ) {
        [self.chatBoardView.inputTextView resignFirstResponder];
    }
    
}
#pragma mark -- SYCommontTableViewCellDelegate
- (void)likeButtonClick{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"post" forKey:@"module"];
    [params setObject:self.momentModel.post_id forKey:@"module_id"];
    [params setObject:self.momentModel.comment_id forKey:@"comment_id"];
    [params setObject:(self.momentModel.if_good?@"0":@"1") forKey:@"good"];
    
    [ShareRequest shareRequestDataWithAppendURL:@"/comment/comment/good" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        self.momentModel.if_good = !self.momentModel.if_good;
        self.chatBoardView.likeBtn.selected = self.momentModel.if_good;
        self.momentModel.good = [NSString stringWithFormat:@"%ld",(long)[self.momentModel.good integerValue]+(self.momentModel.if_good ?1:-1)];
        
        NSString *tltleStr = (self.momentModel.if_good ?[NSString stringWithFormat:@"已点赞(%@)",self.momentModel.good]:[NSString stringWithFormat:@"点赞(%@)",self.momentModel.good]);
        [self.momentCell.toolbar.starBtn setTitle:tltleStr forState:UIControlStateNormal];
        
    } Fail:^(NSError *error) {
        
    }];
    
}
- (void)collectionButtonClick{
    
    [ShareRequest shareRequestDataWithAppendURL:@"/post/post_about/collection" Params:@{@"post_id":self.momentModel.post_id} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        
        self.momentModel.if_collection = !self.momentModel.if_collection;
        self.chatBoardView.collectionBtn.selected = self.momentModel.if_collection;
        
        self.momentModel.collection = [NSString stringWithFormat:@"%ld",(long)[self.momentModel.collection integerValue]+(self.momentModel.if_collection ?1:-1)];
        
        NSString *tltleStr = (self.momentModel.if_collection ?[NSString stringWithFormat:@"已收藏(%@)",self.momentModel.collection]:[NSString stringWithFormat:@"收藏(%@)",self.momentModel.collection]);
        [self.momentCell.toolbar.collectionBtn setTitle:tltleStr forState:UIControlStateNormal];
        
        
    } Fail:^(NSError *error) {
        
    }];
    
}

- (void)customPrevious{
    
}
- (void)customNext{
    
}
- (void)customDone{
    [self reportCommont:self.chatBoardView.inputTextView.text];
}
- (void)inputTextViewEndEdite:(NSString *)commontStr{
    [self reportCommont:commontStr];
    
    //             [self.momentCell.toolbar.commontBtn setTitle:[NSString stringWithFormat:@"评论(%@)",self.momentModel.comment] forState:UIControlStateNormal];
}

- (void)reportCommont:(NSString*)contentStr{
    
    if (self.dataArray.count <=0) {
        [self.mainTableView showNoDataStatusWithString:@"暂无评论" imageName:@"icon_noCommont" withOfffset:self.tableHeadViewHeight/3.0];
    }
    [self.chatBoardView.inputTextView resignFirstResponder];
    if (kStringIsEmpty(contentStr)) return;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"post" forKey:@"module"];
    [params setObject:self.momentModel.post_id?:self.momentModel.ID forKey:@"module_id"];
    [params setObject:contentStr forKey:@"content"];
    [params setObject:self.momentModel.comment_id forKey:@"comment_id"];
    
    if (self.commontModel_current) {
        [params setObject:self.commontModel_current.ID forKey:@"comment_id"];
        //       [params setObject:self.commontModel_current.user.ID forKey:@"reply_id"];
    }
    [ShareRequest shareRequestDataWithAppendURL:@"/comment/comment/do_comment" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        self.currrentPage = 1;
        [self.mainTableView.mj_header beginRefreshing];
        self.chatBoardView.inputTextView.text = @"";
        
    } Fail:^(NSError *error) {
        
    }];
    
}
#pragma mark -- SYCommontTableViewCellDelegate
- (void)commontDeletedAction:(SYCommontTableViewCell *)commontCell{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除此评论，删除后不可恢复" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ShareRequest shareRequestDataWithAppendURL:@"/comment/comment/delete" Params:@{@"comment_id":commontCell.commontModel.ID} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
            
            [self.dataArray removeObjectAtIndex:[self.dataArray indexOfObject:commontCell.commontModel]];
            [self.mainTableView reloadData];
            [self.view makeToast:@"删除成功" duration:1.5f position:CSToastPositionCenter];
        } Fail:^(NSError *error) {
            
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:sureAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
    
}
@end

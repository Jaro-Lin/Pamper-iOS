//
//  SYCommentDetailViewController.m
//  SYBaseProject
//
//  Created by apple on 2020/4/22.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYCommentDetailViewController.h"
#import "SYSecondCommontTableViewCell.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "UITableView+FDTemplateLayoutCell.h"
#import "SYUserDetailHeadView.h"
#import "UIButton+JKImagePosition.h"
#import "SYJuBaoViewController.h"
#import "SYChatKeyBoardView.h"
#import "UITextView+WZB.h"

#define KchatKeyBoardHeight 40

@interface SYCommentDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SYSecondCommontTableViewCellDelegate,SYChatKeyBoardViewDelegate>

@property(nonatomic, strong) SYSecondCommontHeadView *tableHeadView;
@property(nonatomic, strong) SYSecondCommontTableViewCell *stairCommont;//一级评论
@property(nonatomic, strong) NSMutableArray *dataArray;
/** 聊天键盘 */
@property(nonatomic, strong) SYChatKeyBoardView *chatBoardView;
@property(nonatomic, strong) SYCommontModel *momentModel;

@end

@implementation SYCommentDetailViewController
- (SYSecondCommontHeadView *)tableHeadView{
    if (!_tableHeadView) {
        _tableHeadView = (SYSecondCommontHeadView*)[UIView instancesWithNib:@"SYUserDetailHeadView" index:2];
        _tableHeadView.backgroundColor = [UIColor whiteColor];
        
        [_tableHeadView.userHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageServer,self.selectedCommont.user.avatar]] placeholderImage:kPlaceHoldImageUser];
        _tableHeadView.userName.text = self.selectedCommont.user.nickname;
        _tableHeadView.timeLB.text = [NSString timintervalToTimeStr:kDateFormat_yMd timeInterval:[self.selectedCommont.create_time integerValue]];
        _tableHeadView.contentLB.text = self.selectedCommont.content;
        _tableHeadView.zanBtn.selected = self.selectedCommont.is_good;
        [_tableHeadView.zanBtn setTitle:self.selectedCommont.total_like forState:UIControlStateNormal];
        [_tableHeadView.zanBtn setTitle:self.selectedCommont.total_like forState:UIControlStateSelected];
        [_tableHeadView.zanBtn jk_setImagePosition:LXMImagePositionLeft spacing:8];
        
        [[_tableHeadView.zanBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setObject:@"post" forKey:@"module"];
            [params setObject:self.post_id forKey:@"module_id"];
            [params setObject:self.selectedCommont.ID forKey:@"comment_id"];
            [params setObject:(self.selectedCommont.is_good?@"0":@"1") forKey:@"good"];
            
            [ShareRequest shareRequestDataWithAppendURL:@"/comment/comment/good" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
                self.selectedCommont.is_good = !self.selectedCommont.is_good;
                self->_tableHeadView.zanBtn.selected = self.selectedCommont.is_good;
                self.selectedCommont.total_like = [NSString stringWithFormat:@"%ld",([self.selectedCommont.total_like integerValue]+(self.selectedCommont.is_good?1:-1))];
                [self.tableHeadView.zanBtn setTitle:self.selectedCommont.total_like forState:UIControlStateNormal];
            } Fail:^(NSError *error) {
                
            }];
            
        }];
        
    }
    return _tableHeadView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (SYChatKeyBoardView *)chatBoardView{
    if (!_chatBoardView) {
        _chatBoardView = (SYChatKeyBoardView*)[UIView instancesLastWithNib:@"SYChatKeyBoardView"];
        _chatBoardView.delegate = self;
        _chatBoardView.likeBtn.hidden = YES;
        _chatBoardView.collectionBtn.hidden = YES;
    }
    return _chatBoardView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBOF(0xEEEEEE);
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(reportMomentAction:) image:@"icon_threePoint" highImage:@"icon_threePoint" horizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-KNavBarHeight-KchatKeyBoardHeight);
    [self.mainTableView registerNib:[UINib nibWithNibName:@"SYSecondCommontTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SYSecondCommontTableViewCell"];
    self.mainTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainTableView];
    
    UIView*headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.tableHeadViewHeight)];
    [headView addSubview:self.tableHeadView];
    [self.tableHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headView);
    }];
    self.mainTableView.tableHeaderView = headView;
    
    [self.mainTableView.mj_header beginRefreshing];
    
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

- (void)initBtnsClick{
    
    [ShareRequest shareRequestDataWithAppendURL:@"/post/comment/good_comment" Params:@{@"post_id":self.post_id,@"comment_id":self.selectedCommont.parent_id} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        self.selectedCommont.is_good = !self.selectedCommont.is_good;
        //self.stairCommont.starBtn.selected = self.selectedCommont.is_good;
    } Fail:^(NSError *error) {
        
    }];
    
}

- (void)reportMomentAction:(UIButton*)sender{
    
    SYJuBaoViewController *juBaoVC =[[SYJuBaoViewController alloc]init];
    juBaoVC.post_id = self.post_id;
    juBaoVC.commont_id = self.selectedCommont.parent_id;
    juBaoVC.topTitleStr = self.selectedCommont.user.nickname;
    juBaoVC.juBaoType = 1;
    [self.navigationController pushViewController:juBaoVC animated:YES];
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
    [param setObject:self.post_id forKey:@"module_id"];
    [param setObject:@"post" forKey:@"module"];
    [param setObject:self.selectedCommont.ID forKey:@"comment_id"];
    
    [ShareRequest shareRequestDataWithAppendURL:@"/comment/comment/list" Params:param IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        
        if (self.currrentPage ==1) {
            [self.dataArray removeAllObjects];
        }
        self.totalCount = [dic[@"total"] integerValue];
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
    
    return [tableView fd_heightForCellWithIdentifier:@"SYSecondCommontTableViewCell" cacheByKey:indexPath configuration:^(SYSecondCommontTableViewCell *cell) {
        cell.commontModel = self.dataArray[indexPath.section];
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYSecondCommontTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYSecondCommontTableViewCell"];
    cell.delegate = self;
    cell.selectionStyle = NO;
    cell.replyName = self.selectedCommont.user.nickname;
    cell.commontModel = self.dataArray[indexPath.section];
    cell.replayBtn.hidden = YES;
    [[cell.zanBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        SYCommontModel *model = self.dataArray[indexPath.section];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:@"post" forKey:@"module"];
        [params setObject:self.post_id forKey:@"module_id"];
        [params setObject:model.ID forKey:@"comment_id"];
        [params setObject:(model.is_good?@"0":@"1") forKey:@"good"];
        
        [ShareRequest shareRequestDataWithAppendURL:@"/comment/comment/good" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
            model.is_good = !model.is_good;
            cell.zanBtn.selected = model.is_good;
        } Fail:^(NSError *error) {
            
        }];
    }];
    
    [[cell.replayBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        //        self.momentModel = self.dataArray[indexPath.section];
        
    }];
    
    return cell;
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.chatBoardView.inputTextView isFirstResponder] ) {
        [self.chatBoardView.inputTextView resignFirstResponder];
    }
}
#pragma mark -- SYChatKeyBoardViewDelegate
- (void)customPrevious{
    
}
- (void)customNext{
    
}
- (void)customDone{
    [self reportCommont:self.chatBoardView.inputTextView.text];
}
- (void)inputTextViewEndEdite:(NSString *)commontStr{
    [self reportCommont:commontStr];
    
}
- (void)reportCommont:(NSString*)contentStr{
    [self.chatBoardView.inputTextView resignFirstResponder];
    if (kStringIsEmpty(contentStr)) return;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"post" forKey:@"module"];
    [params setObject:self.post_id forKey:@"module_id"];
    [params setObject:contentStr forKey:@"content"];
    [params setObject:self.selectedCommont.ID forKey:@"comment_id"];
    
    if (self.momentModel) {
        [params setObject:self.momentModel.user.ID forKey:@"reply_id"];
    }
    [ShareRequest shareRequestDataWithAppendURL:@"/comment/comment/do_comment" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        self.currrentPage = 1;
        [self.mainTableView.mj_header beginRefreshing];
        self.chatBoardView.inputTextView.text = @"";
    } Fail:^(NSError *error) {
        
    }];
    
}

#pragma mark -- SYSecondCommontTableViewCellDelegate
- (void)secondCommontDeletedAction:(SYSecondCommontTableViewCell *)commontCell{
    
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

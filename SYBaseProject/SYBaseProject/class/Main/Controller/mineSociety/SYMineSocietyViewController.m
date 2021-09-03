//
//  SYMineSocietyViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/4/9.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYMineSocietyViewController.h"
#import "SYSocietyView.h"
#import "SYTopicModel.h"

@interface SYMineSocietyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) SYSocietyView *headView;
@property(nonatomic, strong) NSMutableArray *dataArrM;
 @property (nonatomic,assign) BOOL isSearching;
@end

@implementation SYMineSocietyViewController
- (NSMutableArray *)dataArrM{
    if (!_dataArrM) {
        _dataArrM = [[NSMutableArray alloc]init];
    }
    return _dataArrM;
}
- (SYSocietyView *)headView{
    if (!_headView) {
        _headView = (SYSocietyView*)[UIView instancesWithNib:@"SYSocietyView" index:0];
        _headView.backgroundColor = [UIColor whiteColor];
    }
    return _headView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的社区";
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 70)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    self.headView.frame = CGRectMake(0, 0,KScreenWidth, 70);
    [view addSubview:self.headView];
    
    self.mainTableView.frame = CGRectMake(0,75, KScreenWidth, KScreenHeight-KNavBarHeight-75);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainTableView];
    
    self.currrentPage = 1;
    [self.mainTableView.mj_header beginRefreshing];
}
- (void)initView{
    
    [[self.headView.searchBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (kStringIsEmpty(self.headView.inputContentTF.text)) {
            [self.view makeToast:@"请输入要搜索的话题" duration:1.5f position:CSToastPositionCenter];
            [self.headView.inputContentTF becomeFirstResponder];
            return;
        }
        [self.headView.inputContentTF resignFirstResponder];
        self.isSearching = YES;
        [self.mainTableView.mj_header beginRefreshing];
    }];
    
    [[self.headView.inputContentTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        if (kStringIsEmpty(x)) {
            self.isSearching = NO;
            [self.mainTableView.mj_header beginRefreshing];
        }
    }];
    
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
 
    if (self.isSearching) {
        [params setObject:self.headView.inputContentTF.text forKey:@"keyword"];
    }
    
    [ShareRequest shareRequestDataWithAppendURL:self.isSearching ? @"/post/theme/search":@"/user/personal/theme_follow" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        if (self.currrentPage ==1) {
            [self.dataArrM removeAllObjects];
        }
        self.totalCount = [dic[@"total"] integerValue];
        [self.dataArrM addObjectsFromArray:[SYTopicModel mj_objectArrayWithKeyValuesArray:dic[@"list"]]];
        if (self.dataArrM.count ==0) {
            [self.mainTableView showNoDataStatusWithString:@"未关注任何社区" withOfffset:-80];
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
    
    SYSocietiesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYSocietiesViewCell"];
    if (!cell) {
        cell = (SYSocietiesViewCell*)[UIView instancesWithNib:@"SYSocietyView" index:1];
    }
    cell.topicModel = self.dataArrM[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section ==0 ?0:4;
}

#pragma mark -- 左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
    
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       //取消关注
        SYTopicModel *topicModel = self.dataArrM[indexPath.section];
        [ShareRequest shareRequestDataWithAppendURL:@"/post/theme/theme_follow" Params:@{@"theme_id":topicModel.ID} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
            [self.dataArrM removeObject:topicModel];
            [self.mainTableView reloadData];
        } Fail:^(NSError *error) {
            
        }];
    }
    
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"取消关注";
    
}
@end

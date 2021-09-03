//
//  SYPetExamineViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/6/15.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYPetExamineViewController.h"
#import "SYPetExamineSectionView.h"
#import "SYScheduleInitModel.h"
#import "NSString+Common.h"

@interface SYPetExamineViewController ()<UITableViewDelegate,UITableViewDataSource,SYPetExamineSectionViewDelegate>
@property (nonatomic,strong)NSArray *sectionArray;
@property (nonatomic,strong)NSArray *rowArray;
@property(nonatomic, strong) SYScheduleInitModel *scheduleModel;
@property(nonatomic, strong) UIView *bottomView;

@end

@implementation SYPetExamineViewController
- (RACSubject *)subject{
    if (!_subject) {
        _subject = [RACSubject subject];
    }
    return _subject;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 169)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [commitBtn setTitleColor:RGBOF(0xffffff) forState:UIControlStateNormal];
        [commitBtn setBackgroundColor:RGBOF(0x23A0F0)];
        commitBtn.titleLabel.font = KFont_M(18);
        commitBtn.frame = CGRectMake((KScreenWidth-200)/2.0, 50, 200, 48);
        KViewRadius(commitBtn, 24);
        [_bottomView addSubview:commitBtn];
        [commitBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"宠物调查";
    self.scheduleModel = [[SYScheduleInitModel alloc]init];
    
    self.sectionArray = @[@"最近是否有注射三联疫苗或者六联疫苗？",@"最近是否有注射狂犬疫苗",@"最近是否有驱虫",@"最近是否有洗澡",@"驱虫间隔设置",@"洗澡间隔设置"];
     self.rowArray = @[@[@"上次注射疫苗时间："],@[@"上次注射疫苗时间："],@[@"上次驱虫时间："],@[@"上次洗澡时间："],@[],@[]];
    
    self.mainTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-KNavBarHeight);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.view addSubview:self.mainTableView];
    self.mainTableView.tableFooterView = self.bottomView;
}

- (void)headerRereshing{
    [self.mainTableView.mj_header endRefreshing];
}
- (void)footerRereshing{
    [self.mainTableView.mj_footer endRefreshing];
}
#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}

//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section ==0) {
        return self.scheduleModel.vaccin0Selected ?1:0;
    }else if (section ==1) {
        return self.scheduleModel.vaccin1Selected ?1:0;
    }else if (section ==2) {
        return self.scheduleModel.expellingSelected ?1:0;
    }else if (section ==3) {
        return self.scheduleModel.bathSelected ?1:0;
    }
    return 0;
}

//组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    SYPetExamineSectionView *headView = (SYPetExamineSectionView*)[UIView instancesWithNib:@"SYPetExamineSectionView" index:0];
    headView.titleLB.text = self.sectionArray[section];
    headView.section = section;
    headView.delegate = self;
    if (section ==4 || section ==5) {
        headView.headType = sectionHeadType_setting;
    }else{
        headView.headType = sectionHeadType_nomal;
    }
    
    if (section ==0) {
        headView.selectedBtn.selected = self.scheduleModel.vaccin0Selected;
    }else if (section ==1) {
        headView.selectedBtn.selected = self.scheduleModel.vaccin1Selected;
    }else if (section ==2) {
        headView.selectedBtn.selected = self.scheduleModel.expellingSelected;
    }else if (section ==3) {
        headView.selectedBtn.selected = self.scheduleModel.bathSelected;
    }else if (section ==4){
        headView.dutionLB.text = [NSString stringWithFormat:@"%@天",self.scheduleModel.expelling?:@"0"];
    }else if (section ==5){
        headView.dutionLB.text = [NSString stringWithFormat:@"%@天",self.scheduleModel.bath?:@"0"];
    }
    
    return headView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SYExamineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYExamineTableViewCell"];
    if (!cell) {
        cell = (SYExamineTableViewCell*)[UIView instancesWithNib:@"SYPetExamineSectionView" index:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.topTitleLB.text = self.rowArray[indexPath.section][indexPath.row];
    if (indexPath.row ==0 || indexPath.row ==1) {
        cell.bottomView.hidden = NO;
        cell.bottomViewHeight.constant = 55;
    }else{
        cell.bottomView.hidden = YES;
        cell.bottomViewHeight.constant = 0;
    }
    cell.indexPath = indexPath;
    cell.clipsToBounds = YES; //这句话很重要
    cell.scheduleModel = self.scheduleModel;
    
    if (indexPath.section ==0) {
        cell.timeLB.text = self.scheduleModel.vaccin_time0?:@"请选择";
        cell.countLB.text = [NSString stringWithFormat:@"%@针",self.scheduleModel.vaccin_count0?:@"0"];
    }else if (indexPath.section ==1) {
        cell.timeLB.text = self.scheduleModel.vaccin_time1?:@"请选择";
        cell.countLB.text = [NSString stringWithFormat:@"%@针",self.scheduleModel.vaccin_count1?:@"0"];
    }else if (indexPath.section ==2) {
        cell.timeLB.text = self.scheduleModel.expelling_time?:@"请选择";
    }else if (indexPath.section ==3) {
        cell.timeLB.text = self.scheduleModel.bath_time?:@"请选择";
    }
    
    return cell;
}

//组头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 62;
}
//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0 || indexPath.section ==1) {
        return 110;
    }
    return 55;
}
#pragma mark -- SYPetExamineSectionViewDelegate
-(void)sectionHeadViewSelected:(BOOL)selected sectionRow:(NSInteger)section{
    
    if (section ==0) {
        self.scheduleModel.vaccin0Selected = selected;
    }else if (section ==1) {
        self.scheduleModel.vaccin1Selected = selected;
    }else if (section ==2) {
        self.scheduleModel.expellingSelected = selected;
    }else if (section ==3) {
        self.scheduleModel.bathSelected = selected;
    }
    [self.mainTableView reloadData];
    
}
- (void)bathExpellingChoosed:(NSString *)dutionStr sectionRow:(NSInteger)section{
    
    if (section ==4) {
        self.scheduleModel.expelling = dutionStr;
    }else if (section ==5){
        self.scheduleModel.bath = dutionStr;
    }
}
#pragma mark -- 提交数据
- (void)commitAction:(UIButton*)sender{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    [params setObject:self.mypets_id?:@"" forKey:@"mypets_id"];
    
    [params setObject:self.scheduleModel.expelling?:@"" forKey:@"expelling_inter"];
    [params setObject:self.scheduleModel.expelling_time?:@"" forKey:@"last_expelling"];
    [params setObject:self.scheduleModel.bath?:@"" forKey:@"bath_inter"];
    [params setObject:self.scheduleModel.bath_time?:@"" forKey:@"last_bath"];
    
    //三联/六联疫苗
    [params setObject:self.scheduleModel.vaccin_count0?:@"" forKey:@"vaccin_0_count"];
    [params setObject:self.scheduleModel.vaccin_time0?:@"" forKey:@"last_vaccin_0"];
    
    //狂犬疫苗
    [params setObject:self.scheduleModel.vaccin_count1?:@"" forKey:@"vaccin_1_count"];
    [params setObject:self.scheduleModel.vaccin_time1?:@"" forKey:@"last_vaccin_1"];
    
    
    [ShareRequest shareRequestDataWithAppendURL:@"/user/schedule_v2/init" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        [self.subject sendNext:@"1"];
        [self.navigationController popViewControllerAnimated:YES];
    } Fail:^(NSError *error) {
        
    }];
    
}
@end

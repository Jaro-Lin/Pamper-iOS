//
//  SYRecordManagerViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/3/24.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYRecordManagerViewController.h"
#import "UIView+Extension.h"
#import "UIButton+JKImagePosition.h"
#import "SYRecordListTableViewCell.h"
#import "SYCalendarView.h"
#import "SYPetModel.h"
#import "YBPopupMenu.h"
#import "SYDatePickerView.h"
#import "SYMonthPlanModel.h"
#import "SYPetExamineViewController.h"
#import "SYDaySchedule.h"

#import "SYRecordHealthViewController.h"
#import "SYRecordNoticeViewController.h"
#import "LCHealthLivingPopView.h"

#define KAlwaysArr @[@"体重",@"喂养",@"身体状况",@"驱虫",@"疫苗",@"狂犬疫苗",@"洗澡"]
#define KAlwaysImagesArr @[@"icon_weight",@"icon_food",@"icon_health",@"icon_qc",@"icon_ym",@"icon_ym_kq",@"icon_xz"]
@interface SYRecordManagerViewController ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate>
@property(nonatomic, strong) LCHealthLivingPopView *PopView;
@property(nonatomic, strong) UIButton *leftBtn;
@property(nonatomic, strong) UIButton *rightBtn;
@property(nonatomic, strong) SYCalendarView *calendarView;
@property(nonatomic, strong)  NSMutableArray *dataArrM;

@property(nonatomic, strong) NSArray *allPetsArr;
@property (nonatomic,strong) SYPetModel *currentPetModel;

/**日程的月份*/
@property (nonatomic,copy) NSString *scheduleMonthDate;
/**当天的日期*/
@property (nonatomic,copy) NSString *todayStr;
/**当天显示的日程安排*/
@property (nonatomic,copy) NSString *schedule_showDate;

//当月日程信息
@property(nonatomic, strong) SYMonthPlanModel *monthPlanMode;
@property(nonatomic, strong) NSArray *allScheduleArr;//所有的日程信息
@property(nonatomic, strong) NSDictionary *varietiesDic;//宠物品种信息

/**当前选中的日期*/
@property (nonatomic,copy) NSString *currentDay;
@end

@implementation SYRecordManagerViewController
- (NSMutableArray *)dataArrM{
    if (!_dataArrM) {
        _dataArrM = [[NSMutableArray alloc]init];
    }
    return _dataArrM;
}
- (LCHealthLivingPopView *)PopView{
    if (!_PopView) {
        _PopView = [[[NSBundle mainBundle]loadNibNamed:@"LCHealthLivingPopView" owner:self options:nil]firstObject];
        _PopView.frame = CGRectZero;
    }
    return _PopView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    self.scheduleMonthDate = [dateFormatter stringFromDate:[NSDate new]];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.todayStr = [dateFormatter stringFromDate:[NSDate new]];
    self.currentDay = self.todayStr;
    
    self.leftBtn = [UIButton creatBtnWithTitle:self.scheduleMonthDate textFont:[UIFont systemFontOfSize:16] normalImage:@"icon_down" selectedImage:@"" titleColor:KUIColorFromRGB(0x000000) backGroundColor:nil];
    self.leftBtn.frame = CGRectMake(0, 0, 120, 40);
    [self.leftBtn jk_setImagePosition:LXMImagePositionRight spacing:17];
    [self.leftBtn addTarget:self action:@selector(chooseDate) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBtn = [UIButton creatBtnWithTitle:@"" textFont:[UIFont boldSystemFontOfSize:16] normalImage:@"setting_record" selectedImage:@"setting_record" titleColor:KUIColorFromRGB(0x333333) backGroundColor:nil];
    self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightBtn.frame = CGRectMake(0, 0, 120, 40);
    [self.rightBtn addTarget:self action:@selector(chooseMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    
    
    self.calendarView = [[SYCalendarView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth,280)];
    self.mainTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-KNavBarHeight-KTabBarHeight);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.tableHeaderView = self.calendarView;
    
    [self.calendarView.subject_Click subscribeNext:^(id  _Nullable x) {
        //找到对日期存在的活动
        self.currentDay = x;
        self.schedule_showDate = x;
        [self currentDaySchedule:x];
    }];

    [self.mainTableView.mj_header beginRefreshing];
    self.mainTableView.mj_header.automaticallyChangeAlpha = YES;
}
- (void)headerRereshing{
    [self requestNetWork];
}
- (void)footerRereshing{
    [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
}
- (void)requestNetWork{
    
    
    self.monthPlanMode = nil;
    self.allScheduleArr = @[];
    [self refreshCalendarView];
    [self.dataArrM removeAllObjects];
    self.allScheduleArr = @[];
    self.allPetsArr = @[];

    // 创建一个信号管1--获取所有宠物信息
    RACSignal *siganl1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
      
        [ShareRequest shareRequestDataWithAppendURL:@"/pets/pets/pets_info" Params:nil IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
            self.allPetsArr = [SYPetModel mj_objectArrayWithKeyValuesArray:dic];
            [subscriber sendCompleted];
        } Fail:^(NSError *error) {
            [subscriber sendCompleted];
        }];
 
        return [RACDisposable disposableWithBlock:^{}];
    }];
    
    // 创建一个信号管2--获取默认宠物
      RACSignal *siganl2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
          
          [ShareRequest shareRequestDataWithAppendURL:@"/pets/pets_about/get_default" Params:nil IsShowHud:NO IsInteract:NO Complete:^(NSDictionary *dic) {
              if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                  self.currentPetModel = [SYPetModel mj_objectWithKeyValues:dic];
              }
              [subscriber sendCompleted];
          } Fail:^(NSError *error) {
              [subscriber sendCompleted];
          }];
          return [RACDisposable disposableWithBlock:^{}];
          
      }];
      
      // 创建一个信号管3--获取月日程信息
      RACSignal *siganl3 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
          
          [ShareRequest shareRequestDataWithAppendURL:@"/user/schedule_v2/get" Params:@{@"month":self.scheduleMonthDate,@"mypets_id":self.currentPetModel.ID} IsShowHud:NO IsInteract:NO Complete:^(NSDictionary *dic) {
              self.monthPlanMode = [SYMonthPlanModel mj_objectWithKeyValues:dic];
              
              //获取当月的所有的日程信息
              NSMutableArray *allDateArrM = [NSMutableArray array];
              [allDateArrM addObjectsFromArray:self.monthPlanMode.vaccin_0];
              [allDateArrM addObjectsFromArray:self.monthPlanMode.vaccin_1];
              [allDateArrM addObjectsFromArray:self.monthPlanMode.bath];
              [allDateArrM addObjectsFromArray:self.monthPlanMode.expelling];
              
              //去除重复数据
              NSSet *set = [NSSet setWithArray:allDateArrM];
              NSArray *tampArr = [set allObjects];
              
              //时间升序排序
              NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
              NSArray *descriptors = [NSArray arrayWithObject:descriptor];
              self.allScheduleArr = [tampArr sortedArrayUsingDescriptors:descriptors];
              [subscriber sendCompleted];
             
          } Fail:^(NSError *error) {
              [subscriber sendCompleted];
            
          }];
          return [RACDisposable disposableWithBlock:^{}];
      }];
      
      // 串联管1管2管3
      RACSignal *concatSiganl = [[siganl1 concat:siganl2] concat:siganl3];
      //串联后的接收端处理 ,两个事件,走两次,第一个打印siggnal1的结果,第二次打印siganl2的结果
    [concatSiganl subscribeCompleted:^{
        
        if (self.allPetsArr.count >0 ) {
            if (!self.currentPetModel) self.currentPetModel = self.allPetsArr[0];
            self.navigationItem.title = self.currentPetModel.nickname;
            [self getPetVarietiesInfo];
            if (!self.currentPetModel.is_init) {
                [self petRecordInfoUnFinish];
            }
            [self refreshCalendarView];
            //默认显示当天的日程,若存在其他选中日期则优先显示
            [self currentDaySchedule:!kStringIsEmpty(self.schedule_showDate)?self.schedule_showDate:self.todayStr];
            
        }else{
            [self.mainTableView showNoDataStatusWithString:@"还未添加宠物" imageName:@"" withOfffset:50];
        }
        [self.mainTableView.mj_header endRefreshing];
    }];
    
}

- (void)getPetVarietiesInfo{
    
    [ShareRequest shareRequestDataWithAppendURL:@"/pets/pets_type/get_type" Params:@{@"id":self.currentPetModel.varieties_id} IsShowHud:NO IsInteract:NO Complete:^(NSDictionary *dic) {
        self.varietiesDic = dic[@"data"];
    } Fail:^(NSError *error) {
        [self.view makeToast:@"获取宠物品种信息失败"];
    }];
}
#pragma mark -- 切换宠物
- (void)chooseMenu:(UIButton*)sender{
    
    [YBPopupMenu showAtPoint:CGPointMake(KScreenWidth-35, KNavBarHeight-10) titles:@[@"切换宠物",@"洗澡间隔",@"驱虫间隔"] icons:@[] menuWidth:120 otherSettings:^(YBPopupMenu *popupMenu) {
        
        popupMenu.dismissOnSelected = YES;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = self;
        popupMenu.offset = 10;
        popupMenu.type = YBPopupMenuTypeDefault;
        
    }];
    
}
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    
    [self showPopView:index];
}
- (void)showPopView:(NSInteger)pageIndex{
    
    NSMutableArray *tampArr = [NSMutableArray array];
    if (pageIndex ==0) {
        
        if (self.allPetsArr.count <=0) return;
        for (int i = 0; i <self.allPetsArr.count; i ++) {
            SYPetModel *model = self.allPetsArr[i];
            [tampArr addObject:model.nickname];
        }
        self.PopView.topTitleLB.text = @"切换宠物";
    }else if (pageIndex ==1){
        for (int i = 1; i <31; i++) {
            [tampArr addObject:[NSString stringWithFormat:@"%d天",i]];
        }
        self.PopView.topTitleLB.text = @"洗澡间隔";
    }else if (pageIndex ==2){
        for (int i = 1; i <31; i++) {
            [tampArr addObject:[NSString stringWithFormat:@"%d天",i]];
        }
        self.PopView.topTitleLB.text = @"驱虫间隔";
    }
    self.PopView.frame = CGRectMake(0, 0, KScreenWidth,5*50);
    self.PopView.dataArray = tampArr;
    
    self.zh_popupController = [zhPopupController popupControllerWithMaskType:zhPopupMaskTypeBlackTranslucent];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    self.zh_popupController.slideStyle = zhPopupSlideStyleFromBottom;
    [self.zh_popupController presentContentView:self.PopView];
    
    kSelfWeak;
    [self.PopView setCancelActionBlock:^{
        [weakSelf.zh_popupController dismiss];
    }];
    
    [self.PopView setSureActionBlock:^(baseModel * _Nonnull selectedModel, NSInteger indexRow) {
        [weakSelf.zh_popupController dismiss];
        
        if (pageIndex ==0) {//切换宠物
            
            SYPetModel*petModel = weakSelf.allPetsArr[indexRow];
            [weakSelf setDefaultPet:petModel.pid];
 
        }else{
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setValue:weakSelf.currentPetModel.ID forKey:@"mypets_id"];
            
            if (pageIndex ==1) {
                [params setValue:@(indexRow+1) forKey:@"bath_inter"];
            }
            if (pageIndex ==2) {
                [params setValue:@(indexRow+1) forKey:@"expelling_inter"];
            }
            
            [ShareRequest shareRequestDataWithAppendURL:@"/user/schedule_v2/edit_rule" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
                [weakSelf.view makeToast:@"修改成功"];
                [weakSelf headerRereshing];//需要重新获取一次日程信息
            } Fail:^(NSError *error) {
                
            }];
            
        }
        
    }];
    
}
//设置为默认宠物
- (void)setDefaultPet:(NSString*)pid{
    [ShareRequest shareRequestDataWithAppendURL:@"/pets/pets_about/set_default" Params:@{@"pid":pid} IsShowHud:NO IsInteract:NO Complete:^(NSDictionary *dic) {

        [self.mainTableView.mj_header beginRefreshing];
        self.mainTableView.mj_header.automaticallyChangeAlpha = YES;
        
    } Fail:^(NSError *error) {
        [self.view makeToast:@"切换宠物失败，请重试" duration:1.5f position:CSToastPositionCenter];
    }];
}
#pragma mark -- 切换月份
- (void)chooseDate{
    [SYDatePickerView showDatePickerWithMode:BRDatePickerModeYM title:@"选择日期" selectValue:self.scheduleMonthDate resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        if (kStringIsEmpty(selectValue)) return;
        [self.leftBtn setTitle:[selectValue substringToIndex:7] forState:UIControlStateNormal];
        self.scheduleMonthDate = selectValue;
        
        [self refreshCalendarView];
    }];
    
}
- (void)refreshCalendarView{
    
    /*
     方法一：利用NSPredicate
     注：NSPredicate所属Cocoa框架，在密码、用户名等正则判断中经常用到。
     类似于SQL语句
     NOT 不是
     SELF 代表字符串本身
     IN 范围运算符
     那么NOT (SELF IN %@) 意思就是：不是这里所指定的字符串的值
     BEGINSWITH 以···开始、ENDSWITH 以···结尾、CONTAINS
     */
    
        NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@",self.scheduleMonthDate];
        //更新日历上显示 过滤数组
        //    self.calendarView.schedules = [self.allScheduleArr filteredArrayUsingPredicate:filterPredicate];
        [self.calendarView undateCalendarMonth:self.scheduleMonthDate inSchedules:[self.allScheduleArr filteredArrayUsingPredicate:filterPredicate]];
}

#pragma mark -- 获取当日的日程信息
- (void)currentDaySchedule:(NSString*)dateStr{
    
    if (!self.currentPetModel.is_init){
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"该宠物还未填写相关信息" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去填写" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SYPetExamineViewController *examineVC = [SYPetExamineViewController new];
            examineVC.mypets_id = self.currentPetModel.ID;
            [examineVC.subject subscribeNext:^(id  _Nullable x) {
                //获取当月信息
                self.currentPetModel.is_init = YES;
                [self.mainTableView.mj_header beginRefreshing];
            }];
            [self.navigationController pushViewController:examineVC animated:YES];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不需要" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVC addAction:cancelAction];
        [alertVC addAction:sureAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        return;
    }
    
    BOOL isTodaySchedule = [dateStr isEqualToString:self.todayStr]?YES:NO;
    
    [self.dataArrM removeAllObjects];
    //目前月份下存在日程信息
    //    if ([self.allScheduleArr containsObject:dateStr] && [[dateStr substringToIndex:7]isEqualToString:self.currentDate]) {
    //    self.schedule_showDate = dateStr;
    NSLog(@"_______%ld",KAlwaysArr.count);
    for (NSInteger i = 0 ; i <KAlwaysArr.count; i ++) {
        SYDaySchedule *daySchedule = [[SYDaySchedule alloc]init];
        daySchedule.item = i;
        daySchedule.itemStr = KAlwaysArr[i];
        daySchedule.itemImage = KAlwaysImagesArr[i];
        daySchedule.showTask = (i <3 ?NO:YES);
        daySchedule.isTodaySchedule = isTodaySchedule;
        daySchedule.selectedDay = self.currentDay;
        
        if (i ==0) {
            
            if (![self.currentPetModel.body_status[@"weight"]isKindOfClass:[NSNull class]]) {
                daySchedule.warm = @"(体重不达标)";
            }else{
                daySchedule.warm = @"";
            }
            daySchedule.itemValue = [NSString stringWithFormat:@"%@Kg",self.currentPetModel.weight];
        }else if (i ==1){
            daySchedule.warm = @"";
//
            daySchedule.itemValue = [NSString stringWithFormat:@"%.2fKg",[self.currentPetModel.body_status[@"feed"][@"feed"]floatValue]];
//            if ([self.currentPetModel.weight floatValue] < [self.varietiesDic[@"weight_0_min"]floatValue]) {
//
//                CGFloat addCount = [self.varietiesDic[@"weight_0_min"]floatValue]-[self.currentPetModel.weight floatValue];
//                daySchedule.itemValue = [NSString stringWithFormat:@"%.2fKg",addCount];
//            }else if([self.currentPetModel.weight floatValue] > [self.varietiesDic[@"weight_0_max"]floatValue]){
//
//                CGFloat increaseCount = [self.currentPetModel.weight floatValue]-[self.varietiesDic[@"weight_0_max"]floatValue];
//                daySchedule.itemValue = [NSString stringWithFormat:@"减重%.2fKg",increaseCount];
//            }
            
        }else if (i ==2){
            daySchedule.itemValue = self.currentPetModel.healthy;
        }else if (i ==3){
            if ([self.monthPlanMode.expelling containsObject:dateStr]) {
                daySchedule.warm = @"需要驱虫";
            }
            daySchedule.recorded = NO;
            if ([self.monthPlanMode.scedule.expelling containsObject:dateStr]) {
                daySchedule.recorded = YES;
                daySchedule.taskIsFinish = YES;
            }
            
        }else if (i ==4){
            
            if ([self.monthPlanMode.vaccin_0 containsObject:dateStr]) {
                daySchedule.explingType = 0;
                daySchedule.warm = @"需要打三联疫苗";
            }
            daySchedule.recorded = NO;
            if ([self.monthPlanMode.scedule.vaccin_0 containsObject:dateStr]) {
                daySchedule.recorded = YES;
                daySchedule.taskIsFinish = YES;
            }
            
        }else if (i ==5){
            if ([self.monthPlanMode.vaccin_1 containsObject:dateStr]) {
                daySchedule.explingType = 1;
                daySchedule.warm = @"需要打狂犬疫苗";
            }
            daySchedule.recorded = NO;
            if ([self.monthPlanMode.scedule.vaccin_1 containsObject:dateStr]) {
                daySchedule.recorded = YES;
                daySchedule.taskIsFinish = YES;
            }
            
        }else if (i ==6){
            if ([self.monthPlanMode.bath containsObject:dateStr]) {
                daySchedule.warm = @"需要洗澡";
            }
            daySchedule.recorded = NO;
            if ([self.monthPlanMode.scedule.bath containsObject:dateStr]) {
                daySchedule.recorded = YES;
                daySchedule.taskIsFinish = YES;
            }
        }
        [self.dataArrM addObject:daySchedule];
    }
    [self.mainTableView reloadData];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArrM.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SYRecordListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYRecordListTableViewCell"];
    if (!cell) {
        
        cell = (SYRecordListTableViewCell*)[UIView instancesWithNib:@"SYRecordListTableViewCell" index:0];
    }
    cell.dayModel = self.dataArrM[indexPath.section];
    [cell.subject subscribeNext:^(id  _Nullable x) {//
        
        NSString *xStr = (NSString*)x;
        if ([xStr isEqualToString:@""]) {
            SYDaySchedule *daySchedule = self.dataArrM[indexPath.section];
            [self scheduleWriteAction:daySchedule.item setOrRemove:(cell.sliderBtn.selected?@"1":@"0")];
        }else if ([xStr isEqualToString:@"1"]){//注意事项
            
            if (indexPath.section ==2) {
                [self.navigationController pushViewController:[SYRecordHealthViewController new] animated:YES];
            }else {
                NSString *title = @"";
                NSString *contentStr = @"";
                if (indexPath.section ==0) {
                    title = @"体重";
//                    contentStr = self.varietiesDic[@"meal_add"];
                    contentStr = @"meal_add";
                }else if (indexPath.section ==1){
                    title = @"喂养";
//                    contentStr = self.varietiesDic[@"feed"];
                    contentStr = @"feed";
                }else if (indexPath.section ==3){
                    title = @"驱虫";
//                    contentStr = self.varietiesDic[@"expelling"];
                    contentStr = @"expelling";
                }else if (indexPath.section ==4){
                    title = @"疫苗";
//                    contentStr = self.varietiesDic[@"vaccin"];
                    contentStr = @"vaccin";
                }else if (indexPath.section ==5){
                    title = @"狂犬疫苗";
//                    contentStr = self.varietiesDic[@"vaccin"];
                    contentStr = @"vaccin";
                }else if (indexPath.section ==6){
                    title = @"洗澡";
//                    contentStr = self.varietiesDic[@"shower"];
                    contentStr = @"shower";
                }
                SYRecordNoticeViewController *noticeVC = [[SYRecordNoticeViewController alloc]init];
                noticeVC.title = title;
//                noticeVC.contentStr = contentStr;
                
                if (indexPath.section ==5) {
                   noticeVC.contentStr = (([self.varietiesDic[@"type_id"]intValue]==2) ?[NSString stringWithFormat:@"%@\n\n%@",@"狗",@" 狂犬疫苗满三月打第一针，之后每年一针。"]:[NSString stringWithFormat:@"%@\n\n%@",@"猫",@" 打完猫三联相隔一周就可以打狂犬疫苗。之后每年一次"]);
                }else{
                    noticeVC.htmlUrl= [NSString stringWithFormat:@"%@/pets/pets_type/%@?id=%@",requestServerURL,contentStr,self.currentPetModel.varieties_id];
                }

                [self.navigationController pushViewController:noticeVC animated:YES];
                
            }
            
        }
        
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section ==0 ?5:1;
}

- (void)petRecordInfoUnFinish{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"系统提醒" message:@"因为当前宠物为第一次使用记录模块，\n为了更好的系统计算，需要填写相关资料" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去填写" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SYPetExamineViewController *examineVC = [SYPetExamineViewController new];
        examineVC.mypets_id = self.currentPetModel.ID;
        [examineVC.subject subscribeNext:^(id  _Nullable x) {
            //获取当月信息
            self.currentPetModel.is_init = YES;
            [self.mainTableView.mj_header beginRefreshing];
        }];
        [self.navigationController pushViewController:examineVC animated:YES];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不需要" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:sureAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)scheduleWriteAction:(NSInteger)item setOrRemove:(NSString*)valueStr{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:self.currentPetModel.ID forKey:@"mypets_id"];
    
    if (item ==2) {//更改身体状态
        
    }else if (item ==3){//驱虫
        [param setObject:@"expelling" forKey:@"type"];
    }else if (item ==4){//三联疫苗
        [param setObject:@"vaccin_0" forKey:@"type"];
    }else if (item ==5){//狂犬疫苗
        [param setObject:@"vaccin_1" forKey:@"type"];
    }else if (item ==6){//洗澡
        [param setObject:@"bath" forKey:@"type"];
    }
    [param setObject:valueStr forKey:@"value"];
    [param setObject:self.currentDay forKey:@"day"];
    
    [ShareRequest shareRequestDataWithAppendURL:@"/user/schedule_v2/set" Params:param IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        [self.view makeToast:([valueStr integerValue] ==0 ?@"删除成功！":@"记录成功！") duration:1.5f position:CSToastPositionCenter];
        [self headerRereshing];//需要重新获取一次日程信息
        
    } Fail:^(NSError *error) {
        
    }];
    
}

@end

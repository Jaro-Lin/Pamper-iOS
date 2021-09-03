//
//  SYAllCourseCategoryViewController.m
//  SYBaseProject
//
//  Created by apple on 2020/6/8.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYAllCourseCategoryViewController.h"
#import "SYClassModel.h"
#import "SYClassListViewController.h"

@interface SYAllCourseCategoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) NSArray *courseArrM;
@property(nonatomic, strong) UIView *topSearchView;
@property(nonatomic, strong) UITextField *seachTF;
@end

@implementation SYAllCourseCategoryViewController
- (UIView *)topSearchView{
    if (!_topSearchView) {
        _topSearchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 48)];
        _topSearchView.backgroundColor = [UIColor whiteColor];
        
        self.seachTF = [[UITextField alloc]initWithFrame:CGRectMake(35, 5, KScreenWidth-35*2, 40)];
        self.seachTF.backgroundColor = RGBOF(0xE4E4E4);
        self.seachTF.placeholder = @"请输入要搜索的分类...";
        self.seachTF.textColor = RGBOF(0x333333);
        self.seachTF.font = KFont_M(12);
        KViewRadius(self.seachTF, 8);
    }
    return _topSearchView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"课程分类";
    self.view.backgroundColor = RGBOF(0xeeeeee);
    self.mainTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-KNavBarHeight);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.rowHeight = 60;
    [self.mainTableView.mj_header beginRefreshing];
}

- (void)headerRereshing{
    [self requestNetWork];
   
}
- (void)footerRereshing{
    [self requestNetWork];
}
- (void)requestNetWork{
    
    //获取热门分类课程
    [ShareRequest shareRequestDataWithAppendURL:@"/course/course/get_type" Params:@{@"type":@"rec"} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        
        self.courseArrM = [SYRecordCategoryModel mj_objectArrayWithKeyValuesArray:dic];
        //更新分类视图
        [self.mainTableView reloadData];
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    } Fail:^(NSError *error) {
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }];
}
#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.courseArrM.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    SYRecordCategoryModel *model = self.courseArrM[indexPath.section];
    cell.textLabel.text = model.type_title;
    cell.textLabel.font = KFont_M(12);
    cell.textLabel.textColor = RGBOF(0x333333);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    SYRecordCategoryModel *model = self.courseArrM[indexPath.section];
    SYClassListViewController *classListVC = [[SYClassListViewController alloc]init];
    classListVC.title = model.type_title;
    classListVC.type_id = [model.ID integerValue];
    classListVC.classType = 0;
    [self.navigationController pushViewController:classListVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (section ==0 ?5:2);
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

#pragma mark -- 显示推荐分类
-(void)setUpCourseView{
    
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
    //间距
    CGFloat padding = 10;
    
    CGFloat titBtnX = 15;
    CGFloat titBtnY = 15;
    CGFloat titBtnH = 24;
    for (int i = 0; i < self.courseArrM.count; i++) {
        SYRecordCategoryModel *model = self.courseArrM[i];
        UIButton *titBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置按钮的样式
        titBtn.backgroundColor = KUIColorFromRGB(0xBBBBBB);
        [titBtn setTitleColor:KUIColorFromRGB(0XFFFFFF) forState:UIControlStateNormal];
        
        titBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [titBtn setTitle:model.type_title forState:UIControlStateNormal];
        titBtn.tag = i;
        KViewRadius(titBtn, 12);
        [titBtn addTarget:self action:@selector(titBtnClike:) forControlEvents:UIControlEventTouchUpInside];
        
        //计算文字大小
        CGSize titleSize = [model.type_title boundingRectWithSize:CGSizeMake(MAXFLOAT, titBtnH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titBtn.titleLabel.font} context:nil].size;
        
        CGFloat titBtnW = titleSize.width + 2 * padding;
        //判断按钮是否超过屏幕的宽
        if ((titBtnX + titBtnW) > KScreenWidth-15) {
            titBtnX = 15;
            titBtnY += titBtnH + padding;
        }
        //设置按钮的位置
        titBtn.frame = CGRectMake(titBtnX, titBtnY, titBtnW, titBtnH);
        titBtnX += titBtnW + padding;

        [self.view addSubview:titBtn];
    }
}

- (void)titBtnClike:(UIButton*)sender{
    SYRecordCategoryModel *model = self.courseArrM[sender.tag];
    
    SYClassListViewController *classListVC = [[SYClassListViewController alloc]init];
    classListVC.title = model.type_title;
    classListVC.type_id = [model.ID integerValue];
    classListVC.classType = 0;
    [self.navigationController pushViewController:classListVC animated:YES];
    
}
@end

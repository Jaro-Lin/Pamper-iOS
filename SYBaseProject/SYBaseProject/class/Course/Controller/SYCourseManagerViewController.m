//
//  SYCourseManagerViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/4/2.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYCourseManagerViewController.h"
#import "SYHotClassCollectionViewCell.h"
#import "SYClassListViewController.h"
#import "SYClassPlayViewController.h"
#import "SYAllCourseCategoryViewController.h"

@interface SYCourseManagerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *enterDoorBtn;
@property (weak, nonatomic) IBOutlet UIView *baseBtn;
@property (weak, nonatomic) IBOutlet UIView *leverUpBtn;
@property (weak, nonatomic) IBOutlet UIView *professBtn;

@property (weak, nonatomic) IBOutlet UIView *recordCourseView;
@property (weak, nonatomic) IBOutlet UIButton *moreClassBtn;
@property (weak, nonatomic) IBOutlet UIView *middelBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *moreHotClassBtn;

@property(nonatomic, strong) NSMutableArray *hotClassArrM;//推荐课程
@property(nonatomic, strong) NSMutableArray *courseArrM;//推荐分类
@end

@implementation SYCourseManagerViewController
- (NSMutableArray *)hotClassArrM{
    if (!_hotClassArrM) {
        _hotClassArrM = [[NSMutableArray alloc]init];
    }
    return _hotClassArrM;
}
- (NSMutableArray *)courseArrM{
    if (!_courseArrM) {
        _courseArrM = [[NSMutableArray alloc]init];
    }
    return _courseArrM;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"课程";
    
    KViewRadius(self.enterDoorBtn, 25);
    KViewRadius(self.baseBtn, 25);
    KViewRadius(self.leverUpBtn, 25);
    KViewRadius(self.professBtn, 25);
    
    UICollectionViewFlowLayout *flowLyout= [[UICollectionViewFlowLayout alloc]init];
    flowLyout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLyout.itemSize = CGSizeMake(160, CGRectGetHeight(self.bottomView.frame)-60);
    flowLyout.minimumInteritemSpacing =5;
    //    flowLyout.minimumLineSpacing = 5;
    
    self.mainCollectionView.frame = CGRectMake(0, 52, KScreenWidth-15, CGRectGetHeight(self.bottomView.frame)-60);
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.collectionViewLayout = flowLyout;
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"SYHotClassCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SYHotClassCollectionViewCell"];
    
    [self.bottomView addSubview:self.mainCollectionView];
    
    [self initButtonsClick];
    [self requestNetWork];
}
#pragma mark -- 获取热门推荐
- (void)requestNetWork{
    [self.hotClassArrM removeAllObjects];
    
    NSMutableDictionary *param =[[NSMutableDictionary alloc]init];
    [param setObject:@"1" forKey:@"page"];
     [param setObject:KLimitCount forKey:@"limit"];

    //获取热门课程
    [ShareRequest shareRequestDataWithAppendURL:@"/course/course/get_popular" Params:param IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
      
        [self.hotClassArrM addObjectsFromArray:[SYClassModel mj_objectArrayWithKeyValuesArray:dic[@"list"]]];
        [self.mainCollectionView reloadData];

    } Fail:^(NSError *error) {
        
    }];
    
    //获取热门分类课程
    [ShareRequest shareRequestDataWithAppendURL:@"/course/course/get_type" Params:@{@"type":@"rec"} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {

        [self.courseArrM addObjectsFromArray:[SYRecordCategoryModel mj_objectArrayWithKeyValuesArray:dic]];
            //更新分类视图
        [self setUpCourseView];
  
    } Fail:^(NSError *error) {

    }];

}

#pragma mark -- 显示推荐分类
-(void)setUpCourseView{
    
    for (UIView *subView in self.recordCourseView.subviews) {
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
        
        if (titBtnY+titBtnH >CGRectGetHeight(self.recordCourseView.frame)) {
            return;
        }
        [self.recordCourseView addSubview:titBtn];
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


#pragma mark --
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.hotClassArrM.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SYHotClassCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SYHotClassCollectionViewCell" forIndexPath:indexPath];
    cell.classModel = self.hotClassArrM[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SYClassModel *classModel = self.hotClassArrM[indexPath.row];
       SYClassPlayViewController *playVC = [[SYClassPlayViewController alloc]init];
       playVC.course_id = classModel.ID;
       playVC.type_id = classModel.type_id;
       
       [self.navigationController pushViewController:playVC animated:YES];
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0, 0,0);
}

#pragma mark -- 各个按钮操作
- (void)initButtonsClick{
    
    UITapGestureRecognizer *tapEnter = [[UITapGestureRecognizer alloc]init];
    [[tapEnter rac_gestureSignal]subscribeNext:^(id x) {
        SYClassListViewController *classListVC = [[SYClassListViewController alloc]init];
        classListVC.title = @"入门";
        classListVC.type_id = 1;
        classListVC.classType = 0;
        [self.navigationController pushViewController:classListVC animated:YES];
    }];
    [self.enterDoorBtn addGestureRecognizer:tapEnter];
    
    UITapGestureRecognizer *tapBase = [[UITapGestureRecognizer alloc]init];
    [[tapBase rac_gestureSignal]subscribeNext:^(id x) {
        SYClassListViewController *classListVC = [[SYClassListViewController alloc]init];
        classListVC.title = @"基础";
        classListVC.type_id = 2;
         classListVC.classType = 0;
        [self.navigationController pushViewController:classListVC animated:YES];
    }];
    [self.baseBtn addGestureRecognizer:tapBase];
    
    UITapGestureRecognizer *tapUp = [[UITapGestureRecognizer alloc]init];
    [[tapUp rac_gestureSignal]subscribeNext:^(id x) {
        SYClassListViewController *classListVC = [[SYClassListViewController alloc]init];
        classListVC.title = @"进阶";
        classListVC.type_id = 3;
         classListVC.classType = 0;
        [self.navigationController pushViewController:classListVC animated:YES];
    }];
    [self.leverUpBtn addGestureRecognizer:tapUp];
    
    UITapGestureRecognizer *tapProfess = [[UITapGestureRecognizer alloc]init];
    [[tapProfess rac_gestureSignal]subscribeNext:^(id x) {
        SYClassListViewController *classListVC = [[SYClassListViewController alloc]init];
        classListVC.title = @"专业";
        classListVC.type_id = 4;
         classListVC.classType = 0;
        [self.navigationController pushViewController:classListVC animated:YES];
    }];
    [self.professBtn addGestureRecognizer:tapProfess];
    
    [[self.moreHotClassBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        SYClassListViewController *classListVC = [[SYClassListViewController alloc]init];
        classListVC.title = @"热门课程";
        classListVC.classType = 1;
        [self.navigationController pushViewController:classListVC animated:YES];
    }];
    
    [[self.moreClassBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        SYAllCourseCategoryViewController *allCategoryVC = [[SYAllCourseCategoryViewController alloc]init];
        [self.navigationController pushViewController:allCategoryVC animated:YES];
    }];
    
}
@end

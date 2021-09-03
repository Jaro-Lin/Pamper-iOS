//
//  SYClassListViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/4/2.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYClassListViewController.h"
#import "SYHotClassCollectionViewCell.h"
#import "SYClassPlayViewController.h"
#import "SYClassModel.h"

@interface SYClassListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong) NSMutableArray *dataArrM;
@end

@implementation SYClassListViewController
- (NSMutableArray *)dataArrM{
    if (!_dataArrM) {
        _dataArrM = [[NSMutableArray alloc]init];
    }
    return _dataArrM;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLyout= [[UICollectionViewFlowLayout alloc]init];
    flowLyout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLyout.itemSize = CGSizeMake((KScreenWidth-25-15*2)/2.0, 142);
    flowLyout.minimumInteritemSpacing =25;
    flowLyout.minimumLineSpacing = 2;
    
    self.mainCollectionView.frame = CGRectMake(0,0, KScreenWidth,KScreenHeight-KNavBarHeight);
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.collectionViewLayout = flowLyout;
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"SYHotClassCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SYHotClassCollectionViewCell"];
    [self.view addSubview:self.mainCollectionView];
    [self setMainCollectionViewRefresh];//开启下来刷新
    
    [self.mainCollectionView.mj_header beginRefreshing];
    
}

-(void)headerRereshing{
    self.currrentPage = 1;
    [self requestNetWork];
}

-(void)footerRereshing{
    if (self.totalCount == self.dataArrM.count) {
        [self.mainTableView.mj_footer endRefreshing];
        return;
    }
    
    self.currrentPage ++;
     [self requestNetWork];
}
- (void)requestNetWork{
    
    NSMutableDictionary *param =[[NSMutableDictionary alloc]init];
    
    if (self.classType ==0) {
        [param setObject:[NSString stringWithFormat:@"%ld",self.type_id] forKey:@"type_id"];
    }
   
    [param setObject:[NSString stringWithFormat:@"%ld",self.currrentPage] forKey:@"page"];
     [param setObject:KLimitCount forKey:@"limit"];

    [ShareRequest shareRequestDataWithAppendURL:self.classType ==0?@"/course/course/get_type_video":@"/course/course/get_popular" Params:param IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        if (self.currrentPage ==1) {
            [self.dataArrM removeAllObjects];
        }
        self.totalCount = [dic[@"total"]integerValue];
        [self.dataArrM addObjectsFromArray:[SYClassModel mj_objectArrayWithKeyValuesArray:dic[@"list"]]];
        
        if (self.dataArrM.count <=0) {
            [self.mainCollectionView showNoDataStatusWithString:@"没有相关课程" withOfffset:0];
        }
        [self.mainCollectionView reloadData];
        
         [self.mainCollectionView.mj_header endRefreshing];
        [self.mainCollectionView.mj_footer endRefreshing];
    } Fail:^(NSError *error) {
        
    }];
    
}


#pragma mark --
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArrM.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SYHotClassCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SYHotClassCollectionViewCell" forIndexPath:indexPath];
    cell.classModel = self.dataArrM[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SYClassModel *classModel = self.dataArrM[indexPath.row];
    SYClassPlayViewController *playVC = [[SYClassPlayViewController alloc]init];
    playVC.course_id = classModel.ID;
    playVC.type_id = classModel.type_id;
    
    [self.navigationController pushViewController:playVC animated:YES];
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(18,15, 0,15);
}
@end

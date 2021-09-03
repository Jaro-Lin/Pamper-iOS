//
//  SYClassPlayViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/4/2.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYClassPlayViewController.h"
#import "SYHotClassCollectionViewCell.h"
#import "SYPlayHeadView.h"
#import "AppDelegate.h"

@interface SYClassPlayViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong) SYPlayHeadView *headView;
@property(nonatomic, strong) NSMutableArray *dataArrM;
@property(nonatomic, strong) SYClassModel *currentModel;

@property (nonatomic, strong) ZFPlayerController *player;

@end

@implementation SYClassPlayViewController
- (SYPlayHeadView *)headView{
    if (!_headView) {
        _headView = (SYPlayHeadView*)[UIView instancesLastWithNib:@"SYPlayHeadView"];
        _headView.frame = CGRectMake(0,0, KScreenWidth, 375);
    }
    return _headView;
}
- (NSMutableArray *)dataArrM{
    if (!_dataArrM) {
        _dataArrM = [[NSMutableArray alloc]init];
    }
    return _dataArrM;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self playVideoAction];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.player stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 375)];
    [subView addSubview:self.headView];
    [self.view addSubview:subView];
    
    UICollectionViewFlowLayout *flowLyout= [[UICollectionViewFlowLayout alloc]init];
    flowLyout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLyout.itemSize = CGSizeMake((KScreenWidth-25-15*2)/2.0, 142);
    flowLyout.minimumInteritemSpacing =25;
    flowLyout.minimumLineSpacing = 2;
    
    self.mainCollectionView.frame = CGRectMake(0,375, KScreenWidth,KScreenHeight-375-KNavBarHeight);
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.collectionViewLayout = flowLyout;
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"SYHotClassCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SYHotClassCollectionViewCell"];
    [self.view addSubview:self.mainCollectionView];
    [self setMainCollectionViewRefresh];
    [self.mainCollectionView.mj_header beginRefreshing];
    
    //更新头部视图数据
    [self getClassDetailInfo];
}

- (void)getClassDetailInfo{
    
    NSMutableDictionary *param =[[NSMutableDictionary alloc]init];
    [param setObject:self.type_id forKey:@"type_id"];
    [param setObject:self.course_id forKey:@"course_id"];
    
    [ShareRequest shareRequestDataWithAppendURL:@"/course/course/video" Params:param IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        self.currentModel = [SYClassModel mj_objectWithKeyValues:dic];
        self.headView.model = self.currentModel;
        [self playVideoAction];
    } Fail:^(NSError *error) {
        
    }];
    
}

-(void)headerRereshing{
    self.currrentPage = 1;
    [self requestNetWork];
}

-(void)footerRereshing{
    if (self.totalCount == self.dataArrM.count) {
        [self.mainCollectionView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    self.currrentPage ++;
    [self requestNetWork];
}
- (void)requestNetWork{
    
    NSMutableDictionary *param =[[NSMutableDictionary alloc]init];
    [param setObject:self.type_id forKey:@"type_id"];
    [param setObject:self.course_id forKey:@"course_id"];
    [param setObject:[NSString stringWithFormat:@"%ld",self.currrentPage] forKey:@"page"];
    [param setObject:KLimitCount forKey:@"limit"];
    
    [ShareRequest shareRequestDataWithAppendURL:@"/course/course/rec_about" Params:param IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        if (self.currrentPage ==1) {
            [self.dataArrM removeAllObjects];
        }
        self.totalCount = [dic[@"total"]integerValue];
        [self.dataArrM addObjectsFromArray:[SYClassModel mj_objectArrayWithKeyValuesArray:dic[@"list"]]];
        [self.mainCollectionView reloadData];
        
        [self.mainCollectionView.mj_header endRefreshing];
        [self.mainCollectionView.mj_footer endRefreshing];
    } Fail:^(NSError *error) {
        [self.mainCollectionView.mj_header endRefreshing];
        [self.mainCollectionView.mj_footer endRefreshing];
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
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(18,15, 0,15);
}

#pragma mark -- 视频播放
- (ZFPlayerController *)player{
    if (!_player) {
        //初始化播放器
        ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
        /// 播放器相关
        _player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.headView.classImageView];
        _player.controlView = self.controlView;
        /// 设置退到后台继续播放
        _player.pauseWhenAppResignActive = NO;
        _player.pauseByEvent = YES;
    }
    return _player;
}
- (void)playVideoAction{
    
     kSelfWeak;
        self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
            [AppDelegate getAppDelegate].allowOrentitaionRotation = isFullScreen;
            [weakSelf setNeedsStatusBarAppearanceUpdate];
            if (!isFullScreen) {
                /// 解决导航栏上移问题
                weakSelf.navigationController.navigationBar.height = KNavBarHeight;
            }
        };
        
        /// 播放完成
        self.player.playerDidToEnd = ^(id  _Nonnull asset) {
            [weakSelf.player stop];
        };
        //播放状态发生变化
        self.player.playerPlayStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerPlaybackState playState) {
            
            if (playState == ZFPlayerPlayStatePlayFailed || playState == ZFPlayerPlayStatePlayStopped) {

            }
        };
        //播放时长计算
        self.player.playerPlayTimeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration) {
            NSLog(@"__当前播放时间：__%lf",currentTime);
        };
        //播放视频
        self.player.assetURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageServer,self.currentModel.video]];
}

@end

//
//  SYHomeListViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/3/25.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYHomeListViewController.h"
#import "MJRefresh.h"
#import "SYHomeManagerHeadView.h"
#import "UIView+Nib.h"
#import "MSGetPermission.h"

#import "SYCustomTableViewCell.h"
#import "UIColor+YMHex.h"
#import "UILabel+MCLabel.h"
#import "SYMomentDetailViewController.h"
#import "SYUserDetailViewController.h"
#import "SYTopicListViewController.h"

#import <CoreLocation/CoreLocation.h>//引入Corelocation框架
#import "SYHomeThemeModel.h"
#import "WechatPayManager.h"
#import "MSShareView.h"

@interface SYHomeListViewController () <UITableViewDataSource, UITableViewDelegate,YjxCustomTableViewCellDelegate,CLLocationManagerDelegate>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, strong) SYHomeRecordHeadView *recordHeadView;
@property(nonatomic, strong) SYHomeCityHeadView *cityHeadView;
@property (nonatomic, strong) CLLocationManager *locationManager;//设置manager

@end

@implementation SYHomeListViewController
- (SYHomeRecordHeadView *)recordHeadView{
    if (!_recordHeadView) {
        _recordHeadView = (SYHomeRecordHeadView*)[UIView instancesWithNib:@"SYHomeManagerHeadView" index:1];
        _recordHeadView.frame = CGRectMake(0, 0, KScreenWidth, 164);
    }
    return _recordHeadView;
}
- (SYHomeCityHeadView *)cityHeadView{
    if (!_cityHeadView) {
        _cityHeadView = (SYHomeCityHeadView*)[UIView instancesWithNib:@"SYHomeManagerHeadView" index:2];
        _cityHeadView.backgroundColor = [UIColor whiteColor];
    }
    return _cityHeadView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = KUIColorFromRGB(0xeeeeee);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.frame = CGRectMake(0,0, KScreenWidth, KScreenHeight-KNavBarHeight-40-KTabBarHeight);
    [self.mainTableView registerClass:[SYCustomTableViewCell class] forCellReuseIdentifier:@"SYCustomTableViewCell"];
    
    self.mainTableView.backgroundColor= [UIColor clearColor];
    //高度自适应
    self.mainTableView.rowHeight = UITableViewAutomaticDimension;
    self.mainTableView.estimatedRowHeight = 50;
    [self.view addSubview:self.mainTableView];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectZero];
    if (self.pageIndex == 0) {
        headView.frame = CGRectMake(0, 0, KScreenWidth, 164);
        [headView addSubview:self.recordHeadView];
        self.mainTableView.tableHeaderView = headView;
    }else if (self.pageIndex ==2){
        [self locate];//获取位置信息
        
        headView.frame = CGRectMake(0, 0, KScreenWidth,36);
        [headView addSubview:self.cityHeadView];
        [self.cityHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(headView);
        }];
        self.mainTableView.tableHeaderView = headView;
        
    }
    
    _dataArray = @[].mutableCopy;
    if (self.pageIndex !=2) {
        [self.mainTableView.mj_header beginRefreshing];
    }
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
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSNumber numberWithInteger:self.currrentPage] forKey:@"page"];
    [params setObject:KLimitCount forKey:@"limit"];
    
    if (self.pageIndex ==0) {
        [params setObject:@"recommend" forKey:@"type"];
    }else if (self.pageIndex == 1){
        [params setObject:@"follow" forKey:@"type"];
    }else if (self.pageIndex == 2){
        [params setObject:@"same_city" forKey:@"type"];
    }
    
    [ShareRequest shareRequestDataWithAppendURL:@"/post/post/get_post" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            if (self.currrentPage ==1) {
                [self.dataArray removeAllObjects];
            }
            self.totalCount = [dic[@"total"] integerValue];
            [self.dataArray addObjectsFromArray:[SYHomeThemeModel mj_objectArrayWithKeyValuesArray:dic[@"list"]]];
            
            if (self.dataArray.count ==0) {
                
                if (self.pageIndex ==0) {
                    [self.mainTableView showNoDataStatusWithString:@"去发布第一个动态吧" withOfffset:-80];
                }else if (self.pageIndex ==1){
                    [self.mainTableView showNoDataStatusWithString:@"您还未关注任何用户，请先添加关注" imageName:@"noData_list" withOfffset:-80];
                }else if (self.pageIndex ==2){
                    [self.mainTableView showNoDataStatusWithString:@"去发布第一个动态吧" withOfffset:-80];
                }
            }
            [self.mainTableView reloadData];
        }
        
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
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYHomeThemeModel *model = self.dataArray[indexPath.section];
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
    SYHomeThemeModel *model = self.dataArray[indexPath.section];
    cell.cellDelegate = self;
    cell.momentModel = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYMomentDetailViewController *momentDetailVC = [[SYMomentDetailViewController alloc]init];
    momentDetailVC.momentModel = self.dataArray[indexPath.section];
    [self.navigationController pushViewController:momentDetailVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

#pragma mark --YjxCustomTableViewCellDelegate
-(void)clickFoldLabel:(SYCustomTableViewCell *)cell{
    
    NSIndexPath * indexPath = [self.mainTableView indexPathForCell:cell];
    [UIView setAnimationsEnabled:NO];
    [self.mainTableView beginUpdates];
    [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.mainTableView endUpdates];
    [UIView setAnimationsEnabled:YES];
    
}

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
        [cell.toolbar.starBtn setTitle:[NSString stringWithFormat:@"%ld",(long)[cell.momentModel.good integerValue]+(cell.momentModel.if_good ?1:-1)] forState:UIControlStateNormal];
        cell.momentModel.good = cell.toolbar.starBtn.titleLabel.text;
    } Fail:^(NSError *error) {
        
    }];
}
- (void)collectionAction:(SYCustomTableViewCell *)cell{
    
    [ShareRequest shareRequestDataWithAppendURL:@"/post/post_about/collection" Params:@{@"post_id":cell.momentModel.post_id} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        
        cell.momentModel.if_collection = !cell.momentModel.if_collection;
        cell.toolbar.collectionBtn.selected = cell.momentModel.if_collection;
        [cell.toolbar.collectionBtn setTitle:[NSString stringWithFormat:@"%ld",(long)[cell.momentModel.collection integerValue]+(cell.momentModel.if_collection ?1:-1)] forState:UIControlStateNormal];
        cell.momentModel.collection = cell.toolbar.collectionBtn.titleLabel.text;
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
#pragma mark -- 点赞
- (void)locate {
    
    if ([CLLocationManager locationServicesEnabled]) {//监测权限设置
        
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;//设置代理
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;//设置精度
        self.locationManager.distanceFilter = 1000.0f;//距离过滤
        [self.locationManager requestAlwaysAuthorization];//位置权限申请
        [self.locationManager startUpdatingLocation];//开始定位
    }
}
#pragma mark location代理
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未开启定位服务，是否需要开启？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self.mainTableView showNoDataStatusWithString:@"未获取到位置信息" withOfffset:-60];
    }];
    UIAlertAction *queren = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *setingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:setingsURL];
    }];
    [alert addAction:cancel];
    [alert addAction:queren];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    [self.locationManager stopUpdatingLocation];//停止定位
    //地理反编码
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //当系统设置为其他语言时，可利用此方法获得中文地理名称
    NSMutableArray
    *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"];
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans", nil]forKey:@"AppleLanguages"];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            NSString *city = placeMark.locality;
            if (!city) {
                self.cityHeadView.locationLB.text = @"⟳定位获取失败,点击重试";
            } else {
                
                self.cityHeadView.locationLB.text =[NSString stringWithFormat:@"定位:%@%@%@%@",placeMark.locality, placeMark.subLocality, placeMark.thoroughfare,placeMark.name];//获取当前城市
                
                [self updateLocationMessage:[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude] andLatitude:[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude]];
                
            }
            
        } else if (error == nil && placemarks.count == 0 ) {
        } else if (error) {
            self.cityHeadView.locationLB.text = @"⟳定位获取失败,点击重试";
        }
        // 还原Device 的语言
        [[NSUserDefaults
          standardUserDefaults] setObject:userDefaultLanguages
         forKey:@"AppleLanguages"];
    }];
}

#pragma mark - JXPagingViewListViewDelegate
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.mainTableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listWillAppear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

- (void)listDidAppear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

- (void)listWillDisappear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

- (void)listDidDisappear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}
- (void)dealloc {
    NSLog(@"----- %@ delloc", self.class);
}

- (void)updateLocationMessage:(NSString*)longitudeStr andLatitude:(NSString*)latitudeStr{
    [ShareRequest shareRequestDataWithAppendURL:@"/post/post_about/position" Params:@{@"longitude":longitudeStr,@"latitude":latitudeStr} IsShowHud:NO IsInteract:NO Complete:^(NSDictionary *dic) {
        
        [self.mainTableView.mj_header beginRefreshing];
        
    } Fail:^(NSError *error) {
        
    }];
}

@end

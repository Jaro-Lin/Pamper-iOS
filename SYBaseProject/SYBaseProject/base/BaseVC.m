//
//  BaseVC.m
//  magicShop
//
//  Created by apple on 2019/10/31.
//  Copyright © 2019 YYB. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KUIColorFromRGB(0xeeeeee);
     self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.currrentPage = 1;
    
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(returnPageWithClick) image:@"icon_back" highImage:@"icon_back" horizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    [self initView];
    [self configurationNavigationItem];
    [self bindingViewModel];
    [self configurationData];
}
- (void)initView{
        
}
- (void)configurationData{   
}
- (void)configurationNavigationItem{}
- (void)bindingViewModel{ }
- (void)returnPageWithClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)headerRereshing{
    
}

-(void)footerRereshing{
    
}

- (void)setMainCollectionViewRefresh{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.mainCollectionView.mj_header = header;
    
    //底部刷新
    self.mainCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    self.mainCollectionView.scrollsToTop = YES;
    
}
/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)mainTableView{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
         _mainTableView.backgroundColor = KUIColorFromRGB(0xf7f7f7);
        
        //头部刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        _mainTableView.mj_header = header;
        
        //底部刷新
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
//        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
//        _tableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;

        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.scrollsToTop = YES;
        _mainTableView.tableFooterView = [[UIView alloc] init];
    }
    return _mainTableView;
}

/**
 *  懒加载collectionView
 *
 *  @return collectionView
 */
- (UICollectionView *)mainCollectionView{
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _mainCollectionView.backgroundColor = KUIColorFromRGB(0xf7f7f7);
    }
    return _mainCollectionView;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
        _controlView.prepareShowControlView = YES;
    }
    return _controlView;
}

@end

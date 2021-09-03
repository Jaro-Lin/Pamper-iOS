//
//  BaseVC.h
//  magicShop
//
//  Created by apple on 2019/10/31.
//  Copyright © 2019 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Nib.h"
#import <MJRefresh.h>
#import "UIScrollView+Empty.h"
#import <MJExtension/MJExtension.h>

#import "YBImageBrowser.h"
#import "YBIBVideoData.h"

#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFOrientationObserver.h>
#import "ZFPlayerControlView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseVC : UIViewController

/**按需添加,需要设置frame*/
@property (nonatomic, strong) UITableView * mainTableView;
@property (nonatomic, strong) UICollectionView * mainCollectionView;

/**分页*/
@property (nonatomic,assign) NSInteger currrentPage;
@property (nonatomic,assign) NSInteger totalCount;

/**播放器*/
@property (nonatomic, strong) ZFPlayerControlView *controlView;

- (void)setMainCollectionViewRefresh;
- (void)initView;
- (void)returnPageWithClick;

- (void)headerRereshing;
- (void)footerRereshing;

@end

NS_ASSUME_NONNULL_END

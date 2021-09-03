//
//  SYHomeListViewController.h
//  SYBaseProject
//
//  Created by sy on 2020/3/25.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "BaseVC.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYHomeListViewController : BaseVC <JXPagerViewListViewDelegate>
@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic, assign) BOOL isNeedFooter;
@property (nonatomic, assign) BOOL isNeedHeader;
//@property (nonatomic,copy) NSString *keyWord;//搜索的关键词

//- (void)addTableViewRefresh;

@end

NS_ASSUME_NONNULL_END

//
//  SYHomePageViewController.h
//  YNPageViewController
//
//  Created by ZYN on 2018/6/22.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "BaseVC.h"
#import "JXPagerView.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryView.h"
#import "JXPagerListRefreshView.h"

static const CGFloat JXTableHeaderViewHeight = 126;

@interface SYHomePageViewController : BaseVC <JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate,JXCategoryViewDelegate>

@property (nonatomic, strong) JXPagerView *pagerView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, assign) BOOL isNeedFooter;
@property (nonatomic, assign) BOOL isNeedHeader;
@property (nonatomic, strong) NSArray <NSString *> *titles;

- (JXPagerView *)preferredPagingView;

@end

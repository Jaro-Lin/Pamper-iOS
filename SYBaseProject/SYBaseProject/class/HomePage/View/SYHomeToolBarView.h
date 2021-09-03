//
//  SYHomeToolBarView.h
//  SYBaseProject
//
//  Created by sy on 2020/3/25.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,toolBarViewType) {
    toolBarView_list,
    toolBarView_listDetail
};
//  声明协议
@protocol SYHomeToolBarViewDelegate <NSObject>

@optional
- (void)commontAction;
- (void)starAction;
- (void)collectionAction;
- (void)shareAction;
@end

@interface SYHomeToolBarView : UIView
@property (nonatomic,assign) toolBarViewType barType;

@property (nonatomic,weak) id<SYHomeToolBarViewDelegate>  btnDelegate;

@property(nonatomic, strong) UIButton *commontBtn;
@property(nonatomic, strong) UIButton *starBtn;
@property(nonatomic, strong) UIButton *collectionBtn;
@property(nonatomic, strong) UIButton *shareBtn;

@end

NS_ASSUME_NONNULL_END

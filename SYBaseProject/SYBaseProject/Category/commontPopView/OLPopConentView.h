//
//  OLPopConentView.h
//  OLive
//
//  Created by 肖桂林 on 2019/4/20.
//  Copyright © 2019 oldManLive. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OLPopConentView : UIView

@property (nonatomic,strong)UIView *contentView;

- (void)showPopView;

- (void)showCenterPopView;

- (void)dismissPopView;

@end

NS_ASSUME_NONNULL_END

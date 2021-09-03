//
//  OLCommentView.h
//  OLive
//
//  Created by xiao on 2019/4/13.
//  Copyright © 2019 oldManLive. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OLCommentView : UIView

@property (nonatomic,copy)void (^sendCommentBlock)(void);
@property (nonatomic,copy)void (^cancelCommentView)(void);//关闭弹框
@property (nonatomic,assign) int fvc_vid;

@end

NS_ASSUME_NONNULL_END

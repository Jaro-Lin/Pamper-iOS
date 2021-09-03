//
//  OLCommtTextView.h
//  OLive
//
//  Created by xiao 2019/4/14.
//  Copyright © 2019 oldManLive. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OLCommtTextView : UIView

@property (nonatomic,copy)void(^sendCommentResp)(NSString *commontStr);

@end

NS_ASSUME_NONNULL_END

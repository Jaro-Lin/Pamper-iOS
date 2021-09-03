//
//  SYTopicListViewController.h
//  SYBaseProject
//
//  Created by sy on 2020/3/30.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "BaseVC.h"
#import "SYTopicModel.h"

@protocol SYTopicListViewControllerDelegate <NSObject>
@optional
- (void)topicSelected:(SYTopicModel*_Nonnull)topic;
@end

NS_ASSUME_NONNULL_BEGIN

@interface SYTopicListViewController : BaseVC
@property(nonatomic, assign) BOOL isTopicChoosed;
@property (nonatomic,weak) id<SYTopicListViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

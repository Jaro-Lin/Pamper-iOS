//
//  SYCommentDetailViewController.h
//  SYBaseProject
//
//  Created by apple on 2020/4/22.
//  Copyright © 2020 YYB. All rights reserved.
//  更多评论-二级评论

#import "BaseVC.h"
#import "SYCommontModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYCommentDetailViewController : BaseVC
//上一级评论
@property(nonatomic, strong) SYCommontModel *selectedCommont;
@property (nonatomic,copy) NSString *post_id;//动态id
@property (nonatomic,assign) CGFloat tableHeadViewHeight;//
@end

NS_ASSUME_NONNULL_END

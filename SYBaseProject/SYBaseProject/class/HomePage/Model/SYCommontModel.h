//
//  SYCommontModel.h
//  SYBaseProject
//
//  Created by apple on 2020/4/21.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "baseModel.h"
@class SYUserCommontModel;

NS_ASSUME_NONNULL_BEGIN

@interface SYCommontModel : baseModel
/**  */
@property (nonatomic,copy) NSString *comment_total;
/**  */
@property (nonatomic,copy) NSString *content;
/**  */
@property (nonatomic,copy) NSString *create_time;
/**  */
@property (nonatomic,strong) NSArray *extend;
/**  */
@property (nonatomic,copy) NSString *ID;
/**  */
@property (nonatomic,strong) NSArray *imgs;
/**  */
@property (nonatomic,assign) BOOL is_good;
/** 是否是自己的评论 */
@property (nonatomic,assign) BOOL is_owner;
/**  */
@property (nonatomic,copy) NSString *parent_id;
/** 2级评论者 */
@property (nonatomic,strong) SYUserCommontModel *reply;
/** 一级评论者 */
@property(nonatomic, strong) SYUserCommontModel *user;
/**  */
@property (nonatomic,copy) NSString *total_like;


@end

@interface SYUserCommontModel : baseModel
/**  */
@property (nonatomic,copy) NSString *avatar;
/**  */
@property (nonatomic,copy) NSString *ID;
/**  */
@property (nonatomic,copy) NSString *nickname;


@end

NS_ASSUME_NONNULL_END

//
//  SYFansCollectionModel.h
//  SYBaseProject
//
//  Created by sy on 2020/5/10.
//  Copyright © 2020 YYB. All rights reserved.
//  关注-粉丝模型

#import "baseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYFansCollectionModel : baseModel
/** 粉丝uid */
@property (nonatomic,copy) NSString *uid;
/** 用户是否关注该粉丝 */
@property (nonatomic,assign) BOOL if_follow;
/**  */
@property (nonatomic,copy) NSString *server;
/**  */
@property (nonatomic,copy) NSString *avatar;
/**  */
@property (nonatomic,copy) NSString *nickname;
/**  */
@property (nonatomic,copy) NSString *spe;


@end

NS_ASSUME_NONNULL_END

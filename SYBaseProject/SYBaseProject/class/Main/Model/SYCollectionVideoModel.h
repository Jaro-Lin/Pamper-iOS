//
//  SYCollectionVideoModel.h
//  SYBaseProject
//
//  Created by sy on 2020/5/10.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "baseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYCollectionVideoModel : baseModel
/** 视频id */
@property (nonatomic,copy) NSString *video_id;
/** 视频分类id */
@property (nonatomic,copy) NSString *type_id;
/** 封面图 */
@property (nonatomic,copy) NSString *image;
/** 标题 */
@property (nonatomic,copy) NSString *title;
/** 是否收藏 1是 0否 */
@property (nonatomic,copy) NSString *if_collection;

@end



NS_ASSUME_NONNULL_END

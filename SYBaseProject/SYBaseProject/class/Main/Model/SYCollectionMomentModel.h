//
//  SYCollectionMomentModel.h
//  SYBaseProject
//
//  Created by sy on 2020/5/10.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "baseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYCollectionMomentModel : baseModel
/**  */
@property (nonatomic,copy) NSString *post_id;
/**  */
@property (nonatomic,copy) NSString *theme_id;
/**  */
@property (nonatomic,copy) NSString *theme;
/**  */
@property (nonatomic,copy) NSString *comment_total;
/**  */
@property (nonatomic,copy) NSString *good;
/**  */
@property (nonatomic,assign) BOOL if_good;
/**  */
@property (nonatomic,copy) NSString *collection;
/**  */
@property (nonatomic,assign) BOOL if_collection;

@end

NS_ASSUME_NONNULL_END

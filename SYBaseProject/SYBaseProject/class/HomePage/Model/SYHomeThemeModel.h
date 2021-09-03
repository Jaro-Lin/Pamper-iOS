//
//  SYHomeThemeModel.h
//  SYBaseProject
//
//  Created by sy on 2020/4/18.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "baseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYHomeThemeModel : baseModel
@property (nonatomic,copy) NSString *ID;
/**  */
@property (nonatomic,copy) NSString *post_id;
/**  */
@property (nonatomic,copy) NSString *content;
/**  */
@property (nonatomic,copy) NSString *city;
/**  */
@property (nonatomic,copy) NSString *nickname;
/**  */
@property (nonatomic,copy) NSString *avatar;

/**  */
@property (nonatomic,copy) NSString *theme_id;
/**  */
@property (nonatomic,copy) NSString *theme_title;
/**  */
@property (nonatomic,copy) NSString *post_time;
@property (nonatomic,copy) NSString *add_time;
/**  */
@property (nonatomic,strong) NSArray *images;
/**  */
@property (nonatomic,strong) NSArray *image;

/**  */
@property (nonatomic,strong) NSArray *video;

/**  */
@property (nonatomic,copy) NSString *good;
/**  */
@property (nonatomic,copy) NSString *comment;
/**  */
@property (nonatomic,copy) NSString *collection;
@property (nonatomic,copy) NSString *server;
@property (nonatomic,assign) BOOL if_collection;
@property (nonatomic,assign) BOOL if_good;
@property (nonatomic,copy) NSString *uid;

@property (nonatomic,copy) NSString *comment_id;


@end

NS_ASSUME_NONNULL_END

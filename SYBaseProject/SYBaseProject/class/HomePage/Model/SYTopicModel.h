//
//  SYTopicModel.h
//  SYBaseProject
//
//  Created by sy on 2020/4/18.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "baseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYTopicModel : baseModel
/**  */
@property (nonatomic,copy) NSString *ID;
/**  */
@property (nonatomic,copy) NSString *use_num;
/**  */
@property (nonatomic,copy) NSString *theme_title;

@end

NS_ASSUME_NONNULL_END

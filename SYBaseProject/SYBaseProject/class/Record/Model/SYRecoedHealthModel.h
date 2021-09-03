//
//  SYRecoedHealthModel.h
//  SYBaseProject
//
//  Created by apple on 2020/7/21.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "baseModel.h"
@class SYRecoedHealthChildModel;

NS_ASSUME_NONNULL_BEGIN

@interface SYRecoedHealthModel : baseModel
/**  */
@property (nonatomic,copy) NSString *ID;
/**  */
@property (nonatomic,copy) NSString *title;
/**  */
@property (nonatomic,strong) NSArray *child;

@end

@interface SYRecoedHealthChildModel : baseModel
/**  */
@property (nonatomic,copy) NSString *ID;
/**  */
@property (nonatomic,copy) NSString *cate_id;
/**  */
@property (nonatomic,copy) NSString *title;
@end

NS_ASSUME_NONNULL_END

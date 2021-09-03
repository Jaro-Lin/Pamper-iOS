//
//  SYCouponModel.h
//  SYBaseProject
//
//  Created by sy on 2020/5/10.
//  Copyright © 2020 YYB. All rights reserved.
//  优惠券模型

#import "baseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYCouponModel : baseModel
/** 我的优惠券id */
@property (nonatomic,copy) NSString *ID;
/** //优惠券id */
@property (nonatomic,copy) NSString *coupon_id;
/**  */
@property (nonatomic,copy) NSString *start_time;
/**  */
@property (nonatomic,copy) NSString *end_time;
/** 优惠券标题 */
@property (nonatomic,copy) NSString *title;
/**  */
@property (nonatomic,copy) NSString *content;
/**  */
@property (nonatomic,copy) NSString *price;
/** 满多少可用 */
@property (nonatomic,copy) NSString *has_price;
/// allow    是否过期 0过期 1 未过期
 @property (nonatomic,assign) BOOL allow;

@end

NS_ASSUME_NONNULL_END

//
//  MSUserModel.h
//  magicShop
//
//  Created by apple on 2020/1/14.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "baseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSUserModel : baseModel
/** 目前没有数据返回--逻辑占位 */
@property (nonatomic,copy) NSString *uid;
/**  */
@property (nonatomic,copy) NSString *token;
/**  */
@property (nonatomic,copy) NSString *nickname;
///**  */
@property (nonatomic,copy) NSString *avatar;
///** 1-男  0 -女 */
@property (nonatomic,copy) NSString *sex;
///**  */
@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *birthdayStr;
///**  */
@property (nonatomic,copy) NSString *city;
@property (nonatomic,assign) BOOL is_reg;
///**  */
@property (nonatomic,copy) NSString *server;

@end

@interface MSUserInfoModel : baseModel
/**  */
@property (nonatomic,copy) NSString *avatar;
/**  */
@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *birthdayStr;
/**  */
@property (nonatomic,copy) NSString *city;
/**  */
@property (nonatomic,copy) NSString *coupon_count;
/**  */
@property (nonatomic,copy) NSString *fans_count;

/**  */
@property (nonatomic,copy) NSString *follow_count;
/**  */
@property (nonatomic,copy) NSString *last_login_phone;
/**  */
@property (nonatomic,copy) NSString *last_login_time;
/**  */
@property (nonatomic,copy) NSString *last_sign_day;
/**  */
@property (nonatomic,copy) NSString *log_time;

/**  */
@property (nonatomic,copy) NSString *nickname;
/**  */
@property (nonatomic,copy) NSString *phone;
/**  */
@property (nonatomic,copy) NSString *post_count;
/**  */
@property (nonatomic,copy) NSString *server;
/**  */
@property (nonatomic,copy) NSString *sign_in_count;

/**  */
@property (nonatomic,copy) NSString *spe;
@property (nonatomic,copy) NSString *sex;
@end
NS_ASSUME_NONNULL_END

//
//  SYPetModel.h
//  SYBaseProject
//
//  Created by apple on 2020/4/16.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "baseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYPetModel : baseModel//宠物信息
/** 宠物id */
@property (nonatomic,copy) NSString *type_id;//注册
@property (nonatomic,copy) NSString *pid;//编辑
/** 宠物品种id */
@property (nonatomic,copy) NSString *varieties_id;
/**  */
@property (nonatomic,copy) NSString *varieties_name;
/** 宠物昵称 */
@property (nonatomic,copy) NSString *nickname;

/** 性别 */
@property (nonatomic,copy) NSString *sex;
/** 出生日期 */
@property (nonatomic,copy) NSString *brithday;
@property (nonatomic,copy) NSString *birthdayStr;
/** 体重 */
@property (nonatomic,copy) NSString *weight;
/** 是否绝育：0否 1是 */
@property (nonatomic,copy) NSString *sterilization;
/** 头像 */
@property (nonatomic,copy) NSString *avatar;

@property (nonatomic,copy) NSString *server;
/**  */
@property (nonatomic,copy) NSString *age;
/**  */
@property (nonatomic,copy) NSString *ID;
/** 是否初始化信息 */
@property (nonatomic,assign) BOOL is_init;
/** 健康状况 健康,生病 两样*/
@property (nonatomic,copy) NSString *healthy;
@property(nonatomic, strong) NSDictionary *body_status;
@property(nonatomic, strong) NSDictionary *do_some;
@property(nonatomic, copy) NSString *do_someStr;

@property (nonatomic,assign) BOOL if_default;
/**  */
@property (nonatomic,copy) NSString *log_time;
@property (nonatomic,assign) BOOL real_sex;

@end

@interface SYPetBreedModel : baseModel//品种
/**  */
@property (nonatomic,copy) NSString *ID;
/**  */
@property (nonatomic,copy) NSString *type_id;
/**  */
@property (nonatomic,copy) NSString *varieties_name;
/**  */
@property (nonatomic,copy) NSString *weight;

@end

@interface SYPetTypeModel : baseModel//种类
/**  */
@property (nonatomic,copy) NSString *ID;
/**  */
@property (nonatomic,copy) NSString *name;
@end



NS_ASSUME_NONNULL_END

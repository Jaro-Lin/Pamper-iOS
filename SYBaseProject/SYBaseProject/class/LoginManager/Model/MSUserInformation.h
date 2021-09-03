//
//  MSUserInformation.h
//  magicShop
//
//  Created by apple on 2020/1/14.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "baseModel.h"
#import "MSUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSUserInformation : baseModel

+ (instancetype) sharedManager;

@property (nonatomic,strong) MSUserModel *user;
@property (nonatomic,strong) MSUserInfoModel *userInfo;

//保存user到本地
- (void)saveUser:(MSUserModel*)user;
//保存userInfo到本地
- (void)saveUserInfo:(MSUserInfoModel*)userInfo;
//清除user本地信息
- (void)clearUser;
//根据token是否为空，判断用户是否登录
- (BOOL)isLogin;

@end

NS_ASSUME_NONNULL_END

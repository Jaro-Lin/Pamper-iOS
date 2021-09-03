//
//  MSUserInformation.m
//  magicShop
//
//  Created by apple on 2020/1/14.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "MSUserInformation.h"
#import "NSObject+SaveModelToKeyedArchiver.h"

@implementation MSUserInformation

static MSUserInformation *instance;

+ (instancetype) sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (MSUserModel *)user
{
    MSUserModel *user = [[MSUserModel new] getDataFromLocalWithUniqueFlagKey:kUserModel];
    if (user) {
        return user;
    }
    return nil;
}
- (MSUserInfoModel *)userInfo{
    MSUserInfoModel *userInfo = [[MSUserInfoModel new] getDataFromLocalWithUniqueFlagKey:kUserInfoModel];
    if (userInfo) {
        return userInfo;
    }
    return nil;
}

//保存user到本地
- (void)saveUser:(MSUserModel*)user
{
    [user saveDataToLocalWithUniqueFlagKey:kUserModel];
}
- (void)saveUserInfo:(MSUserInfoModel*)userInfo{
    [userInfo saveDataToLocalWithUniqueFlagKey:kUserInfoModel];
}
//清除user本地信息
- (void)clearUser
{
    [self.user removeDataFromLocalWithUniqueFlagKey:kUserModel];
    [self.userInfo removeDataFromLocalWithUniqueFlagKey:kUserInfoModel];
}

- (BOOL)isLogin
{
    if (!self.user.token) {
        return NO;
    }else
    {
        return YES;
    }
}

@end


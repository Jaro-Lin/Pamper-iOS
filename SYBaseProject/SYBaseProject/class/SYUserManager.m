//
//  SYUserManager.m
//  SYBaseProject
//
//  Created by apple on 2020/12/1.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYUserManager.h"
#import "NSObject+SaveModelToKeyedArchiver.h"

#define kPetShowModel  @"PetShowModel"  //保存user信息到钥匙串

@implementation SYUserManager
+ (instancetype)shareManager {
    static SYUserManager *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 要使用self来调用
        _shareManager = [[self alloc] init];
    });
    return _shareManager;
}

- (SYPetModel *)user
{
    SYPetModel *user = [[SYPetModel new] getDataFromLocalWithUniqueFlagKey:kPetShowModel];
    if (user) {
        return user;
    }
    return nil;
}
- (void)saveShowPet:(SYPetModel *)pet{
    [pet saveDataToLocalWithUniqueFlagKey:kPetShowModel];
}

//清除user本地信息
- (void)clearShowPet{
    [self.petShow removeDataFromLocalWithUniqueFlagKey:kPetShowModel];
}

@end

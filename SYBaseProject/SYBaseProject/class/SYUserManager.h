//
//  SYUserManager.h
//  SYBaseProject
//
//  Created by apple on 2020/12/1.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYPetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYUserManager : NSObject

+ (instancetype)shareManager;
@property(nonatomic, strong) SYPetModel *petShow;
@property(nonatomic, strong) NSArray<SYPetModel*> *allPetsArr;

//保存当前宠物信息到本地
- (void)saveShowPet:(SYPetModel*)pet;
//清除当前宠物本地信息
- (void)clearShowPet;
/**是否需要更换宠物
    当宠物被删除时，需要重新更换
 */
- (BOOL)isNeedChangePet;
@end

NS_ASSUME_NONNULL_END

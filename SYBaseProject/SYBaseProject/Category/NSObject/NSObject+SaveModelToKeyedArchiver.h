//
//  NSObject+SaveModelToKeyedArchiver.h
//  MIX-Token
//
//  Created by zq-008 on 2018/4/29.
//  Copyright © 2018年 mix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SaveModelToKeyedArchiver)

//保存对象数据到本地
- (void)saveDataToLocalWithUniqueFlagKey:(NSString *)uniqueFlagKey;

//清空本地存储的对象数据
- (id)getDataFromLocalWithUniqueFlagKey:(NSString *)uniqueFlagKey;

//从本地获取对象数据
- (BOOL)removeDataFromLocalWithUniqueFlagKey:(NSString *)uniqueFlagKey;

@end

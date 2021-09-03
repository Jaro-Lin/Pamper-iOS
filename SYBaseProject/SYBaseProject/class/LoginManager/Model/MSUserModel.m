//
//  MSUserModel.m
//  magicShop
//
//  Created by apple on 2020/1/14.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "MSUserModel.h"

@implementation MSUserModel

- (NSString *)birthdayStr{
     if (kStringIsEmpty(_birthday)) return @"";
    
    NSMutableString *str = [[NSMutableString alloc]initWithString:_birthday];
    [str insertString:@"-" atIndex:_birthday.length-2];
    [str insertString:@"-" atIndex:4];
    return [str copy];
}
@end

@implementation MSUserInfoModel
- (NSString *)birthdayStr{
     if (kStringIsEmpty(_birthday)) return @"";
    
    NSMutableString *str = [[NSMutableString alloc]initWithString:_birthday];
    [str insertString:@"-" atIndex:_birthday.length-2];
    [str insertString:@"-" atIndex:4];
    return [str copy];
}

@end

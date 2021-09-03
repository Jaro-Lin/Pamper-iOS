//
//  SYPetModel.m
//  SYBaseProject
//
//  Created by apple on 2020/4/16.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYPetModel.h"

@implementation SYPetModel
- (NSString *)birthdayStr{
    if (kStringIsEmpty(_brithday)) return @"";
    NSMutableString *str = [[NSMutableString alloc]initWithString:_brithday];
    [str insertString:@"-" atIndex:_brithday.length-2];
    [str insertString:@"-" atIndex:4];
    return [str copy];
}
- (NSString *)do_someStr{
    //    {"bath":0,"expelling":0,"vaccin_1":0,"vaccin_0":0}
    NSString *string = @"需要";
    if ([_do_some[@"body_status"][@"feed"]floatValue]>0) {
           string = [string stringByAppendingString:@"喂食、"];
       }
    if ([_do_some[@"bath"]boolValue]) {
        string =[string stringByAppendingString:@"洗澡、"];
    }
    if ([_do_some[@"expelling"]boolValue]) {
        string = [string stringByAppendingString:@"驱虫、"];
    }
    if ([_do_some[@"vaccin_1"]boolValue]) {
        string = [string stringByAppendingString:@"打疫苗、"];
    }

    if ([string hasSuffix:@"、"]) {
        return [string substringToIndex:string.length-1];
    }else{
        return @"";
    }
 
}
@end

@implementation SYPetBreedModel

@end

@implementation SYPetTypeModel


@end

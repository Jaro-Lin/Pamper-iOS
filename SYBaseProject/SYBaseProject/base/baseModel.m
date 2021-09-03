//
//  baseModel.m
//  magicShop
//
//  Created by apple on 2020/1/14.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "baseModel.h"
#import <MJExtension/MJExtension.h>

@implementation baseModel
+(NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{
        @"ID":@"id"
    };
}

//去除null数据
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    
    if (oldValue == [NSNull null]) {
        
        if ([oldValue isKindOfClass:[NSArray class]]) {
            
            return @[];
            
        }else if([oldValue isKindOfClass:[NSDictionary class]]){
            
            return @{};
            
        }else if ([oldValue isKindOfClass:[NSString class]]){
            return @"";
        }else if ([oldValue isKindOfClass:[NSNumber class]]){
            return 0;
        }
        
    }
    return oldValue;
    
}
@end

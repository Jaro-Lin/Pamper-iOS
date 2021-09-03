//
//  SYAfterSaleModel.m
//  SYBaseProject
//
//  Created by apple on 2020/5/29.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYAfterSaleModel.h"

@implementation SYAfterSaleModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"shop":[SYAfterSaleShopModel class]
    };
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.img_urls = [NSMutableArray array];
    }
    return self;
}
@end

@implementation SYAfterSaleShopModel

@end


@implementation SYAfterSaleDetailModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"shop_info":[SYAfterSaleShopModel class]
    };
}


@end

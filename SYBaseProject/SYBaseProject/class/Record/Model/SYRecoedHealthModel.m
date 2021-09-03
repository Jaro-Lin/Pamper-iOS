//
//  SYRecoedHealthModel.m
//  SYBaseProject
//
//  Created by apple on 2020/7/21.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYRecoedHealthModel.h"

@implementation SYRecoedHealthModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"child":[SYRecoedHealthChildModel class]
    };
}

@end

@implementation SYRecoedHealthChildModel

@end

//
//  UIView+Nib.m
//  magicShop
//
//  Created by ksks on 2019/11/4.
//  Copyright © 2019 YYB. All rights reserved.
//

#import "UIView+Nib.h"

@implementation UIView (Nib)
 
+ (instancetype)instancesWithNib:(NSString *)nib index:(NSUInteger)index{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:nib owner:nil options:nil];
    return views[index];
}
+ (instancetype)instancesWithNib:(NSString *)nib{
    return [self instancesWithNib:nib index:0];
}
+ (instancetype)instancesLastWithNib:(NSString *)nib{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:nib owner:nil options:nil];
    return views.lastObject;
}
+ (instancetype)instancesFromeNib{
    Class cls = [self class];
    return [self instancesWithNib:NSStringFromClass(cls) index:0];
}
@end

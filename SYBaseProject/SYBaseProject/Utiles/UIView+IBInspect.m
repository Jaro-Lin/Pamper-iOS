//
//  UIView+IBInspect.m
//  magicShop
//
//  Created by ksks on 2019/11/24.
//  Copyright © 2019 YYB. All rights reserved.
//

#import "UIView+IBInspect.h"
#import "UIView+Corner.h"
#import <objc/runtime.h>
@implementation UIView (IBInspect)
@dynamic ib_cornerRadius;
 
 
- (void)setIb_cornerRadius:(CGFloat)ib_cornerRadius{
    [self setCorner:ib_cornerRadius];
}
 
@end

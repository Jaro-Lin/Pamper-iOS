//
//  UIView+Corner.m
//  magicShop
//
//  Created by ksks on 2019/11/20.
//  Copyright © 2019 YYB. All rights reserved.
//

#import "UIView+Corner.h"
 
@implementation UIView (Corner)
 
- (void)setCorner:(CGFloat)cor{
    self.layer.cornerRadius = cor;
    self.layer.masksToBounds = YES;
}
- (void)bezierCorner:(CGFloat)cor byRoundingCorners:(UIRectCorner)corners{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:self.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)bezierCorner:(CGFloat)cor{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners  cornerRadii:self.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
@end

//
//  UIView+Corner.h
//  magicShop
//
//  Created by ksks on 2019/11/20.
//  Copyright © 2019 YYB. All rights reserved.
//
 
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
 
@interface UIView (Corner)
 
- (void)setCorner:(CGFloat)cor;
- (void)bezierCorner:(CGFloat)cor byRoundingCorners:(UIRectCorner)corners;
- (void)bezierCorner:(CGFloat)cor;
IB_DESIGNABLE
@end

NS_ASSUME_NONNULL_END

//
//  UIView+Nib.h
//  magicShop
//
//  Created by ksks on 2019/11/4.
//  Copyright © 2019 YYB. All rights reserved.
//

 


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Nib)
+ (instancetype)instancesWithNib:(NSString *)nib;
+ (instancetype)instancesWithNib:(NSString *)nib index:(NSUInteger)index;
+ (instancetype)instancesLastWithNib:(NSString *)nib;
+ (instancetype)instancesFromeNib;

@end

NS_ASSUME_NONNULL_END

//
//  UIView+BaseView.m
//  paotui
//
//  Created by apple on 2019/3/11.
//  Copyright © 2019 ly. All rights reserved.
//

#import "UIView+BaseView.h"

@implementation UIView (BaseView)

+ (instancetype)getMyself {
    Class c = [self class];
    id view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(c) owner:self options:nil] lastObject];
    return view;
    
}

@end

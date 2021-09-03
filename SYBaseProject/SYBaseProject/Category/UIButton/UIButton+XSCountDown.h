//
//  UIButton+XSCountDown.h
//  MIX-Token
//
//  Created by zq-008 on 2018/4/19.
//  Copyright © 2018年 mix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XSCountDown)
- (void)xs_beginCountDownWithDuration:(NSTimeInterval)duration;
- (void)xs_stopCountDown;
@end

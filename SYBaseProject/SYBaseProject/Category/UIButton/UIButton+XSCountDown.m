//
//  UIButton+XSCountDown.m
//  MIX-Token
//
//  Created by zq-008 on 2018/4/19.
//  Copyright © 2018年 mix. All rights reserved.
//

#import "UIButton+XSCountDown.h"


static NSTimer *_countTimer;
static NSTimeInterval _count;
static NSString *_title;

@implementation UIButton (XSCountDown)

- (void)xs_beginCountDownWithDuration:(NSTimeInterval)duration {
    _title = self.titleLabel.text;
    _count = duration;
    _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(xs_updateTitle) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_countTimer forMode:NSRunLoopCommonModes];
    self.userInteractionEnabled = NO;
    
//    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.backgroundColor = COLOR(180, 182, 194, 1);
//    self.layer.borderColor = [UIColor clearColor].CGColor;
//    self.clipsToBounds = YES;
    [self setTitle:[NSString stringWithFormat:@"获取验证码(%ld)秒", (long)_count] forState:UIControlStateNormal];
    CGRect rect = self.frame;
    self.frame = CGRectMake(rect.origin.x-28, rect.origin.y, rect.size.width+28, rect.size.height);
 
}

- (void)xs_stopCountDown {
    [_countTimer invalidate];
    _countTimer = nil;
//    _count = 60.0;
    [self setTitle:_title forState:UIControlStateNormal];
    self.userInteractionEnabled = YES;
}

- (void)xs_updateTitle {
    NSString *countString = [NSString stringWithFormat:@"获取验证码(%ld)秒", (long)_count - 1];
    self.userInteractionEnabled = NO;
    [self setTitle:countString forState:UIControlStateNormal];
    if (_count-- <= 1.0) {
        [self xs_stopCountDown];
        
        CGRect rect = self.frame;
        self.frame = CGRectMake(rect.origin.x+28, rect.origin.y, rect.size.width-28, rect.size.height);

    }
    
}

@end

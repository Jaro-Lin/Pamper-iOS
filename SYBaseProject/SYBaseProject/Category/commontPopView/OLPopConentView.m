//
//  OLPopConentView.m
//  OLive
//
//  Created by 肖桂林 on 2019/4/20.
//  Copyright © 2019 oldManLive. All rights reserved.
//

#import "OLPopConentView.h"

@interface OLPopConentView ()

@property (nonatomic,strong)UIView *backView;

@end

@implementation OLPopConentView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (UIView *)backView{
    
    if (_backView == nil) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        self.backView = view;
    }
    return _backView;
}

- (void)setContentView:(UIView *)contentView{
    
    _contentView = contentView;
    self.backView.height = contentView.height;
    self.backView.width = contentView.width;
    [self.backView addSubview:contentView];
}

- (void)showPopView{
    
    UIWindow *window =  [[UIApplication sharedApplication].windows lastObject];
    self.frame = window.bounds;
    self.backView.y = self.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.bottom = self.height;
    }];
    [window addSubview:self];
}

- (void)showCenterPopView{
    
    UIWindow *window =  [[UIApplication sharedApplication].windows lastObject];
    self.frame = window.bounds;
    [UIView animateWithDuration:0.3 animations:^{
//        self.backView.centerY = self.height *0.5;
        self.backView.center = self.center;
    }];
    [window addSubview:self];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UIView *touchView = [touches anyObject].view;
    if ([touchView isKindOfClass:[_contentView class]]) {
        return;
    }
    [self dismissPopView];
}

- (void)dismissPopView{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.y = self.height;
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}

- (void)dealloc{
    
    NSLog(@"%s dealloc",__func__);
}

@end

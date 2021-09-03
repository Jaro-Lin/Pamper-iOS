//
//  OLCommtTextView.m
//  OLive
//
//  Created by xiao on 2019/4/14.
//  Copyright © 2019 oldManLive. All rights reserved.
//

#import "OLCommtTextView.h"

@interface OLCommtTextView ()<UITextFieldDelegate>

@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)UIButton *btn;
@property (nonatomic,strong)UIView *line;

@end
@implementation OLCommtTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCommentTextView];

    }
    return self;
}

- (void)createCommentTextView{
    
    _line = [[UIView alloc]init];
    [self addSubview:_line];
    _line.backgroundColor = RGB(234, 234, 234);
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
    [_btn setTitle:@"发送" forState:(UIControlStateNormal)];
    _btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_btn setBackgroundColor:RGB(250, 51, 23)];
    _btn.layer.cornerRadius = 17;
    _btn.layer.masksToBounds = YES;
    [self addSubview:_btn];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(34);
        make.centerY.equalTo(self);
    }];
    _textField = [[UITextField alloc]init];
    _textField.delegate = self;
    [self addSubview:_textField];
    _textField.placeholder = @"说点什么";
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.layer.cornerRadius = 17;
//    _textField.layer.masksToBounds = YES;
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(34);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-90);
    }];
}

#pragma mark --- 发送
- (void)sendComment:(UIButton *)sender{
    
    //发送评论 可以直接进行返回发送结构完成后 block
    if (self.textField.text.length <=0) {
        return;
    }
    !self.sendCommentResp ?:self.sendCommentResp(self.textField.text);
}



@end

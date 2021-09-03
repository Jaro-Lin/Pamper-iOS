//
//  SYChatKeyBoardView.m
//  SYBaseProject
//
//  Created by apple on 2020/8/4.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYChatKeyBoardView.h"

@implementation SYChatKeyBoardView
- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.inputTextView.delegate = self;
    self.inputTextView.returnKeyType = UIReturnKeySend;
    
    [[self.editeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(editeButtonClick)]) {
            [self.delegate editeButtonClick];
        }
    }];
    
    [[self.likeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(likeButtonClick)]) {
            [self.delegate likeButtonClick];
        }
    }];
    
    [[self.collectionBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionButtonClick)]) {
            [self.delegate collectionButtonClick];
        }
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.inputTextView resignFirstResponder];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputTextViewEndEdite:)]) {
            [self.delegate inputTextViewEndEdite:textView.text];
        }
        return NO;
    }
    
    return YES;
}
@end

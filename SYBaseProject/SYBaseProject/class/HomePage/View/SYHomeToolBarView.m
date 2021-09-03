//
//  SYHomeToolBarView.m
//  SYBaseProject
//
//  Created by sy on 2020/3/25.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYHomeToolBarView.h"
#import "UIColor+YMHex.h"
#import "UIButton+JKImagePosition.h"

@implementation SYHomeToolBarView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setUI];
        
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat buttonW = (KScreenWidth-KAdaptW(60)-KAdaptW(15))/3.0;
    CGFloat buttonH = KAdaptW(39);
    
    [self.commontBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).mas_offset(KAdaptW(15));
        make.height.mas_offset(buttonH);
        make.width.mas_offset(buttonW);
        make.centerY.equalTo(self.mas_centerY);
    }];
   
    [self.starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commontBtn.mas_right);
           make.height.mas_offset(buttonH);
           make.width.mas_offset(buttonW);
           make.centerY.equalTo(self.mas_centerY);
       }];
    
    [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starBtn.mas_right);
           make.height.mas_offset(buttonH);
           make.width.mas_offset(buttonW);
           make.centerY.equalTo(self.mas_centerY);
       }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(self.mas_right);
           make.height.mas_offset(KAdaptW(44));
           make.width.mas_offset(KAdaptW(44));
           make.centerY.equalTo(self.mas_centerY);
       }];
    

}
- (void)setUI {
    
    self.commontBtn = [self createBtn:@"icon_common" selectedImage:@"icon_common"];
    [self addSubview:self.commontBtn];
    
    self.starBtn = [self createBtn:@"icon_stark_nomal" selectedImage:@"icon_stark_selected"];
    [self addSubview:self.starBtn];
//    [self.starBtn setTitleColor:KUIColorFromRGB(0xff3030) forState:UIControlStateSelected];
    
    self.collectionBtn = [self createBtn:@"home_like_off" selectedImage:@"home_like_on"];
    [self addSubview:self.collectionBtn];
//    [self.collectionBtn setTitleColor:KUIColorFromRGB(0xff3030) forState:UIControlStateSelected];
    
    self.shareBtn = [self createBtn:@"icon_share" selectedImage:@"icon_share"];
    [self.shareBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self addSubview:self.shareBtn];
    
    [self.commontBtn jk_setImagePosition:LXMImagePositionLeft spacing:10];
    [self.collectionBtn jk_setImagePosition:LXMImagePositionLeft spacing:10];
    [self.starBtn jk_setImagePosition:LXMImagePositionLeft spacing:10];
    
    //按钮点击事件
    [[self.commontBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.btnDelegate && [self.btnDelegate respondsToSelector:@selector(commontAction)]) {
            [self.btnDelegate commontAction];
        }
    }];
    
    [[self.starBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.btnDelegate && [self.btnDelegate respondsToSelector:@selector(starAction)]) {
            [self.btnDelegate starAction];
        }
    }];
    
    [[self.collectionBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.btnDelegate && [self.btnDelegate respondsToSelector:@selector(collectionAction)]) {
            [self.btnDelegate collectionAction];
        }
    }];
    
    [[self.shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.btnDelegate && [self.btnDelegate respondsToSelector:@selector(shareAction)]) {
            [self.btnDelegate shareAction];
        }
    }];
}

- (UIButton*)createBtn:(NSString*)nomalImage selectedImage:(NSString*)selected{
    
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:kImageWithName(nomalImage) forState:UIControlStateNormal];
    [button setImage:kImageWithName(selected) forState:UIControlStateSelected];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    [button setTitleColor:KUIColorFromRGB(0x333333) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    return button;;
}

- (void)setBarType:(toolBarViewType)barType{
    _barType = barType;
    if (_barType == toolBarView_list) {
        [self.commontBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.starBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.collectionBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [self.commontBtn setImage:kImageWithName(@"icon_common") forState:UIControlStateNormal];
        [self.commontBtn setImage:kImageWithName(@"icon_common") forState:UIControlStateSelected];
        
        [self.starBtn setImage:kImageWithName(@"icon_stark_nomal") forState:UIControlStateNormal];
        [self.starBtn setImage:kImageWithName(@"icon_stark_selected") forState:UIControlStateSelected];
        
        [self.collectionBtn setImage:kImageWithName(@"icon_stok_nomal") forState:UIControlStateNormal];
        [self.collectionBtn setImage:kImageWithName(@"like_on") forState:UIControlStateSelected];
        
        
        self.shareBtn.hidden = NO;
        
    }else if(_barType == toolBarView_listDetail){
        
        [self.commontBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self.starBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self.collectionBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
        [self.commontBtn setImage:kImageWithName(@"") forState:UIControlStateNormal];
        [self.commontBtn setImage:kImageWithName(@"") forState:UIControlStateSelected];
        
        [self.starBtn setImage:kImageWithName(@"") forState:UIControlStateNormal];
        [self.starBtn setImage:kImageWithName(@"") forState:UIControlStateSelected];
        
        [self.collectionBtn setImage:kImageWithName(@"") forState:UIControlStateNormal];
        [self.collectionBtn setImage:kImageWithName(@"") forState:UIControlStateSelected];
        
        [self.commontBtn setTitle:@"评论(0)" forState:UIControlStateNormal];
        [self.starBtn setTitle:@"点赞(0)" forState:UIControlStateNormal];
        [self.collectionBtn setTitle:@"收藏(0)" forState:UIControlStateNormal];
        
        self.shareBtn.hidden = YES;
        
    }
}

@end

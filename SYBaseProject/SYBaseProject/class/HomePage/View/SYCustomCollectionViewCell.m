//
//  SYCustomCollectionViewCell.h
//  SYBaseProject
//
//  Created by sy on 2020/3/25.
//  Copyright © 2020 YYB. All rights reserved.
//


#import "SYCustomCollectionViewCell.h"
@interface SYCustomCollectionViewCell ()

@end

@implementation SYCustomCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _img = [[UIImageView alloc]init];
        [self.contentView addSubview:_img];
        _img.contentMode=UIViewContentModeScaleAspectFill;
        _img.clipsToBounds=YES;
        
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:kImageWithName(@"icon_play") forState:UIControlStateNormal];
        _playBtn.hidden = YES;
        [self.contentView addSubview:self.playBtn];
//        _playBtn.userInteractionEnabled = NO;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _img.frame = self.contentView.frame;
    _playBtn.frame = self.contentView.frame;
    
}
@end

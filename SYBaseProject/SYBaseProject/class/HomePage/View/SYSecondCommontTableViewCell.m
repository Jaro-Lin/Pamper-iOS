//
//  SYSecondCommontTableViewCell.m
//  SYBaseProject
//
//  Created by apple on 2020/6/17.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYSecondCommontTableViewCell.h"

@implementation SYSecondCommontTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    KViewRadius(self.userHead, 19);
    
    self.contentLB.preferredMaxLayoutWidth = KScreenWidth-75;
    self.deletedBtn.hidden = YES;
     [self.deletedBtn addTarget:self action:@selector(deletedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setReplyName:(NSString *)replyName{
    _replyName = replyName;
}
- (void)setCommontModel:(SYCommontModel *)commontModel{
    _commontModel = commontModel;
    
    [self.userHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageServer,_commontModel.user.avatar]] placeholderImage:kPlaceHoldImageUser];
    self.userName.text = _commontModel.user.nickname;
    self.timeLB.text = [NSString timintervalToTimeStr:kDateFormat_yMd timeInterval:[_commontModel.create_time integerValue]];
   
    self.zanBtn.selected = _commontModel.is_good;
    
    NSString *commontStr = [NSString stringWithFormat:@"回复@%@：%@",self.replyName,_commontModel.content];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:commontStr];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:RGBOF(0xff3030) range:NSMakeRange(2,self.replyName.length+1)];
    
    self.contentLB.attributedText = attributeStr;
    
    self.deletedBtn.hidden = !self.commontModel.is_owner;
}
- (void)deletedBtnClick:(UIButton*)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(secondCommontDeletedAction:)]) {
        [self.delegate secondCommontDeletedAction:self];
    }
}
@end

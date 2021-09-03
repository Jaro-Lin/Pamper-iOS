//
//  SYCommontTableViewCell.m
//  SYBaseProject
//
//  Created by sy on 2020/3/30.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYCommontTableViewCell.h"

@implementation SYCommontTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    KViewRadius(self.commontUserHead, 19);
    
    self.commontContent.preferredMaxLayoutWidth = KScreenWidth-75;
    self.totalCommontLB.preferredMaxLayoutWidth = KScreenWidth-75;
    self.deletedBtn.hidden = YES;
    [self.deletedBtn addTarget:self action:@selector(deletedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setCommontModel:(SYCommontModel *)commontModel{
    _commontModel = commontModel;
    
    [self.commontUserHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageServer,_commontModel.user.avatar]] placeholderImage:kPlaceHoldImageUser];
    self.commontUserName.text = _commontModel.user.nickname;
    self.commontContent.text = _commontModel.content;
    self.starBtn.selected = _commontModel.is_good;

    self.totalCommontLB.text = [NSString stringWithFormat:@"  共%@条评论",_commontModel.comment_total];
    self.timeLB.text = [NSString timintervalToTimeStr:kDateFormat_yMd timeInterval:[_commontModel.create_time integerValue]];
    
    //若为自己的评论 显示删除按钮
    self.deletedBtn.hidden = !self.commontModel.is_owner;
    
    
}
- (void)deletedBtnClick:(UIButton*)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(commontDeletedAction:)]) {
        [self.delegate commontDeletedAction:self];
    }
}
@end

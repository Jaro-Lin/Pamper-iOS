//
//  SYMineUserInfoTableViewCell.m
//  SYBaseProject
//
//  Created by sy on 2020/4/4.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYMineUserInfoTableViewCell.h"

@implementation SYMineUserInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    KViewRadius(self.userHead, 24);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

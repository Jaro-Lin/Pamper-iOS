//
//  SYMineUserInfoTableViewCell.h
//  SYBaseProject
//
//  Created by sy on 2020/4/4.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYMineUserInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *staticLB;
@property (weak, nonatomic) IBOutlet UIImageView *userHead;
@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLBMargin;

@end

NS_ASSUME_NONNULL_END

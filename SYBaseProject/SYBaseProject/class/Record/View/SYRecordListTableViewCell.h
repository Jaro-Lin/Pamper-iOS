//
//  SYRecordListTableViewCell.h
//  SYBaseProject
//
//  Created by sy on 2020/3/30.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYDaySchedule.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYRecordListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftLB;
@property (weak, nonatomic) IBOutlet UIButton *middleBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *sliderBtn;
@property (weak, nonatomic) IBOutlet UIButton *noticeBtn;

@property(nonatomic, strong) SYDaySchedule *dayModel;
@property(nonatomic, strong) RACSubject *subject;
@end

NS_ASSUME_NONNULL_END

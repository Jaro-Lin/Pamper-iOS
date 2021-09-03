//
//  SYCommontTableViewCell.h
//  SYBaseProject
//
//  Created by sy on 2020/3/30.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYCommontModel.h"

NS_ASSUME_NONNULL_BEGIN
@class SYCommontTableViewCell;
@protocol SYCommontTableViewCellDelegate <NSObject>
- (void)commontDeletedAction:(SYCommontTableViewCell*)commontCell;
@end

@interface SYCommontTableViewCell : UITableViewCell
@property (nonatomic,weak) id<SYCommontTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *commontUserHead;
@property (weak, nonatomic) IBOutlet UILabel *commontUserName;
@property (weak, nonatomic) IBOutlet UILabel *commontContent;
@property (weak, nonatomic) IBOutlet UIButton *commontBtn;
@property (weak, nonatomic) IBOutlet UIButton *starBtn;
@property (weak, nonatomic) IBOutlet UIButton *deletedBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalCommontLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property(nonatomic, strong) SYCommontModel *commontModel;

@end

NS_ASSUME_NONNULL_END

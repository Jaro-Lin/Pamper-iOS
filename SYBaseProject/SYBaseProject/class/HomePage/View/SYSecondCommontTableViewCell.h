//
//  SYSecondCommontTableViewCell.h
//  SYBaseProject
//
//  Created by apple on 2020/6/17.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYCommontModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SYSecondCommontTableViewCell;
@protocol SYSecondCommontTableViewCellDelegate <NSObject>
- (void)secondCommontDeletedAction:(SYSecondCommontTableViewCell*)commontCell;
@end


@interface SYSecondCommontTableViewCell : UITableViewCell
@property (nonatomic,weak) id<SYSecondCommontTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *userHead;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet UIButton *replayBtn;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIButton *deletedBtn;

@property(nonatomic, strong) SYCommontModel *commontModel;
@property (nonatomic,copy) NSString *replyName;
@end

NS_ASSUME_NONNULL_END

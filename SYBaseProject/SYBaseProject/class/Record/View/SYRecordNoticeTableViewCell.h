//
//  SYRecordNoticeTableViewCell.h
//  SYBaseProject
//
//  Created by apple on 2020/7/21.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYRecoedHealthModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYRecordNoticeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *topTitleLB;
@property (weak, nonatomic) IBOutlet UIView *detailContentView;

@property(nonatomic, strong) SYRecoedHealthModel *healthModel;
@end

NS_ASSUME_NONNULL_END

//
//  SYSocietyView.h
//  SYBaseProject
//
//  Created by sy on 2020/4/9.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYTopicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYSocietyView : UIView
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *inputContentTF;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end

@interface SYSocietiesViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topicLB;
@property (weak, nonatomic) IBOutlet UIButton *enterSocietBtn;
@property(nonatomic, strong) SYTopicModel *topicModel;

@end

NS_ASSUME_NONNULL_END

//
//  SYSocietyView.m
//  SYBaseProject
//
//  Created by sy on 2020/4/9.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYSocietyView.h"
#import "NSObject+getCurrentViewController.h"
#import "SYTopicMomentsViewController.h"

@implementation SYSocietyView
- (void)awakeFromNib {
    [super awakeFromNib];
    KViewBorderRadius(self.searchView, 20, 1, KUIColorFromRGB(0x8a8a8a));

}
@end

@implementation SYSocietiesViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [[self.enterSocietBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        SYTopicMomentsViewController *topicVC = [[SYTopicMomentsViewController alloc]init];
        topicVC.title = self->_topicModel.theme_title;
        topicVC.themeID = self->_topicModel.ID;
        [[self getCurrentVC].navigationController pushViewController:topicVC animated:YES];
    }];
    
}
- (void)setTopicModel:(SYTopicModel *)topicModel{
    _topicModel = topicModel;
    self.topicLB.text = _topicModel.theme_title;
}
@end

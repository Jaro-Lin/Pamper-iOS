//
//  SYRecordListTableViewCell.m
//  SYBaseProject
//
//  Created by sy on 2020/3/30.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYRecordListTableViewCell.h"
#import "UIButton+JKImagePosition.h"

@implementation SYRecordListTableViewCell
- (RACSubject *)subject{
    if (!_subject) {
        _subject = [RACSubject subject];
    }
    return _subject;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setDayModel:(SYDaySchedule *)dayModel{
    _dayModel = dayModel;
    
    self.leftImageView.image = kImageWithName(_dayModel.itemImage);
    self.leftLB.text = _dayModel.itemStr;
    if (!kStringIsEmpty(_dayModel.warm)) {
        [self.middleBtn setTitle:_dayModel.warm forState:UIControlStateNormal];
        [self.middleBtn jk_setImagePosition:LXMImagePositionRight spacing:4];
        self.middleBtn.hidden = NO;
    }else{
        self.middleBtn.hidden = YES;
    }
    self.sliderBtn.selected = _dayModel.taskIsFinish;
    [self.rightBtn setTitle:_dayModel.itemValue forState:UIControlStateNormal];
    self.sliderBtn.hidden = !_dayModel.showTask;
    self.rightBtn.hidden = _dayModel.showTask;
    
}
- (IBAction)sliderBtnClick:(UIButton *)sender {
    
    //上月到当前的日期可以编辑
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *selectedDate = [formatter dateFromString:self.dayModel.selectedDay];
    //是否比当前时间小
    if ([selectedDate compare:[NSDate new]] != kCFCompareGreaterThan) {
        //判断是否在上个月的范围
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate new]];
        
        NSInteger year=[components year];
        NSInteger month=[components month];
        
        if (month ==1) {
            year = year-1;
            month = month;
        }else{
            month = month-1;
        }
        
        NSDate *lastMonthDate = [formatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-01",year,month]];
        if ([selectedDate compare:lastMonthDate] != kCFCompareLessThan) {
            sender.selected = !sender.selected;
            [self.subject sendNext:@""];
        }else{
            
            [[UIApplication sharedApplication].keyWindow makeToast:@"最多只能记录上个月的日期" duration:1.5 position:CSToastPositionCenter];
            return;
        }
    }else{
        [[UIApplication sharedApplication].keyWindow makeToast:@"不能记录未来日期" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
}
- (IBAction)rightBtnClick:(UIButton *)sender {
    //    [self.subject sendNext:@""];
}
- (IBAction)noticeBtnClick:(UIButton *)sender {
    [self.subject sendNext:@"1"];
}

@end

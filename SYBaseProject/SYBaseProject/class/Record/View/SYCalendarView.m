//
//  SYCalendarView.m
//  XFAssist
//
//  Created by apple on 2020/3/31.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYCalendarView.h"
#import <FSCalendar/FSCalendar.h>

#define KColor_Bath  RGBOF(0x23A0F0)
#define KColor_Expelling  FSCalendarStandardSelectionColor

@interface SYCalendarView ()<FSCalendarDelegate,FSCalendarDataSource>

@property(nonatomic, strong) FSCalendar *calendar;
@property (strong, nonatomic) NSCalendar *gregorian;

//@property (strong, nonatomic) NSDictionary *fillSelectionColors;
//@property (strong, nonatomic) NSDictionary *fillDefaultColors;
//@property (strong, nonatomic) NSDictionary *borderDefaultColors;
//@property (strong, nonatomic) NSDictionary *borderSelectionColors;
@property (strong, nonatomic) NSDateFormatter *dateFormatter1;
@property (strong, nonatomic) NSDateFormatter *dateFormatter2;
@property(nonatomic, strong) NSArray *schedules;

@end
@implementation SYCalendarView
- (RACSubject *)subject_Click{
    if (!_subject_Click) {
        _subject_Click = [RACSubject subject];
    }
    return _subject_Click;
}
- (FSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [[FSCalendar alloc]initWithFrame:CGRectZero];
        _calendar.delegate = self;
        _calendar.dataSource = self;
        
        _calendar.backgroundColor = [UIColor whiteColor];
        _calendar.appearance.headerMinimumDissolvedAlpha = 0;

        _calendar.appearance.headerDateFormat = @"yyyy-MM";
        _calendar.appearance.borderRadius = 1.0;  // 设置当前选择是圆形,0.0是正方形
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
        _calendar.locale = locale;  // 设置周次是中文显示
        
        _calendar.headerHeight = 0.0f; // 当不显示头的时候设置
        _calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
        
        _calendar.appearance.weekdayTextColor = [UIColor blackColor];
        _calendar.appearance.weekdayFont =[UIFont systemFontOfSize:16];
        
        _calendar.appearance.selectionColor =RGBOF(0x23A0F0);
        
        //设置从周一开始
        _calendar.firstWeekday = 2;
        // 设置不能翻页
        //_calendar.pagingEnabled = NO;
        _calendar.scrollEnabled = NO;
        
        //月份模式时，只显示当前月份
        _calendar.placeholderType = FSCalendarPlaceholderTypeFillHeadTail;
        
        //多选
        //        _calendar.allowsMultipleSelection = YES;
        //不允许点击
        //        _calendar.allowsSelection = NO;
    }
    return _calendar;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.calendar.frame = self.bounds;
        [self addSubview:self.calendar];
        self.dateFormatter2 = [[NSDateFormatter alloc] init];
        self.dateFormatter2.dateFormat = @"yyyy-MM-dd";
        
        self.dateFormatter1 = [[NSDateFormatter alloc] init];
        self.dateFormatter1.dateFormat = @"yyyy-MM";
        
        self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return self;
}
- (void)getData{
  
    //填充颜色
    //    self.fillSelectionColors = @{
    //        @"2020/06/17":[UIColor grayColor],
    //        @"2020/06/21":[UIColor cyanColor],
    //        @"2020/06/22":[UIColor grayColor],
    //        @"2020/06/24":[UIColor cyanColor]
    //    };
    
    //初始颜色
//    self.borderDefaultColors = @{
//        @"2020/06/17":[UIColor magentaColor],
//        @"2020/06/21":FSCalendarStandardSelectionColor,
//        @"2020/06/22":[UIColor magentaColor],
//        @"2020/06/24":FSCalendarStandardSelectionColor
//    };
    
    //选中颜色
    //    self.borderSelectionColors = @{
    //        @"2020/06/17":[UIColor purpleColor],
    //        @"2020/06/21":FSCalendarStandardSelectionColor,
    //        @"2020/06/22":[UIColor magentaColor],
    //        @"2020/06/24":FSCalendarStandardSelectionColor
    //    };
}

- (void)undateCalendarMonth:(NSString*)dataStr inSchedules:(NSArray*)schedules{
    self.schedules = schedules;
   
//    //上一个月
//    NSDate *nextMonth = [self.chineseCalendar dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:self.Calendar.currentPage options:0];
//
//    [self.calendar setCurrentPage:nextMonth animated:YES];
//
//    //下一个月
//
//    NSDate *nextMonth = [self.chineseCalendar dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:self.Calendar.currentPage options:0];

    NSDate*monthDate = [self.dateFormatter1 dateFromString:dataStr];
    [self.calendar setCurrentPage:monthDate animated:YES];

    [self.calendar reloadData];
}

#pragma mark - <FSCalendarDelegateAppearance>
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date
//{
//    NSString *key = [self.dateFormatter1 stringFromDate:date];
//    if ([_fillSelectionColors.allKeys containsObject:key]) {
//        return _fillSelectionColors[key];
//    }
//    return appearance.selectionColor;
//}
//
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
//{
//    NSString *key = [self.dateFormatter1 stringFromDate:date];
//    if ([_fillDefaultColors.allKeys containsObject:key]) {
//        return _fillDefaultColors[key];
//    }
//    return nil;
//}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date
{
    NSString *key = [self.dateFormatter2 stringFromDate:date];
    if ([self.schedules containsObject:key]) {
        return KColor_Bath;
    }
//    if ([_borderDefaultColors.allKeys containsObject:key]) {
//        return _borderDefaultColors[key];
//    }
    return appearance.borderDefaultColor;
}

//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderSelectionColorForDate:(NSDate *)date
//{
//    NSString *key = [self.dateFormatter1 stringFromDate:date];
//    if ([_borderSelectionColors.allKeys containsObject:key]) {
//        return _borderSelectionColors[key];
//    }
//    return appearance.borderSelectionColor;
//}

- (CGFloat)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderRadiusForDate:(nonnull NSDate *)date{
    return 0.4;
}
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
//     NSString *key = [self.dateFormatter2 stringFromDate:date];
    [self.subject_Click sendNext:[self.dateFormatter2 stringFromDate:date]];
}
@end

//
//  OLCommentCell.m
//  OLive
//
//  Created by xiao on 2019/4/14.
//  Copyright © 2019 oldManLive. All rights reserved.
//

#import "OLCommentCell.h"

@implementation OLCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString *)compareCurrentTime:(NSString *)str
{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    //八小时时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: timeDate];
    NSDate *mydate = [timeDate  dateByAddingTimeInterval: interval];
    NSDate *nowDate =[[NSDate date]  dateByAddingTimeInterval: interval];
    //    两个时间间隔
    NSTimeInterval timeInterval= [mydate timeIntervalSinceDate:nowDate];
    timeInterval = -timeInterval;
    NSLog(@"时间是%f",timeInterval);
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if((temp = timeInterval/(60*60)) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if((temp = timeInterval/(246060)) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else if((temp = timeInterval/(24606030)) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = timeInterval/(24606030*12);
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return  result;
}

@end

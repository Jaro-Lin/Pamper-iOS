//
//  SYCalendarView.h
//  XFAssist
//
//  Created by apple on 2020/3/31.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYCalendarView : UIView
@property(nonatomic, strong) RACSubject *subject_Click;
- (void)undateCalendarMonth:(NSString*)dataStr inSchedules:(NSArray*)schedules;

@end

NS_ASSUME_NONNULL_END

//
//  SYDaySchedule.h
//  SYBaseProject
//
//  Created by apple on 2020/6/17.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "baseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYDaySchedule : baseModel
/** 0-体重",1-喂养",2-身体状况",3-加餐" 4-洗澡 5-疫苗 6-驱虫*/
@property (nonatomic,assign) NSInteger item;
/**  */
@property (nonatomic,copy) NSString *itemStr;
/**  */
@property (nonatomic,copy) NSString *itemImage;
/**  */
@property (nonatomic,copy) NSString *itemValue;

/** 提醒事项 */
@property (nonatomic,copy) NSString *warm;
@property (nonatomic,assign) BOOL recorded;
/** 是否显示任务 */
@property (nonatomic,assign) BOOL showTask;
/** 当前任务状态--已记录还是未记录*/
@property (nonatomic,assign) BOOL taskIsFinish;
/** 疫苗类型  0 - 三联  1-狂犬疫苗  2-全部*/
@property (nonatomic,assign) NSInteger explingType;
/** 是否是当天的日程信息 */
@property(nonatomic, assign) BOOL isTodaySchedule;
/** 选择的日程信息 */
@property(nonatomic, copy) NSString *selectedDay;

@end

NS_ASSUME_NONNULL_END

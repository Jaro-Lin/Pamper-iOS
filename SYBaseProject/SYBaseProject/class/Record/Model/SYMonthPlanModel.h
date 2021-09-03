//
//  SYMonthPlanModel.h
//  SYBaseProject
//
//  Created by apple on 2020/6/9.
//  Copyright © 2020 YYB. All rights reserved.
//  当月日程

#import "baseModel.h"
@class SYMonthSchedule;
@class SYScheduleContentModel;

NS_ASSUME_NONNULL_BEGIN

@interface SYMonthPlanModel : baseModel

/** 智能预什么时候要执行某个动作 这里是 三联疫苗或者六联疫苗 */
@property (nonatomic,strong) NSArray *vaccin_0;
/** 狂犬疫苗-预测 */
@property (nonatomic,strong) NSArray *vaccin_1;
/** 洗澡-预测 */
@property (nonatomic,strong) NSArray *bath;
/** 驱虫 -预测*/
@property (nonatomic,strong) NSArray *expelling;
/** 当月已经记录的日程资料 */
@property (nonatomic,strong) SYMonthSchedule *scedule;

@end

@interface SYMonthSchedule : baseModel
/** 三联疫苗-记录 */
@property (nonatomic,strong) NSArray *vaccin_0;
/** 狂犬疫苗-记录 */
@property (nonatomic,strong) NSArray *vaccin_1;
/** 洗澡-记录 */
@property (nonatomic,strong) NSArray *bath;
/** 驱虫-记录*/
@property (nonatomic,strong) NSArray *expelling;

@end

//@interface SYScheduleContentModel : baseModel
///**  */
//@property (nonatomic,copy) NSString *day;
///**  */
//@property (nonatomic,copy) NSString *key;
//
//@end

NS_ASSUME_NONNULL_END

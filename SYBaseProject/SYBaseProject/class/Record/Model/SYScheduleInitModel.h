//
//  SYScheduleInitModel.h
//  SYBaseProject
//
//  Created by sy on 2020/6/15.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "baseModel.h"
@class SYVaccinModel;

NS_ASSUME_NONNULL_BEGIN

@interface SYScheduleInitModel : baseModel
/** 最近一次打疫苗的时间 */
@property (nonatomic,copy) NSString *vaccin_time;
/** 最近打疫苗什么疫苗 0为三联疫苗或六联疫苗 1-代表狂犬疫苗 */
@property (nonatomic,assign) NSInteger vaccin_type;
/** 三联疫苗或六联疫苗 */
/**  */
@property (nonatomic,copy) NSString *vaccin_time0;
/**  */
@property (nonatomic,copy) NSString *vaccin_count0;
//@property (nonatomic,copy) SYVaccinModel *vaccin0;
@property (nonatomic,assign) BOOL vaccin0Selected;

/** 狂犬疫苗 */
/**  */
@property (nonatomic,copy) NSString *vaccin_time1;
/**  */
@property (nonatomic,copy) NSString *vaccin_count1;
//@property (nonatomic,copy) SYVaccinModel *vaccin1;
@property (nonatomic,assign) BOOL vaccin1Selected;

/** 每隔几天驱虫 */
@property (nonatomic,copy) NSString *expelling;
/** 上次驱虫是什么时候 */
@property (nonatomic,copy) NSString *expelling_time;
@property (nonatomic,assign) BOOL expellingSelected;

/** 每隔几天洗澡 */
@property (nonatomic,copy) NSString *bath;
/** 上次洗澡是什么时候 */
@property (nonatomic,copy) NSString *bath_time;
@property (nonatomic,assign) BOOL bathSelected;

@end

@interface SYVaccinModel :baseModel
/**  */
@property (nonatomic,copy) NSString *vaccin_time;
/**  */
@property (nonatomic,copy) NSString *vaccin_count;
/**  */
@property (nonatomic,assign) NSInteger vaccin_type;


@end
NS_ASSUME_NONNULL_END

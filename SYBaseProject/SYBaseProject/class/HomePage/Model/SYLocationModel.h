//
//  SYLocationModel.h
//  SYBaseProject
//
//  Created by apple on 2020/4/21.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "baseModel.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYLocationModel : baseModel
/**  */
@property (nonatomic,copy) NSString *locality;
/**  */
@property (nonatomic,copy) NSString *subLocality;
/**  */
@property (nonatomic,copy) NSString *thoroughfare;
/**  */
@property (nonatomic,copy) NSString *name;
/**  */
@property (nonatomic,strong) CLLocation *currentLocation;
/**  */
@property (nonatomic,strong) CLPlacemark *placeMark;

@end

NS_ASSUME_NONNULL_END

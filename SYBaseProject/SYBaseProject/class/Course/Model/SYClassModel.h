//
//  SYClassModel.h
//  SYBaseProject
//
//  Created by sy on 2020/4/15.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "baseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYClassModel : baseModel
/**  */
@property (nonatomic,copy) NSString *ID;
/**  */
@property (nonatomic,copy) NSString *title;
/**  */
@property (nonatomic,copy) NSString *img;
/**  */
@property (nonatomic,copy) NSString *type_id;
/**  */
@property (nonatomic,copy) NSString *study_number;
/**  */
@property (nonatomic,copy) NSString *video;
/**  */
@property (nonatomic,assign) BOOL follow;

@end


@interface SYRecordCategoryModel : baseModel
/**  */
@property (nonatomic,copy) NSString *ID;
/**  */
@property (nonatomic,copy) NSString *type_title;
/**  */
@property (nonatomic,copy) NSString *icon;
@end

NS_ASSUME_NONNULL_END

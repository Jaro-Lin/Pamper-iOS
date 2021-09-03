//
//  SYClassListViewController.h
//  SYBaseProject
//
//  Created by sy on 2020/4/2.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYClassListViewController : BaseVC
/** 1-入门 2-基础 3-进阶 4-专业*/
 @property (nonatomic,assign) NSInteger type_id;

/** 课程类型---0-普通 1 热门课程推荐*/
@property (nonatomic,assign) NSInteger classType;
@end

NS_ASSUME_NONNULL_END

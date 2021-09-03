//
//  SYAddPeterViewController.h
//  SYBaseProject
//
//  Created by sy on 2020/3/28.
//  Copyright © 2020 YYB. All rights reserved.
//  添加宠物第一步

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAddPeterViewController : BaseVC

@property (weak, nonatomic) IBOutlet UIButton *dogBtn;
@property (weak, nonatomic) IBOutlet UIButton *catBtn;
@property (weak, nonatomic) IBOutlet UILabel *peterName;
@property (weak, nonatomic) IBOutlet UIButton *morePeterBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;

@end

NS_ASSUME_NONNULL_END

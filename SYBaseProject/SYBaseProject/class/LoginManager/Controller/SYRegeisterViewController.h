//
//  SYRegeisterViewController.h
//  SYBaseProject
//
//  Created by sy on 2020/3/23.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYRegeisterViewController : BaseVC
@property (weak, nonatomic) IBOutlet UIView *nickNameView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *surePasswordView;

@property (weak, nonatomic) IBOutlet UIView *sexView;
@property (weak, nonatomic) IBOutlet UIView *birtyView;
@property (weak, nonatomic) IBOutlet UIView *cityView;

@end

NS_ASSUME_NONNULL_END

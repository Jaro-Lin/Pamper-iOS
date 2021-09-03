//
//  SYPetExamineViewController.h
//  SYBaseProject
//
//  Created by sy on 2020/6/15.
//  Copyright © 2020 YYB. All rights reserved.
//  宠物调查

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYPetExamineViewController : BaseVC

@property (nonatomic,copy) NSString *mypets_id;
@property(nonatomic, strong) RACSubject *subject;

@end

NS_ASSUME_NONNULL_END

//
//  SYAddPeterInfoViewController.h
//  SYBaseProject
//
//  Created by sy on 2020/3/28.
//  Copyright © 2020 YYB. All rights reserved.
//  添加-修改 宠物信息

#import "BaseVC.h"
#import "SYPetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAddPeterInfoViewController : BaseVC

@property (weak, nonatomic) IBOutlet UIImageView *peterPhoto;
@property (weak, nonatomic) IBOutlet UILabel *petKindLB;

@property (weak, nonatomic) IBOutlet UITextField *peterNickName;
@property (weak, nonatomic) IBOutlet UITextField *peterSex;
@property (weak, nonatomic) IBOutlet UITextField *peterWeight;
@property (weak, nonatomic) IBOutlet UITextField *peterBirty;
@property (weak, nonatomic) IBOutlet UITextField *peterEnd;

@property (weak, nonatomic) IBOutlet UITextField *petHealthTF;

@property (weak, nonatomic) IBOutlet UIButton *lastStepBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureCommitBtn;

@property (nonatomic,assign) BOOL isEditeAction;//是否是编辑状态

@property(nonatomic, strong) SYPetBreedModel *petModel;//添加
@property(nonatomic, strong) SYPetModel *petInfoModel;//修改

@end

NS_ASSUME_NONNULL_END

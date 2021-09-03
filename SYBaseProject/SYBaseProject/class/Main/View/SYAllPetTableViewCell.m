//
//  SYAllPetTableViewCell.m
//  SYBaseProject
//
//  Created by sy on 2020/5/21.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYAllPetTableViewCell.h"
#import "NSObject+getCurrentViewController.h"
#import "SYAddPeterInfoViewController.h"

@implementation SYAllPetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //编辑宠物信息
    [[self.editeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        SYAddPeterInfoViewController *peterInfoVC = [[SYAddPeterInfoViewController alloc]init];
        peterInfoVC.petInfoModel = self.petModel;
        peterInfoVC.isEditeAction = YES;
        [[self getCurrentVC].navigationController pushViewController:peterInfoVC animated:YES];
    }];
}
- (void)setPetModel:(SYPetModel *)petModel{
    _petModel = petModel;
    
    self.petTypeImageView.image = ([_petModel.type_id integerValue] ==2 ?kImageWithName(@"donghead"):kImageWithName(@"cathead"));
    self.peterName.text = _petModel.nickname;
}


@end

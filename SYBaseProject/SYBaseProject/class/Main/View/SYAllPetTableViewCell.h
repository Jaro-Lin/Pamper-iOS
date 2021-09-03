//
//  SYAllPetTableViewCell.h
//  SYBaseProject
//
//  Created by sy on 2020/5/21.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYPetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAllPetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *petTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *peterName;
@property (weak, nonatomic) IBOutlet UIButton *editeBtn;
@property(nonatomic, strong) SYPetModel *petModel;
@end

NS_ASSUME_NONNULL_END

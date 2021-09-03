//
//  SYMineFollowTableViewCell.h
//  SYBaseProject
//
//  Created by sy on 2020/4/7.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYFansCollectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYMineFollowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userHead;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userInfo;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property(nonatomic, strong) SYFansCollectionModel *fansCollectionModel;
@end


typedef NS_ENUM(NSInteger,cardBGColor) {
    cardBGColor_blue,
    cardBGColor_orangeColor,
    cardBGColor_green,
    cardBGColor_red
};


@interface SYMineCardsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;
@property (weak, nonatomic) IBOutlet UILabel *userLB;
@property (weak, nonatomic) IBOutlet UILabel *userLimitCount;
@property (weak, nonatomic) IBOutlet UILabel *staticLB;
@property (weak, nonatomic) IBOutlet UILabel *amountLB;

 @property (nonatomic,assign) cardBGColor cardType;
@end

NS_ASSUME_NONNULL_END

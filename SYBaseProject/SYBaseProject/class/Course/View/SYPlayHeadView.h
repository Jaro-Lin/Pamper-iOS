//
//  SYPlayHeadView.h
//  SYBaseProject
//
//  Created by sy on 2020/4/2.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYPlayHeadView : UIView
@property(nonatomic, strong) SYClassModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *classImageView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *classTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *playCountLB;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@end

NS_ASSUME_NONNULL_END

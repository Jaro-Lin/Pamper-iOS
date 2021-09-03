//
//  LCHealthLivingPopView.h
//  sanShanClient
//
//  Created by apple on 2019/6/25.
//  Copyright © 2019 121. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCHealthLivingPopViewCell : UITableViewCell
@property(nonatomic, strong) UILabel *dataLB;
@end


@interface LCHealthLivingPopView : UIView <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy) void(^cancelActionBlock)();
@property (nonatomic,copy) void(^sureActionBlock)(baseModel *selectedModel,NSInteger indexRow);
@property (weak, nonatomic) IBOutlet UILabel *topTitleLB;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, strong) NSArray<baseModel*>*dataArray;
@property (nonatomic,assign) NSInteger indexRow;
@end

NS_ASSUME_NONNULL_END

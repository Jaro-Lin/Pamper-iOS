//
//  SYChoosePeterPopView.h
//  SYBaseProject
//
//  Created by sy on 2020/3/26.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYPetModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol SYChoosePeterDelegate <NSObject>
@optional
- (void)choosedPetInfo:(SYPetModel*)petModel;
- (void)cancelChoose;
@end

@interface SYChoosePeterPopView : UIView <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) NSInteger seledtedRow;
@property (weak, nonatomic) IBOutlet UIButton *backBnt;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UITableView *peterTbaleView;
@property(nonatomic, strong) NSArray *petsArr;
@property (nonatomic,weak) id<SYChoosePeterDelegate> delegate;

@end


@interface SYCommitPopView:UIView
@property(nonatomic, strong) UILabel *titleLB;
@property(nonatomic, strong) UILabel *messageLB;
@property(nonatomic, strong) UIButton *konowedBtn;

@end

@interface SYSignedOnPopView : UIView

@property(nonatomic, strong) UILabel *titleLB;
@property(nonatomic, strong) UILabel *ondMessageLB;
@property(nonatomic, strong) UIButton *secondMessageBtn;
@property(nonatomic, strong) UILabel *thirdMessageLB;
@property(nonatomic, strong) UIButton *bottomBtn;

@end
NS_ASSUME_NONNULL_END

//
//  SYPetExamineSectionView.h
//  SYBaseProject
//
//  Created by sy on 2020/6/15.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYScheduleInitModel.h"

typedef NS_ENUM(NSInteger,sectionHeadType) {
    sectionHeadType_nomal,
    sectionHeadType_setting,
};
@protocol SYPetExamineSectionViewDelegate <NSObject>
- (void)sectionHeadViewSelected:(BOOL)selected sectionRow:(NSInteger)section;
- (void)bathExpellingChoosed:(NSString*_Nonnull)dutionStr sectionRow:(NSInteger)section;
@end

NS_ASSUME_NONNULL_BEGIN

@interface SYPetExamineSectionView : UIView
 @property (nonatomic,weak) id<SYPetExamineSectionViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *dutionLB;
@property (weak, nonatomic) IBOutlet UIButton *dutionBtn;

@property (nonatomic,assign) NSInteger section;
@property (nonatomic,assign) sectionHeadType headType;

@end

@protocol SYExamineTableViewCellDelegate <NSObject>

- (void)examineBathTimeDution:(NSIndexPath*)indexPath dutionStr:(NSString*)dustionStr;
@end

@interface SYExamineTableViewCell : UITableViewCell
// @property (nonatomic,weak) id<SYExamineTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIButton *timeChooseBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *bottomTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *countLB;
@property (weak, nonatomic) IBOutlet UIButton *countChooseBtn;
@property(nonatomic, strong) SYScheduleInitModel *scheduleModel;
@property(nonatomic, strong) NSIndexPath *indexPath;
@end

NS_ASSUME_NONNULL_END

//
//  SYHomeManagerHeadView.h
//  SYBaseProject
//
//  Created by sy on 2020/3/25.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,SYHeadViewType) {
    headView_NoPeter,
    headView_HavePeter
};
NS_ASSUME_NONNULL_BEGIN

@interface SYHomeManagerHeadView : UIView

@property (nonatomic,assign) SYHeadViewType headViewType;
@property (weak, nonatomic) IBOutlet UIImageView *peterPhotoView;

@property (weak, nonatomic) IBOutlet UILabel *peterName;
@property (weak, nonatomic) IBOutlet UILabel *peterYeaLOld;
@property (weak, nonatomic) IBOutlet UILabel *peterOldMan;
@property (weak, nonatomic) IBOutlet UILabel *needDoAction;
@property (weak, nonatomic) IBOutlet UIButton *jinggaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherPeterBtn;
@property (weak, nonatomic) IBOutlet UIButton *addPeterBtn;
@property (weak, nonatomic) IBOutlet UIButton *addOtherPeterBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherPeter;

@end

@interface SYHomeRecordHeadView :UIView
@property (weak, nonatomic) IBOutlet UILabel *oneHotTopic;
@property (weak, nonatomic) IBOutlet UILabel *twoHotTopic;
@property (weak, nonatomic) IBOutlet UILabel *threeHotTopic;
@property (weak, nonatomic) IBOutlet UILabel *oneLB;
@property (weak, nonatomic) IBOutlet UILabel *twoLB;
@property (weak, nonatomic) IBOutlet UILabel *threeLB;
@property (weak, nonatomic) IBOutlet UILabel *hotCountOneLB;
@property (weak, nonatomic) IBOutlet UILabel *hotCountTwoLB;
@property (weak, nonatomic) IBOutlet UILabel *hotCountThreeLB;
@property (weak, nonatomic) IBOutlet UIButton *moreHotBtn;
@property(nonatomic, strong) NSArray *topicArr;
@end

@interface SYHomeCityHeadView :UIView
@property (weak, nonatomic) IBOutlet UILabel *locationLB;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@end

@interface SYHomeSearchHeadView :UIView
@property (weak, nonatomic) IBOutlet UIView *contentSubView;
@property (weak, nonatomic) IBOutlet UITextField *inputContent;

@end

NS_ASSUME_NONNULL_END

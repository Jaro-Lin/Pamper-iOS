//
//  SYUserDetailHeadView.h
//  SYBaseProject
//
//  Created by sy on 2020/3/29.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYUserDetailHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *userHeadView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLB;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLB;
@property (weak, nonatomic) IBOutlet UILabel *flowerLB;
@property (weak, nonatomic) IBOutlet UILabel *fansLB;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;

@end


@interface SYCommontView : UIView
@property (weak, nonatomic) IBOutlet UITextView *commontTV;

@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commontViewHeight;

@end

@interface SYSecondCommontHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *userHead;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@end

NS_ASSUME_NONNULL_END

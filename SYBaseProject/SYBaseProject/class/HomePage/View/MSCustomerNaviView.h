//
//  MSCustomerNaviView.h
//  magicShop
//
//  Created by apple on 2019/11/1.
//  Copyright © 2019 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**自定义导航栏 热门-最新*/
@interface MSCustomerNaviView : UIView
@property (weak, nonatomic) IBOutlet UIView *hotCareView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *hotBtn;
@property (weak, nonatomic) IBOutlet UIButton *careBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet UIButton *writeBtn;

@end


/**自定义导航栏 中间显示标题*/
@interface MSTopicLocationNaviView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *writeBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@end

/**顶部搜索栏*/
@interface MSTopSearchView : UIView
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@end
NS_ASSUME_NONNULL_END

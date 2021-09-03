//
//  MSShareView.h
//  magicShop
//
//  Created by sy on 2019/11/2.
//  Copyright © 2019 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSShareView : UIView

@property (weak, nonatomic) IBOutlet UIView *shareBgView;
@property (weak, nonatomic) IBOutlet UIButton *weChatBtn;
@property (weak, nonatomic) IBOutlet UIButton *pengyouQuanBtn;

@property (weak, nonatomic) IBOutlet UIButton *QQChatBtn;
@property (weak, nonatomic) IBOutlet UIButton *QQZoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *linkBtn;


@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBottomMargin;

/**type    动态：post 商品：shop  */
- (void)showPopView:(NSString*)showType;
- (void)dismissPopView;

@end

NS_ASSUME_NONNULL_END

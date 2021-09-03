//
//  SYOrderListTableViewCell.h
//  SYBaseProject
//
//  Created by sy on 2020/4/8.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYOrderStateModel.h"

typedef NS_ENUM(NSInteger,goodCountInOrder) {
    goodCountInOrder_single,//单个商品
    goodCountInOrder_more//多个商品
};

@protocol SYOrderListTableViewCellDelegate <NSObject>

- (void)payAction:(SYOrderStateModel*_Nonnull)order;//去支付
- (void)cancalOrderAction:(SYOrderStateModel*_Nonnull)order;//取消订单
- (void)remindSendGoodAction:(SYOrderStateModel*_Nonnull)order;//提醒发货
- (void)approveServiceAction:(SYOrderStateModel*_Nonnull)order;//申请售后
- (void)receiveGoodAction:(SYOrderStateModel*_Nonnull)order;//确认收货
- (void)checkLogisticalAction:(SYOrderStateModel*_Nonnull)order;//复制物流单号
- (void)evaluateAction:(SYOrderStateModel*_Nonnull)order;//立即评价

@end

NS_ASSUME_NONNULL_BEGIN

@interface SYOrderListTableViewCell : UITableViewCell
 @property (nonatomic,weak) id<SYOrderListTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodTitle;
@property (weak, nonatomic) IBOutlet UILabel *goodRule;
@property (weak, nonatomic) IBOutlet UILabel *singlePrice;
@property (weak, nonatomic) IBOutlet UILabel *totalCount;
@property (weak, nonatomic) IBOutlet UILabel *stateLB;
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (nonatomic,assign) OrderStatue orderType;//订单当前状态
@property (nonatomic,assign) goodCountInOrder oneOrMoreGood;//显示单个或多个商品
@property(nonatomic, strong) SYOrderStateModel *orderModel;//一个订单
@property(nonatomic, strong) SYShopListModle *listModel;//订单里面的商品数据
@end

@interface SYOrderPayPopView :UIView
@property (nonatomic,copy) void(^orderPayType)(NSInteger type);
@property (weak, nonatomic) IBOutlet UIButton *selectedAliPay;
@property (weak, nonatomic) IBOutlet UIButton *selectedWeChatPay;
@property (weak, nonatomic) IBOutlet UIButton *surePay;

@end


NS_ASSUME_NONNULL_END

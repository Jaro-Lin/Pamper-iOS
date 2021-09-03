//
//  SYOrderListTableViewCell.m
//  SYBaseProject
//
//  Created by sy on 2020/4/8.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYOrderListTableViewCell.h"

@implementation SYOrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    KViewRadius(self.oneBtn, 13);
    KViewRadius(self.twoBtn, 13);
    KViewRadius(self.threeBtn, 13);
}
- (void)unLoadSubViews{
    
    self.twoBtn.hidden = ((_orderType == orderStatue_evaluatIng ||_orderType == orderStatue_done||_orderType == orderStatue_cancelIng ||_orderType == orderStatue_sendGoodIng ||_orderType == orderStatue_salelateIng)? YES:NO);
    self.threeBtn.hidden = (_orderType == orderStatue_receiveGoodIng ? NO:YES);
    [self.twoBtn setBackgroundColor:(_orderType == orderStatue_payIng ? KUIColorFromRGB(0xff3030):RGBOF(0x23A0F0))];
    
    NSString *oneBtnTitle = @"";
    NSString *twoBtnTitle = @"";
    NSString *threeBtnTitle = @"";
    NSString *statueStr = @"";
    switch (_orderType) {
        case orderStatue_done:
        {
            oneBtnTitle = @"已评价";
            statueStr = @"已完成";
        }
            break;
        case orderStatue_payIng:
        {
            oneBtnTitle = @"去付款";
            twoBtnTitle = @"取消订单";
            statueStr = @"待付款";
        }
            break;
        case orderStatue_sendGoodIng:
        {
            //            oneBtnTitle = @"提醒发货";
            //            twoBtnTitle = @"申请售后";
            oneBtnTitle = @"申请售后";
            statueStr = @"未发货";
        }
            break;
        case orderStatue_receiveGoodIng:
        {
            oneBtnTitle = @"确认收货";
            twoBtnTitle = @"复制物流单号";
            threeBtnTitle = @"申请售后";
            statueStr = @"待收货";
        }
            break;
        case orderStatue_evaluatIng:
        {
            oneBtnTitle = @"立即评价";
            statueStr = @"待评价";
        }
            break;
        case orderStatue_salelateIng:
        {
            oneBtnTitle = @"售后中";
            statueStr = @"售后中";
        }
            break;
        case orderStatue_cancelIng:
        {
            oneBtnTitle = @"已取消";
            statueStr = @"已取消";
        }
            break;
        default:
            break;
    }
    
    [self.oneBtn setTitle:oneBtnTitle forState:UIControlStateNormal];
    [self.twoBtn setTitle:twoBtnTitle forState:UIControlStateNormal];
    [self.threeBtn setTitle:threeBtnTitle forState:UIControlStateNormal];
    self.stateLB.text = statueStr;
    
    
}

- (IBAction)oneBtnClick:(UIButton *)sender {
    switch (_orderType) {
        case orderStatue_payIng:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(payAction:)]) {
                [self.delegate payAction:self.orderModel];
            }
        }
            break;
        case orderStatue_sendGoodIng:
        {
            //            if (self.delegate && [self.delegate respondsToSelector:@selector(remindSendGoodAction:)]) {
            //                [self.delegate remindSendGoodAction:self.orderModel];
            //            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(approveServiceAction:)]) {
                [self.delegate approveServiceAction:self.orderModel];
            }
        }
            break;
        case orderStatue_receiveGoodIng:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(receiveGoodAction:)]) {
                [self.delegate receiveGoodAction:self.orderModel];
            }
        }
            break;
        case orderStatue_evaluatIng:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(evaluateAction:)]) {
                [self.delegate evaluateAction:self.orderModel];
            }
        }
            break;
        default:
            break;
    }
}
- (IBAction)twoBtnClick:(UIButton *)sender {
    
    switch (_orderType) {
        case orderStatue_payIng:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(cancalOrderAction:)]) {
                [self.delegate cancalOrderAction:self.orderModel];
            }
        }
            break;
        case orderStatue_sendGoodIng:
        {
            //            if (self.delegate && [self.delegate respondsToSelector:@selector(approveServiceAction:)]) {
            //                [self.delegate approveServiceAction:self.orderModel];
            //            }
        }
            break;
        case orderStatue_receiveGoodIng:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(checkLogisticalAction:)]) {
                [self.delegate checkLogisticalAction:self.orderModel];
            }
        }
            break;
        case orderStatue_evaluatIng:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(evaluateAction:)]) {
                [self.delegate evaluateAction:self.orderModel];
            }
        }
            break;
        default:
            break;
    }
}
- (IBAction)threeBtnClick:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(approveServiceAction:)]) {
        [self.delegate approveServiceAction:self.orderModel];
    }
}
- (void)setOneOrMoreGood:(goodCountInOrder)oneOrMoreGood{
    _oneOrMoreGood = oneOrMoreGood;
    
    self.stateLB.hidden = (_oneOrMoreGood == goodCountInOrder_single?NO:YES);
    self.totalCount.hidden = self.oneBtn.hidden = (_oneOrMoreGood == goodCountInOrder_single?YES:NO);
    if (!self.oneBtn.hidden) {
        self.oneBtn.hidden = (_oneOrMoreGood == goodCountInOrder_single?YES:NO);
    }
    if (!self.twoBtn.hidden) {
        self.twoBtn.hidden = (_oneOrMoreGood == goodCountInOrder_single?YES:NO);
    }
    if (!self.threeBtn.hidden) {
        self.threeBtn.hidden = (_oneOrMoreGood == goodCountInOrder_single?YES:NO);
    }
}
- (void)setOrderModel:(SYOrderStateModel *)orderModel{
    _orderModel = orderModel;
    
    NSInteger countNum = 0;
    for (int i =0 ; i <_orderModel.shop_list.count; i ++) {
        SYShopListModle *listModel = _orderModel.shop_list[i];
        countNum += [listModel.number integerValue];
    }
    
    self.totalCount.text = [NSString stringWithFormat:@"共 %ld 件商品，合计 %@ 元",countNum,_orderModel.total_price];
    
    /** 订单状态： 0完成 1待支付 2待发货 3待收货 4待评价 5售后 6 取消订单*/
    if ([_orderModel.state integerValue] ==0) {
        _orderType = orderStatue_done;
    }else if ([_orderModel.state integerValue] ==1){
        _orderType = orderStatue_payIng;
    }else if ([_orderModel.state integerValue] ==2){
        _orderType = orderStatue_sendGoodIng;
    }else if ([_orderModel.state integerValue] ==3){
        _orderType = orderStatue_receiveGoodIng;
    }else if ([_orderModel.state integerValue] ==4){
        _orderType = orderStatue_evaluatIng;
    }else if ([_orderModel.state integerValue] ==5){
        _orderType = orderStatue_salelateIng;
    }else if ([_orderModel.state integerValue] ==6){
        _orderType = orderStatue_cancelIng;
    }
    
    [self unLoadSubViews];
    
}
- (void)setListModel:(SYShopListModle *)listModel{
    _listModel = listModel;
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_orderModel.server,_listModel.shop.icon]] placeholderImage:kPlaceHoldImage];
    self.goodTitle.text = _listModel.shop.title;
    self.goodRule.text = [NSString stringWithFormat:@"规格：%@",_listModel.spe.spe];
    self.singlePrice.text = [NSString stringWithFormat:@"￥ %@",_listModel.price];
}

@end


@implementation SYOrderPayPopView
- (void)awakeFromNib{
    [super awakeFromNib];
    KViewRadius(self.surePay, 15);
}
- (IBAction)AliPayAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.selectedWeChatPay.selected = !sender.selected;
}
- (IBAction)weChatPayAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.selectedAliPay.selected = !sender.selected;
}

- (IBAction)surePayAction:(id)sender {
    !self.orderPayType ?:self.orderPayType(self.selectedAliPay.selected ?1:2);
}

@end

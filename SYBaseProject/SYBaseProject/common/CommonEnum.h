//
//  CommonEnum.h
//  SYBaseProject
//
//  Created by apple on 2020/6/2.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 订单状态： 0完成 1待支付 2待发货 3待收货 4待评价 5售后 6 取消订单*/
typedef NS_ENUM(NSInteger,OrderStatue) {
    orderStatue_done,//完成
    orderStatue_payIng,//待付款
    orderStatue_sendGoodIng,//待发货
    orderStatue_receiveGoodIng,//待收货
    orderStatue_evaluatIng,//待评价
    orderStatue_salelateIng,//售后
    orderStatue_cancelIng//取消订单
};


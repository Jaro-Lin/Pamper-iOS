//
//  SYOrderStateModel.m
//  SYBaseProject
//
//  Created by apple on 2020/5/18.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYOrderStateModel.h"

@implementation SYOrderStateModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"shop_list":[SYShopListModle class]
    };
}
- (NSString *)state{
 
    //    /**
    //     /** 是否支付：0未支付 1已支付 */
    //     @property (nonatomic,assign) BOOL is_pay;
    //     /** 是否发货：0未发货 1已发货 */
    //     @property (nonatomic,assign) BOOL is_send;
    //     /** 是否收件：0未收件 1已收件 */
    //     @property (nonatomic,assign) BOOL is_put;
    //     /** 是否评论：0未评论 1已评论 */
    //     @property (nonatomic,assign) BOOL is_comment;
    //     /** 是否取消订单：0未取消订单 1已取消订单 */
    //     @property (nonatomic,assign) BOOL is_cancel;
    //     /** 是否发起售后服务：0未发起 1发起 */
    //     @property (nonatomic,assign) BOOL is_salelate;
    //     */
    
       /** 订单状态： 0完成 1待支付 2待发货 3待收货 4待评价 5售后 6 取消订单*/
    if (self.is_cancel) {//取消订单
        return @"6";
    }else{
        if (self.is_salelate) {//发起售后
            return @"5";
        }else{
            if (self.is_pay) {
                if (self.is_send) {
                    if (self.is_put) {
                        if (self.is_comment) {//完成
                            return @"0";
                        }else{//待评价
                            return @"4";
                        }
                    }else{//待收货
                        return @"3";
                    }
                }else{//代发货
                    return @"2";
                }
                
            }else{//待支付
                return @"1";
            }
            
        }
    }
    return @"0";
}
@end

@implementation SYShopListModle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imagesUrls = [NSMutableArray array];
        self.selectedAssets = [NSMutableArray array];
    }
    return self;
}
@end

@implementation SYShopListShopModle

@end

@implementation SYShopListSpeModle

@end


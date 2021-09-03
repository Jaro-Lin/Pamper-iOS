//
//  SYOrderStateModel.h
//  SYBaseProject
//
//  Created by apple on 2020/5/18.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "baseModel.h"
@class SYShopListModle;
@class SYShopListShopModle;
@class SYShopListSpeModle;

NS_ASSUME_NONNULL_BEGIN

@interface SYOrderStateModel : baseModel
/** 订单编号 */
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *order_id;
@property (nonatomic,copy) NSString *server;
@property (nonatomic,copy) NSString *logistics_id;
@property (nonatomic,copy) NSString *put_type;//快递公司

/** 订单列表 */
@property (nonatomic,copy) NSArray *shop_list;
/** 商品总数 */
@property (nonatomic,copy) NSString *shop_total;
/** 合计价格（包括邮费） */
@property (nonatomic,copy) NSString *total_price;

/** 是否支付：0未支付 1已支付 */
@property (nonatomic,assign) BOOL is_pay;
/** 是否发货：0未发货 1已发货 */
@property (nonatomic,assign) BOOL is_send;
/** 是否收件：0未收件 1已收件 */
@property (nonatomic,assign) BOOL is_put;
/** 是否评论：0未评论 1已评论 */
@property (nonatomic,assign) BOOL is_comment;
/** 是否取消订单：0未取消订单 1已取消订单 */
@property (nonatomic,assign) BOOL is_cancel;
/** 是否发起售后服务：0未发起 1发起 */
@property (nonatomic,assign) BOOL is_salelate;
/** 订单状态： 0完成 1待支付 2待发货 3待收货 4待评价 5售后 6 取消订单*/
@property (nonatomic,copy) NSString *state;

@end

@interface SYShopListModle : baseModel
/**  */
@property (nonatomic,copy) NSString *ID;
/**  */
@property (nonatomic,copy) NSString *number;
/**  */
@property (nonatomic,copy) NSString *price;
@property(nonatomic, strong) SYShopListShopModle *shop;
/**  */
@property (nonatomic,strong) SYShopListSpeModle *spe;
/**  */
@property (nonatomic,copy) NSString *shop_id;


/** 以下数据在填写商品评价后有数据 */
/** 评价商品图片 */
@property(nonatomic, strong) NSArray<UIImage*> *selectedImags;
/** 评价 0-好评 1-中评 2 -差评 */
@property (nonatomic,assign) NSInteger evaluatType;
/** 评价内容 */
@property (nonatomic,copy) NSString *evaluatContent;
/** 暂存选中的图片数据-便于记录 */
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property(nonatomic, strong) NSMutableArray *imagesUrls;

@end

@interface SYShopListShopModle : baseModel
/**  */
@property (nonatomic,copy) NSString *icon;
/**  */
@property (nonatomic,copy) NSString *ID;
/**  */
@property (nonatomic,copy) NSString *pets_id;
/**  */
@property (nonatomic,copy) NSString *title;
/**  */
@property (nonatomic,copy) NSString *type_id;

@end

@interface SYShopListSpeModle : baseModel
/**  */
@property (nonatomic,copy) NSString *ID;
/**  */
@property (nonatomic,copy) NSString *price;
/**  */
@property (nonatomic,copy) NSString *spe;

@end

NS_ASSUME_NONNULL_END

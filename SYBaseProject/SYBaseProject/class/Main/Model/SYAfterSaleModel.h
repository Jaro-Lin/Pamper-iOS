//
//  SYAfterSaleModel.h
//  SYBaseProject
//
//  Created by apple on 2020/5/29.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "baseModel.h"
@class SYAfterSaleShopModel;

NS_ASSUME_NONNULL_BEGIN

@interface SYAfterSaleModel : baseModel
/**  */
@property (nonatomic,strong) NSArray *shop;
/** 售后类型: 退货并退款 */
@property (nonatomic,copy) NSString *type;
/**  */
@property (nonatomic,copy) NSString *price;
/** 货物状态 */
@property (nonatomic,copy) NSString *refund_status;
/**  */
@property (nonatomic,copy) NSString *server;
/**  */
@property (nonatomic,copy) NSString *order_id;

/** 申请售后字段  */
/** 货物状态：1已收货 0未收   售后状态  0-未完成 1-完成 */
@property (nonatomic,copy) NSString *state;
/** 退货原因 */
@property (nonatomic,copy) NSString *reason;
/** 支持多图 - 以英文逗号 */
@property (nonatomic,copy) NSString *img;
@property(nonatomic, strong) NSMutableArray *img_urls;//上传图片后的Url

/** 订单备注 */
@property (nonatomic,copy) NSString *mark;
/** 暂存选中的图片数据-便于记录 */
@property (nonatomic, strong) NSMutableArray *selectedAssets;
/** 选中的图片 */
@property(nonatomic, strong) NSArray<UIImage*> *selectedImags;

@end

@interface SYAfterSaleShopModel : baseModel
/** 规格 */
@property (nonatomic,copy) NSString *title;
/** 数量 */
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *spe;
@property (nonatomic,copy) NSString *number;

@end


@interface SYAfterSaleDetailModel : baseModel //售后详情模型
/**  */
@property (nonatomic,copy) NSString *order_number;
/**  */
@property (nonatomic,copy) NSString *order_price;
/**  */
@property (nonatomic,copy) NSString *server;
/**  */
@property (nonatomic,strong) NSArray *type;
/**  */
@property (nonatomic,strong) NSArray *shop_info;

@end


NS_ASSUME_NONNULL_END

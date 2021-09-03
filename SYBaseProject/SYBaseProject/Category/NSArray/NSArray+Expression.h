//
//  NSArray+Expression.h
//  SYBaseProject
//
//  Created by sy on 2020/7/5.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Expression)
/**本地筛选---未优化-弃用*/
-(NSArray*)filterWithString:(NSString*)text;
/**谓词筛选数据--写法根据谓词需求填写
 NOT 不是
 SELF 代表字符串本身
 IN 范围运算符
 那么NOT (SELF IN %@) 意思就是：不是这里所指定的字符串的值
 BEGINSWITH 以···开始、ENDSWITH 以···结尾、CONTAINS
 */
// 模型字段（varieties_name）包含关键字-keyWord的数据
- (NSArray*)filterPredicateContainsWithKeyWord:(NSString*)keyWord;
@end

NS_ASSUME_NONNULL_END

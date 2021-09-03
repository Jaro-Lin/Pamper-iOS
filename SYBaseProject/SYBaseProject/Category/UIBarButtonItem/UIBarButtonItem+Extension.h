//
//  UIBarButtonItem+Extension.h
//  CCMicroblog_2
//
//  Created by April on 7/7/15.
//  Copyright (c) 2015 gunzi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,itemType) {
    
    itemType_titles,
    itemType_images
};

@interface UIBarButtonItem (Extension)
/**
 *  创建一个带图片的item
 *
 *  @param target    点击item后调用哪个对象的方法
 *  @param action    点击item后调用target的哪个方法
 *  @param image     图片
 *  @param highImage 高亮的图片
 *h
 *  @return 创建完的item
 */

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage horizontalAlignment:(UIControlContentHorizontalAlignment)alignment;


/**
 创建一个带标题的item

 @param title 标题
 @param font 字体大小
 @param color 字体颜色
 @param target 点击item后调用哪个对象的方法
 @param action 点击item后调用target的哪个方法
 @return 创建完的item
 */
+(UIBarButtonItem *)ItemWithTitle:(NSString *)title Font:(UIFont *)font titlesColor:(UIColor *)color target:(id)target action:(SEL)action;

/**
 创建多个的items（纯标题或纯图标）
 
 @param titleArray 标题数组
 @param font 字体大小
 @param color 字体颜色
 @param target 点击item后调用哪个对象的方法
 @param action 点击item后调用target的哪个方法
 @return 创建完的item
 */
+(NSArray<UIBarButtonItem*>*)ItemsWithTitles:(NSArray*)titleArray Font:(UIFont *)font titlesColor:(UIColor *)color target:(id)target action:(SEL)action itemsType:(itemType)type;
@end

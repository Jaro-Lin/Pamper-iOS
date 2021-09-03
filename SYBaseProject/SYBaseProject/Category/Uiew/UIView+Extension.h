//
//  UIView+Extension.h
//  CCMicroblog_2
//
//  Created by April on 7/6/15.
//  Copyright (c) 2015 gunzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;
@property (nonatomic,assign) CGFloat bottomY;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGPoint origin;
@property (nonatomic,assign) CGSize size;

/**
 *创建label的公用方法一
 *title:label的文本
 *textColor：label的字体颜色
 *textFont：label的字体大小
 **/

+ (UILabel*)creatLabelWithTitle:(NSString*)title textColor:(UIColor*)textColor textFont:(UIFont*)textFont;


/**
 创建label的公共方法二
 @param title 文本
 @param textColorParm 字体颜色参数
 @param textFontCGFloat 字体大小参数
 @return label
 */
+ (UILabel *)creatLableWithTitle:(NSString *)title textColorParm:(UIColor *)textColorParm textFontCGFloat:(CGFloat )textFontCGFloat;


/**
 创建lable的共用方法三
 主要用于cell里的label创建
 @param textColorParm 字体的颜色
 @param textFontCGFloat 字体的大小
 @param superUIView  父类的视图
 @return label
 */
+ (UILabel *)createLabeltextColorParm:(UIColor *)textColorParm textFontCGFloat:(CGFloat )textFontCGFloat superUIView:(UIView *)superUIView;

/**
 *创建button的公用方法
 *title:button的文本
  *textFont:button的字体大小
 *normalImageName：正常状态下的图片名称
*selectedImageName：选中状态下的图片名称
 *titleColor：button的字体颜色
 *backGroundColor：button的背景色
 **/
+ (UIButton*)creatBtnWithTitle:(NSString*)title textFont:(UIFont*)textFont normalImage:(NSString*)normalImageName selectedImage:(NSString*)selectedImageName titleColor:(UIColor*)titleColor backGroundColor:(UIColor*)backGroundColor;

/**
 创建button的公共方法

 @param title button名称
 @param textFont button的字体大小
 @param ImageName button的图片名称
 @param titleColor button的字体颜色
 @param backGroundColor button的背景颜色
 @param layerRadius button的切圆的大小
 @return button
 */
+ (UIButton*)creatBtnWithTitle:(NSString*)title textFont:(CGFloat)textFont Image:(NSString*)ImageName titleColor:(UIColor*)titleColor backGroundColor:(UIColor*)backGroundColor layerRadius:(CGFloat)layerRadius;


/**
 创建imageviwe的公共方法一
 主要用于cell里面的imageview创建
 @param ImageName 图片的名称
 @param superUIView 父类的view
 @return imageView
 */
+(UIImageView *)createImageViewImageName:(NSString *)ImageName superUIView:(UIView *)superUIView;


/**
 创建imageView的公共方法二

 @param Frame 位置与坐标
 @param ImageName 图片的名称
 @param superUIView 父类的view
 @return imageView
 */
+(UIImageView *)createImageViewFrame:(CGRect)Frame ImageName:(NSString *)ImageName superUIView:(UIView *)superUIView;

/**
 创建view的公共方法一

 @param backgroundColor 背景颜色
 @param superUIView 父类的view
 @return view
 */
+(UIView *)createViewBackgroundColor:(UIColor *)backgroundColor superUIView:(UIView *)superUIView;



/**
 创建TableView的公共方法
 @param Frame 位置坐标
 @param backgroundColor 背景颜色
 @param rowHeight cell高度
 @param superUIView 父类的view
 @return tableView
 */
+(UITableView *)createTableViewFrame:(CGRect)Frame backGroundColor:(UIColor *)backgroundColor rowHeight:(CGFloat)rowHeight superUIView:(UIView *)superUIView;
@end

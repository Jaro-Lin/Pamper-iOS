//
//  UIView+Extension.m
//  CCMicroblog_2
//
//  Created by April on 7/6/15.
//  Copyright (c) 2015 gunzi. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

-(CGFloat)x
{
    return self.frame.origin.x;
}

-(void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

-(void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
// Center

-(CGFloat)centerX
{
    return self.center.x;
}

-(void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

-(void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (void)setBottomY:(CGFloat)bottomY
{
    CGRect frame = self.frame;
    frame.origin.y = bottomY - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)bottomY
{
    return self.frame.origin.y + self.frame.size.height;
}

// height
-(CGFloat)height
{
    return self.frame.size.height;
}

-(void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
-(CGFloat)width
{
    return self.frame.size.width;
}

-(void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

-(void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

-(CGPoint)origin
{
    return self.frame.origin;
}
-(void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

#pragma mark - 创建label的公用方法
+ (UILabel*)creatLabelWithTitle:(NSString*)title textColor:(UIColor*)textColor textFont:(UIFont*)textFont
{
    UILabel *label = [UILabel new];
    if (title) {
        label.text =title ;
    }
    if (textColor) {
        label.textColor = textColor;
    }
    if (textFont) {
        label.font = textFont;
    }
    
    return label;
}

+ (UILabel *)creatLableWithTitle:(NSString *)title textColorParm:(UIColor *)textColorParm textFontCGFloat:(CGFloat)textFontCGFloat{
    
    UILabel *label = [UILabel new];
    if (title) {
        label.text =title ;
    }
    if (textColorParm) {
        label.textColor = textColorParm;
    }
    if (textFontCGFloat) {
        label.font = KFont_M(textFontCGFloat);
    }
    
    return label;
}


+ (UILabel *)createLabeltextColorParm:(UIColor *)textColorParm textFontCGFloat:(CGFloat )textFontCGFloat superUIView:(UIView *)superUIView{
    UILabel *label = [UILabel new];
    if (textColorParm) {
        label.textColor = textColorParm;
    }
    if (textFontCGFloat) {
        label.font = KFont_M(textFontCGFloat);
    }
    if (superUIView) {
        [superUIView addSubview:label];
    }
    return label;
}

#pragma mark - 创建button的公用方法
+ (UIButton*)creatBtnWithTitle:(NSString*)title textFont:(UIFont*)textFont normalImage:(NSString*)normalImageName selectedImage:(NSString*)selectedImageName titleColor:(UIColor*)titleColor backGroundColor:(UIColor*)backGroundColor
{
    
    UIButton *button = [UIButton new];
    if (title) {
        [button setTitle:NSLocalizedString(title, nil)  forState:UIControlStateNormal];
    }
    if (textFont) {
        button.titleLabel.font = textFont;
    }
    
    if (normalImageName) {
        [button setImage:kModuleBundleUIImageNamed(normalImageName) forState:UIControlStateNormal];
    }
    if (selectedImageName) {
        [button setImage:kModuleBundleUIImageNamed(selectedImageName) forState:UIControlStateSelected];
    }
    
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
    if (backGroundColor) {
        [button setBackgroundColor:backGroundColor];
    }
    
    
    return button;
    
}

+ (UIButton*)creatBtnWithTitle:(NSString*)title textFont:(CGFloat)textFont Image:(NSString*)ImageName titleColor:(UIColor*)titleColor backGroundColor:(UIColor*)backGroundColor layerRadius:(CGFloat)layerRadius{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [button setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
    }
    if (textFont) {
         button.titleLabel.font = KFont_M(textFont);
    }
    if (ImageName) {
        [button setImage:kModuleBundleUIImageNamed(ImageName) forState:UIControlStateNormal];
    }
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (backGroundColor) {
        [button setBackgroundColor:backGroundColor];
    }
    if (layerRadius) {
        button.layer.masksToBounds =YES;
        button.layer.cornerRadius = layerRadius;
    }
    return button;
}

+(UIImageView *)createImageViewImageName:(NSString *)ImageName superUIView:(UIView *)superUIView{
    UIImageView *imageView = [[UIImageView alloc] init];
    if (ImageName) {
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image =kModuleBundleUIImageNamed(ImageName);
    }
    if (superUIView) {
        [superUIView addSubview:imageView];
    }
    return imageView;
}

+(UIImageView *)createImageViewFrame:(CGRect)Frame ImageName:(NSString *)ImageName superUIView:(UIView *)superUIView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:Frame];
    if (ImageName) {
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image =kModuleBundleUIImageNamed(ImageName);
    }
    if (superUIView) {
        [superUIView addSubview:imageView];
    }
    return imageView;
}

+(UIView *)createViewBackgroundColor:(UIColor *)backgroundColor superUIView:(UIView *)superUIView{
    UIView *view = [UIView new];
    if (backgroundColor) {
        view.backgroundColor = backgroundColor;
    }
    if (superUIView) {
        [superUIView addSubview:view];
    }
    return view;
}

+(UITableView *)createTableViewFrame:(CGRect)Frame backGroundColor:(UIColor *)backgroundColor rowHeight:(CGFloat)rowHeight superUIView:(UIView *)superUIView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:Frame style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if (backgroundColor) {
        tableView.backgroundColor = backgroundColor;
    }
    if (rowHeight) {
        tableView.rowHeight = rowHeight;
    }
    if (superUIView) {
        [superUIView addSubview:tableView];
    }
    return tableView;
}
@end

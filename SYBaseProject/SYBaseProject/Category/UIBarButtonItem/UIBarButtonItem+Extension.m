//
//  UIBarButtonItem+Extension.m
//  CCMicroblog_2
//
//  Created by April on 7/7/15.
//  Copyright (c) 2015 gunzi. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage horizontalAlignment:(UIControlContentHorizontalAlignment)alignment
{
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateSelected];
    
    if (alignment) {
          button.contentHorizontalAlignment = alignment;
    }
  
//    button.size = button.currentBackgroundImage.size;
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+(UIBarButtonItem *)ItemWithTitle:(NSString *)title Font:(UIFont *)font titlesColor:(UIColor *)color target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title  forState:UIControlStateNormal];
    button.frame = (CGRect){CGPointZero,44,44};
    button.titleLabel.font = font;
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button setTitleColor:color forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+(NSArray<UIBarButtonItem*>*)ItemsWithTitles:(NSArray*)titleArray Font:(UIFont *)font titlesColor:(UIColor *)color target:(id)target action:(SEL)action itemsType:(itemType)type{
    
    NSMutableArray *itemsMutArray = [NSMutableArray array];
    
    for (int i = 0; i <titleArray.count; i ++) {
       
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (type == itemType_titles) { //纯标题
            
             [button setTitle:titleArray[i]  forState:UIControlStateNormal];
            button.titleLabel.font = font;
             [button setTitleColor:color forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentRight;
        }else{
            //出图标
            [button setImage:kImageWithName(titleArray[i]) forState:UIControlStateNormal];
        }
   
        button.frame = (CGRect){CGPointZero,40,35};
        button.tag = 201+i;
    
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [itemsMutArray addObject:[[UIBarButtonItem alloc]initWithCustomView:button]];
    }
    
    return itemsMutArray;
    
}




@end

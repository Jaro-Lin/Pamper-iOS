//
//  FTEmptyView.h
//  FinTest
//
//  Created by Apple on 2018/3/7.
//  Copyright © 2018年 Pactera. All rights reserved.
//

#import "LYEmptyView.h"

@interface FTEmptyView : LYEmptyView

+ (instancetype)diyEmptyView;
+ (instancetype)diyEmptyActionViewWithTarget:(id)target action:(SEL)action;

@end

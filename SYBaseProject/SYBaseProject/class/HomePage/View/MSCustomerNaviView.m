//
//  MSCustomerNaviView.m
//  magicShop
//
//  Created by apple on 2019/11/1.
//  Copyright © 2019 YYB. All rights reserved.
//

#import "MSCustomerNaviView.h"

@implementation MSCustomerNaviView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.topMargin.constant = KStatusBarHeight;
    KViewRadius(self.writeBtn, 14);
}

@end

@implementation MSTopicLocationNaviView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.topHeight.constant = KStatusBarHeight;
    KViewRadius(self.writeBtn, 14);
}


@end

@implementation MSTopSearchView

- (void)awakeFromNib{
    [super awakeFromNib];

    KViewRadius(self.searchView, 8);
}

@end

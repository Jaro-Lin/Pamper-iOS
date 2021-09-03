//
//  SYUserDetailHeadView.m
//  SYBaseProject
//
//  Created by sy on 2020/3/29.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYUserDetailHeadView.h"

@implementation SYUserDetailHeadView
- (void)awakeFromNib{
    [super awakeFromNib];
    KViewRadius(self.userHeadView, 25);
}
@end


@implementation SYCommontView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.commontTV.returnKeyType = UIReturnKeySend;
}
@end


@implementation SYSecondCommontHeadView
- (void)awakeFromNib{
    [super awakeFromNib];
    KViewRadius(self.userHead, 19);
}

@end

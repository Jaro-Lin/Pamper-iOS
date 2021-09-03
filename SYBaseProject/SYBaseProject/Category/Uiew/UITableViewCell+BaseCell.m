//
//  UITableViewCell+BaseCell.m
//  paotui
//
//  Created by apple on 2019/3/11.
//  Copyright © 2019 ly. All rights reserved.
//

#import "UITableViewCell+BaseCell.h"

@implementation UITableViewCell (BaseCell)

+ (instancetype)getMyCell:(UITableView *) tableView{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end

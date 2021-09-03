//
//  OLCommentCell.h
//  OLive
//
//  Created by xiao on 2019/4/14.
//  Copyright © 2019 oldManLive. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OLCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avaterIM;
@property (weak, nonatomic) IBOutlet UILabel *usenNameLB;
@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@end

NS_ASSUME_NONNULL_END

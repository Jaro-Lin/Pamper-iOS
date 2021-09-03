//
//  SYCollectionVideosTableViewCell.h
//  SYBaseProject
//
//  Created by sy on 2020/4/9.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYCollectionVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYCollectionVideosTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoCoverImage;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property(nonatomic, strong) SYCollectionVideoModel *videoModel;
@end

NS_ASSUME_NONNULL_END

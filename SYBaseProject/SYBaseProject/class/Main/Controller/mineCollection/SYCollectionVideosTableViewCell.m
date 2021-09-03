//
//  SYCollectionVideosTableViewCell.m
//  SYBaseProject
//
//  Created by sy on 2020/4/9.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYCollectionVideosTableViewCell.h"

@implementation SYCollectionVideosTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setVideoModel:(SYCollectionVideoModel *)videoModel{
    _videoModel = videoModel;
    
    [self.videoCoverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageServer,_videoModel.image]] placeholderImage:kPlaceHoldImage];
    self.collectionBtn.selected = _videoModel.if_collection;
    self.videoTitle.text = _videoModel.title;
}
@end

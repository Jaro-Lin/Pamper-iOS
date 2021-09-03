//
//  SYCustomCollectionViewCell.h
//  SYBaseProject
//
//  Created by sy on 2020/3/25.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYCustomCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *img;
//视频状态下有此按钮
@property(nonatomic, strong) UIButton *playBtn;

@end

NS_ASSUME_NONNULL_END

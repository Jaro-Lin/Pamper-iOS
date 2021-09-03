//
//  SYHotClassCollectionViewCell.h
//  SYBaseProject
//
//  Created by sy on 2020/4/2.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYHotClassCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) SYClassModel *classModel;
@property (weak, nonatomic) IBOutlet UILabel *classTitle;
@property (weak, nonatomic) IBOutlet UIImageView *classImageView;
@property (weak, nonatomic) IBOutlet UILabel *studyCount;


@end

NS_ASSUME_NONNULL_END

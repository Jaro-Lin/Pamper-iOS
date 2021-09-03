//
//  SYHotClassCollectionViewCell.m
//  SYBaseProject
//
//  Created by sy on 2020/4/2.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYHotClassCollectionViewCell.h"

@implementation SYHotClassCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    KViewRadius(self.classImageView, 4);

}
- (void)setClassModel:(SYClassModel *)classModel{
    _classModel = classModel;
    
    [self.classImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageServer,_classModel.img]] placeholderImage:kPlaceHoldImage];
    self.classTitle.text = _classModel.title;
    self.studyCount.text = [NSString stringWithFormat:@"%@人已学习",_classModel.study_number];
    
}
@end

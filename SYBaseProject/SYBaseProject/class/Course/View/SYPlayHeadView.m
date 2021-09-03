//
//  SYPlayHeadView.m
//  SYBaseProject
//
//  Created by sy on 2020/4/2.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYPlayHeadView.h"

@implementation SYPlayHeadView
- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.followBtn addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setModel:(SYClassModel *)model{
    _model = model;
    
    [self.classImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageServer,_model.img]] placeholderImage:kPlaceHoldImage];
    self.classTitleLB.text = _model.title;
    self.playCountLB.text = [NSString stringWithFormat:@"播放量：%@",_model.study_number];
    self.followBtn.selected = _model.follow;
}

- (void)followAction:(UIButton*)sender{
  
    NSMutableDictionary *param =[[NSMutableDictionary alloc]init];
    [param setObject:self.model.type_id forKey:@"type_id"];
    [param setObject:self.model.ID forKey:@"course_id"];

    [ShareRequest shareRequestDataWithAppendURL:@"/course/course/collection" Params:param IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
       sender.selected = !sender.selected;
    } Fail:^(NSError *error) {
        
    }];
    
}
@end

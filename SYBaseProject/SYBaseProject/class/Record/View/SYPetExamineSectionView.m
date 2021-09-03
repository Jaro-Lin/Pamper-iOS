//
//  SYPetExamineSectionView.m
//  SYBaseProject
//
//  Created by sy on 2020/6/15.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYPetExamineSectionView.h"
#import "BRDatePickerView.h"
#import "BRStringPickerView.h"

@implementation SYPetExamineSectionView
- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.selectedBtn addTarget:self action:@selector(btnSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.dutionBtn addTarget:self action:@selector(timeChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)setHeadType:(sectionHeadType)headType{
    _headType = headType;
    
    self.selectedBtn.hidden = (_headType == sectionHeadType_nomal ? NO:YES);
    self.dutionLB.hidden = (_headType == sectionHeadType_nomal ? YES:NO);
    self.dutionBtn.hidden = (_headType == sectionHeadType_nomal ? YES:NO);
}
- (void)setSection:(NSInteger)section{
    _section = section;
}
- (void)btnSelectedAction:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(sectionHeadViewSelected:sectionRow:)]) {
        [_delegate sectionHeadViewSelected:sender.selected sectionRow:self.section];
    }
}
- (void)timeChooseAction:(UIButton*)sender{
    
   NSMutableArray *countArrM = [NSMutableArray array];
   for (int i = 0; i <31; i ++) {
       [countArrM addObject:[NSString stringWithFormat:@"%d天",i]];
   }
    kSelfWeak;
    [BRStringPickerView showPickerWithTitle:self.titleLB.text dataSourceArr:[countArrM copy] selectIndex:1 resultBlock:^(BRResultModel * _Nullable resultModel) {
       
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(bathExpellingChoosed:sectionRow:)]) {
            [weakSelf.delegate bathExpellingChoosed:[NSString stringWithFormat:@"%ld",resultModel.index] sectionRow:self.section];
        }
        self.dutionLB.text = resultModel.value;
   }];
}
@end

@implementation SYExamineTableViewCell
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.timeChooseBtn addTarget:self action:@selector(timeChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.countChooseBtn addTarget:self action:@selector(countChooseAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}
- (void)setScheduleModel:(SYScheduleInitModel *)scheduleModel{
    _scheduleModel = scheduleModel;
    
    NSString *timeStr = (self.indexPath.section ==0 ?self.scheduleModel.vaccin_time0:self.scheduleModel.vaccin_time1);
    self.timeLB.text = kStringIsEmpty(timeStr)?@"请选择":timeStr;
    NSString *countStr = (self.indexPath.section ==0 ?self.scheduleModel.vaccin_count0:self.scheduleModel.vaccin_count1);
    self.countLB.text = kStringIsEmpty(countStr)?@"请选择":countStr;
}
//时间选择
- (void)timeChooseAction:(UIButton*)sender{
    
    [BRDatePickerView showDatePickerWithTitle:self.topTitleLB.text dateType:UIDatePickerModeDate defaultSelValue:(self.indexPath.section ==0? self.scheduleModel.vaccin_time0:self.scheduleModel.vaccin_time1) minDateStr:@"" maxDateStr:@"" isAutoSelect:NO resultBlock:^(NSString *selectValue) {
           if (kStringIsEmpty(selectValue)) return;
        if (self.indexPath.section ==0) {
            self.scheduleModel.vaccin_time0 = selectValue;
        }else if(self.indexPath.section ==1){
            self.scheduleModel.vaccin_time1 = selectValue;
        }else if(self.indexPath.section ==2){
            self.scheduleModel.expelling_time = selectValue;
        }else if(self.indexPath.section ==3){
            self.scheduleModel.bath_time = selectValue;
        }
        self.timeLB.text = selectValue;
       }];
}
//间隔周期选择
- (void)countChooseAction:(UIButton*)sender{
    NSMutableArray *countArrM = [NSMutableArray array];
    for (int i = 0; i <31; i ++) {
        [countArrM addObject:[NSString stringWithFormat:@"%d针",i]];
    }
    [BRStringPickerView showPickerWithTitle:@"总共打了几针疫苗?" dataSourceArr:[countArrM copy] selectIndex:1 resultBlock:^(BRResultModel * _Nullable resultModel) {
        if (self.indexPath.section ==0) {
            self.scheduleModel.vaccin_count0 = [NSString stringWithFormat:@"%ld",resultModel.index];
               }else{
                   self.scheduleModel.vaccin_count1 = [NSString stringWithFormat:@"%ld",resultModel.index];
               }
        self.countLB.text = resultModel.value;
    }];
}
@end

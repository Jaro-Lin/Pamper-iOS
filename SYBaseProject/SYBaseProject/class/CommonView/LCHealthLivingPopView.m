//
//  LCHealthLivingPopView.m
//  sanShanClient
//
//  Created by apple on 2019/6/25.
//  Copyright © 2019 121. All rights reserved.
//

#import "LCHealthLivingPopView.h"
#import "UIView+Extension.h"
#import "SYPetModel.h"
#import "UIScrollView+Empty.h"

@implementation LCHealthLivingPopViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dataLB = [UILabel creatLabelWithTitle:@"" textColor:KUIColorFromRGB(0x333333) textFont:[UIFont systemFontOfSize:15]];
        [self addSubview:self.dataLB];
        [self.dataLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

@end


@implementation LCHealthLivingPopView
- (void)awakeFromNib{
    
    [super awakeFromNib];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [UIView new];
}

- (void)setDataArray:(NSArray<baseModel *> *)dataArray{
    _dataArray = dataArray;
    if (_dataArray.count <=0) {
        [self.mainTableView showNoDataStatusWithString:@"暂无宠物类型" imageName:@"" withOfffset:0];
    }
    [self.mainTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LCHealthLivingPopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCHealthLivingPopViewCell"];
    if (!cell) {
        
        cell = [[LCHealthLivingPopViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LCHealthLivingPopViewCell"];
    }
    id model = self.dataArray[indexPath.row];
    if ([model isKindOfClass:[SYPetBreedModel class]]) {
        SYPetBreedModel *breed = (SYPetBreedModel*)model;
        cell.dataLB.text = breed.varieties_name;
    }else if([model isKindOfClass:[NSString class]]){
        cell.dataLB.text = (NSString*)model;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.indexRow = indexPath.row;
    !self.sureActionBlock ?:self.sureActionBlock(self.dataArray[self.indexRow],self.indexRow);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (IBAction)cancelAction:(UIButton *)sender {
    !self.cancelActionBlock ?:self.cancelActionBlock();
}
- (IBAction)sureAction:(UIButton *)sender {
//    !self.sureActionBlock ?:self.sureActionBlock(self.dataArray[self.indexRow],self.indexRow);
}

@end

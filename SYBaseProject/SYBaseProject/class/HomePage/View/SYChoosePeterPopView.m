//
//  SYChoosePeterPopView.m
//  SYBaseProject
//
//  Created by sy on 2020/3/26.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYChoosePeterPopView.h"
#import "UIView+Nib.h"
#import "UIView+Extension.h"
#import <MJExtension/MJExtension.h>

@interface SYChoosePeterTableViewCell : UITableViewCell

@property(nonatomic, strong) UILabel *peterName;
@property(nonatomic, strong) UIButton *selectedBtn;

@end
@implementation SYChoosePeterTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.peterName = [[UILabel alloc]initWithFrame:CGRectZero];
        self.peterName.textColor = KUIColorFromRGB(0x000000);
        self.peterName.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:self.peterName];
        
        
        self.selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectedBtn setImage:kImageWithName(@"icon_selecte_nomal") forState:UIControlStateNormal];
        [self.selectedBtn setImage:kImageWithName(@"peter_selected") forState:UIControlStateSelected];
        [self.contentView addSubview:self.selectedBtn];

        self.selectedBtn.userInteractionEnabled = NO;
    }
    return self;
}
- (void)layoutSubviews{
    
    [self.peterName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).mas_offset(KAdaptW(25));
    }];
    
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).mas_offset(-KAdaptW(15));
        make.height.width.mas_offset(38);
    }];
}
@end

@implementation SYChoosePeterPopView
- (void)awakeFromNib{
    [super awakeFromNib];

    self.seledtedRow = 0;
    self.peterTbaleView.delegate = self;
    self.peterTbaleView.dataSource = self;
    self.peterTbaleView.tableFooterView = [UIView new];
    [self requestaAllPetInfo];
    
    [[self.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {

        if (self.delegate && [self.delegate respondsToSelector:@selector(choosedPetInfo:)]) {
            [self.delegate choosedPetInfo:self.petsArr[self.seledtedRow]];
        }
    }];
    
    [[self.backBnt rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
          if (self.delegate && [self.delegate respondsToSelector:@selector(cancelChoose)]) {
                [self.delegate cancelChoose];
            }
      }];
}

- (void)requestaAllPetInfo{
    
    [ShareRequest shareRequestDataWithAppendURL:@"/pets/pets/pets_info" Params:nil IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        self.petsArr = [SYPetModel mj_objectArrayWithKeyValuesArray:dic];
        [self.peterTbaleView reloadData];
    } Fail:^(NSError *error) {
        
    }];
 
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.petsArr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SYChoosePeterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYChoosePeterTableViewCell"];
    if (!cell) {
        
        cell = [[SYChoosePeterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SYChoosePeterTableViewCell"];
    }
    SYPetModel *petModel = self.petsArr[indexPath.row];
    cell.peterName.text = petModel.nickname;
    cell.selectedBtn.selected = (indexPath.row ==self.seledtedRow ?YES:NO);
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.seledtedRow = indexPath.row;
    [self.peterTbaleView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
@end



@implementation SYCommitPopView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =KUIColorFromRGB(0xffffff);
        
        self.titleLB =[UILabel creatLabelWithTitle:@"提示" textColor:KUIColorFromRGB(0x333333) textFont:[UIFont boldSystemFontOfSize:16]];
        self.titleLB.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLB];
        
        self.messageLB =[UILabel creatLabelWithTitle:@"添加成功！" textColor:KUIColorFromRGB(0x333333) textFont:[UIFont boldSystemFontOfSize:14]];
               self.messageLB.textAlignment = NSTextAlignmentCenter;
        self.messageLB.numberOfLines = 0;
               [self addSubview:self.messageLB];
        
        self.konowedBtn = [UIButton creatBtnWithTitle:@"我知道了" textFont:[UIFont boldSystemFontOfSize:12] normalImage:@"" selectedImage:@"" titleColor:KUIColorFromRGB(0xffffff) backGroundColor:KUIColorFromRGB(0x23A0F0)];
        [self addSubview:self.konowedBtn];
        
        
        KViewRadius(self, 16);
    }
    return self;
}
- (void)layoutSubviews{
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).mas_offset(15);
    }];
    
    [self.messageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(self.mas_width);
    }];
    
    [self.konowedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_offset(42);
           make.width.equalTo(self.mas_width);
       }];
}
@end

@implementation SYSignedOnPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =KUIColorFromRGB(0xffffff);
        
        self.titleLB =[UILabel creatLabelWithTitle:@"今日已签到" textColor:KUIColorFromRGB(0x000000) textFont:[UIFont boldSystemFontOfSize:20]];
        self.titleLB.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLB];
        
        self.ondMessageLB =[UILabel creatLabelWithTitle:@"您当月已连续签到 3 天" textColor:KUIColorFromRGB(0x000000) textFont:[UIFont systemFontOfSize:14]];
               self.ondMessageLB.textAlignment = NSTextAlignmentCenter;
        self.ondMessageLB.numberOfLines = 1;
               [self addSubview:self.ondMessageLB];
        
        self.secondMessageBtn = [UIButton creatBtnWithTitle:@"恭喜你获得一张优惠券" textFont:[UIFont boldSystemFontOfSize:12] normalImage:@"" selectedImage:@"" titleColor:KUIColorFromRGB(0x333333) backGroundColor:KUIColorFromRGB(0xffffff)];
               [self addSubview:self.secondMessageBtn];
        
        self.thirdMessageLB =[UILabel creatLabelWithTitle:@"请到 我的→优惠券 查看" textColor:KUIColorFromRGB(0x333333) textFont:[UIFont boldSystemFontOfSize:12]];
                      self.thirdMessageLB.textAlignment = NSTextAlignmentCenter;
               self.thirdMessageLB.numberOfLines = 1;
                      [self addSubview:self.thirdMessageLB];
        
        self.bottomBtn = [UIButton creatBtnWithTitle:@"签到成功" textFont:[UIFont boldSystemFontOfSize:14] normalImage:@"" selectedImage:@"" titleColor:KUIColorFromRGB(0xffffff) backGroundColor:KUIColorFromRGBWithAlpha(0x23A0F0, 0.6)];
        [self addSubview:self.bottomBtn];

        
        KViewRadius(self, 16);
    }
    return self;
}
- (void)layoutSubviews{
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_offset(30);
        make.top.equalTo(self.mas_top).mas_offset(15);
    }];
    
    [self.ondMessageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.titleLB.mas_bottom).mas_offset(25);
    }];

    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_offset(40);
    }];
    [self.thirdMessageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.bottomBtn.mas_top).mas_offset(-24);
    }];
    [self.secondMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.ondMessageLB.mas_bottom).mas_offset(16);
        make.bottom.equalTo(self.thirdMessageLB.mas_top).mas_offset(2);
    }];
    
}

@end

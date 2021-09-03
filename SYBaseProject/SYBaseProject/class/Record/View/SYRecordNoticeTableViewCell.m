//
//  SYRecordNoticeTableViewCell.m
//  SYBaseProject
//
//  Created by apple on 2020/7/21.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYRecordNoticeTableViewCell.h"
#import "SYRecordNoticeViewController.h"
#import "NSObject+getCurrentViewController.h"

@implementation SYRecordNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setHealthModel:(SYRecoedHealthModel *)healthModel{
    _healthModel = healthModel;
    self.topTitleLB.text = _healthModel.title;
    
    [self setupButtonsView];
    
}
/** 创建title视图 */
-(void)setupButtonsView{
    
    for (UIView *subView in self.detailContentView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
    //拿到屏幕的宽
    CGFloat kScreenW = [UIScreen mainScreen].bounds.size.width;
    
    //间距
    CGFloat padding = 30;
    CGFloat titBtnX = 20;
    CGFloat titBtnY = 10;
    CGFloat titBtnH = 30;
    
    for (int i = 0; i < self.healthModel.child.count; i++) {
        SYRecoedHealthChildModel *childModel = self.healthModel.child[i];
        
        UIButton *titBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置按钮的样式
        [titBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        
        titBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [titBtn setTitle:childModel.title forState:UIControlStateNormal];
        
        titBtn.tag = 1000+i;
        KViewBorderRadius(titBtn, 4, 1, RGBOF(0xBABABA));
        [titBtn addTarget:self action:@selector(titBtnClike:) forControlEvents:UIControlEventTouchUpInside];
        
        //计算文字大小
        CGSize titleSize = [childModel.title boundingRectWithSize:CGSizeMake(MAXFLOAT, titBtnH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titBtn.titleLabel.font} context:nil].size;
        
        CGFloat titBtnW = titleSize.width + 2 * padding;
        //判断按钮是否超过屏幕的宽
        if ((titBtnX + titBtnW) > kScreenW-20) {
            titBtnX = 20;
            titBtnY += titBtnH + padding/3.0;
        }
        //设置按钮的位置
        titBtn.frame = CGRectMake(titBtnX, titBtnY, titBtnW, titBtnH);
        titBtnX += titBtnW + padding;
        [self.detailContentView addSubview:titBtn];

    }
}
- (void)titBtnClike:(UIButton*)sender{
    //获取具体内容
    SYRecoedHealthChildModel *childeMode = self.healthModel.child[sender.tag-1000];
    
    SYRecordNoticeViewController *noticeVC = [[SYRecordNoticeViewController alloc]init];
    noticeVC.title = childeMode.title;
    //            noticeVC.contentStr = dic[@"data"][@"content"];
    noticeVC.htmlUrl = [NSString stringWithFormat:@"%@/pets/malady/show?id=%@",requestServerURL,childeMode.ID];
    [[self getCurrentVC].navigationController pushViewController:noticeVC animated:YES];
    
    
    
    //    [ShareRequest shareRequestDataWithAppendURL:@"/pets/malady/detail" Params:@{@"malady_id":@([childeMode.ID integerValue])} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
    //
    //        if ([dic[@"data"] isKindOfClass:[NSDictionary class]]) {
    //
    //            SYRecordNoticeViewController *noticeVC = [[SYRecordNoticeViewController alloc]init];
    //            noticeVC.title = dic[@"data"][@"title"];
    ////            noticeVC.contentStr = dic[@"data"][@"content"];
    //            noticeVC.htmlUrl = [NSString stringWithFormat:@"%@/pets/pets_type/%@?id=%@",requestServerURL,contentStr,self.currentPetModel.varieties_id]
    //            [[self getCurrentVC].navigationController pushViewController:noticeVC animated:YES];
    //        }
    //
    //    } Fail:^(NSError *error) {
    //
    //    }];
}

@end

//
//  SYHomeManagerHeadView.m
//  SYBaseProject
//
//  Created by sy on 2020/3/25.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYHomeManagerHeadView.h"
#import "SYTopicListViewController.h"
#import "NSObject+getCurrentViewController.h"
#import "SYTopicMomentsViewController.h"

@implementation SYHomeManagerHeadView
- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    KViewRadius(self.addPeterBtn, 20);
    KViewRadius(self.addOtherPeterBtn, 12);
    KViewRadius(self.otherPeter, 12);
    KViewRadius(self.peterPhotoView, 16);
}

- (void)setHeadViewType:(SYHeadViewType)headViewType{
    
    BOOL noPeter = (headViewType == headView_NoPeter ? YES:NO);
    
    self.peterPhotoView.hidden = noPeter;
    self.peterName.hidden = noPeter;
    self.peterYeaLOld.hidden = noPeter;
    self.peterOldMan.hidden = noPeter;
    self.needDoAction.hidden = noPeter;
    self.addOtherPeterBtn.hidden = noPeter;
    self.otherPeter.hidden = noPeter;
    
    self.jinggaoBtn.hidden = !noPeter;
    self.addPeterBtn.hidden = !noPeter;

}

@end

@implementation SYHomeRecordHeadView
- (void)awakeFromNib{
    [super awakeFromNib];
    
     KViewRadius(self.oneLB, 10);
     KViewRadius(self.twoLB, 10);
     KViewRadius(self.threeLB, 10);
    
    [[self.moreHotBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[self getCurrentVC].navigationController pushViewController:[SYTopicListViewController new] animated:YES];
    }];
    
    //获取话题榜
    [ShareRequest shareRequestDataWithAppendURL:@"/post/theme/theme" Params:@{@"page":@"1",@"limit":@"3"} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        NSArray *topicArr = [SYTopicModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        self.topicArr = topicArr;
        //更新榜单
        if (topicArr.count <=0) {
            for (UIView *subView in self.subviews) {
                if ([subView isKindOfClass:[UILabel class]]) {
                    subView.hidden = YES;
                }
            }
        }else if (topicArr.count <=1){
            SYTopicModel *topicOne = topicArr[0];
            self.oneLB.text = @"1";
            self.hotCountOneLB.text = [NSString stringWithFormat:@"%@ 热度",topicOne.use_num];
            self.oneHotTopic.text = topicOne.theme_title;
            
            self.twoLB.hidden = YES;
            self.twoHotTopic.hidden = YES;
            self.hotCountTwoLB.hidden = YES;
            
            self.threeLB.hidden = YES;
                     self.threeLB.hidden = YES;
                     self.threeLB.hidden = YES;
        }else if (topicArr.count <=2){
            SYTopicModel *topicOne = topicArr[0];
            SYTopicModel *topicTwo = topicArr[1];
            self.oneLB.text = @"1";
            self.hotCountOneLB.text = [NSString stringWithFormat:@"%@ 热度",topicOne.use_num];
            self.oneHotTopic.text = topicOne.theme_title;
            
            self.twoLB.text = @"2";
            self.twoHotTopic.text = [NSString stringWithFormat:@"%@ 热度",topicTwo.use_num];
            self.hotCountTwoLB.text=topicTwo.theme_title;
            
            self.threeLB.hidden = YES;
            self.hotCountThreeLB.hidden = YES;
            self.threeHotTopic.hidden = YES;
            
        }else if (topicArr.count <=3){
            
            SYTopicModel *topicOne = topicArr[0];
            SYTopicModel *topicTwo = topicArr[1];
            SYTopicModel *topicThree = topicArr[2];
            
            self.oneLB.text = @"1";
            self.hotCountOneLB.text = [NSString stringWithFormat:@"%@ 热度",topicOne.use_num];
            self.oneHotTopic.text = topicOne.theme_title;
            
            self.twoLB.text = @"2";
            self.hotCountTwoLB.text = [NSString stringWithFormat:@"%@ 热度",topicTwo.use_num];
            self.twoHotTopic.text=topicTwo.theme_title;
            
            self.threeLB.text = @"3";
            self.hotCountThreeLB.text = [NSString stringWithFormat:@"%@ 热度",topicThree.use_num];
            self.threeHotTopic.text = topicThree.theme_title;
        }
        
        } Fail:^(NSError *error) {

        }];
    
    //点击手势
    UITapGestureRecognizer *firstTap = [[UITapGestureRecognizer alloc]init];
    [[firstTap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self gotoHotMoment:0];
    }];
    [self.oneHotTopic addGestureRecognizer:firstTap];
    self.oneHotTopic.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *secondTap = [[UITapGestureRecognizer alloc]init];
    [[secondTap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self gotoHotMoment:1];
    }];
    [self.twoHotTopic addGestureRecognizer:secondTap];
    self.twoHotTopic.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *thirdTap = [[UITapGestureRecognizer alloc]init];
    [[thirdTap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self gotoHotMoment:2];
    }];
    [self.threeHotTopic addGestureRecognizer:thirdTap];
    self.threeHotTopic.userInteractionEnabled = YES;
    
}
//热门话题下的动态
- (void)gotoHotMoment:(NSInteger)index{
    SYTopicModel *topicModel = self.topicArr[index];
    SYTopicMomentsViewController *topicVC = [[SYTopicMomentsViewController alloc]init];
    topicVC.title = topicModel.theme_title;
    topicVC.themeID = topicModel.ID;
    [[self getCurrentVC].navigationController pushViewController:topicVC animated:YES];
}

@end

@implementation SYHomeCityHeadView
- (void)awakeFromNib{
    [super awakeFromNib];
}
@end

@implementation SYHomeSearchHeadView
- (void)awakeFromNib{
    [super awakeFromNib];
    KViewRadius(self.contentSubView, 15);
}
@end

//
//  SYJuBaoViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/4/20.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYJuBaoViewController.h"
#import "SYJuBaoModel.h"

@interface SYJuBaoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *jubaoTypeLB;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIView *jubaoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jubaoViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *commitReportBtn;
@property(nonatomic, strong) NSArray *allReportArr;

@property(nonatomic, strong) SYJuBaoModel *juBaoModel;

@end

@implementation SYJuBaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = (self.juBaoType == 1?@"举报评论":@"举报动态");
    KViewRadius(self.commitReportBtn, 24);

    self.userName.text = self.topTitleStr;
    self.jubaoTypeLB.text = (self.juBaoType == 1?@"的评论":@"的动态");
    [self getAllReportType];
}
- (void)getAllReportType{
    
    [ShareRequest shareRequestGetDataWithAppendURL:@"/post/comment/get_report_type" Params:@{} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        self.allReportArr = [SYJuBaoModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
        //添加按钮
        [self initBtnsView];
    } Fail:^(NSError *error) {
        
    }];
}

- (void)initBtnsView{
    for (UIView *view in self.jubaoView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    //间距
       CGFloat padding = 40;
       
       CGFloat titBtnX = 10;
       CGFloat titBtnY = 45;
       CGFloat titBtnH = 26;
    
    CGFloat titBtnW = (KScreenWidth-padding*2-titBtnX*2)/3.0;
       
       for (int i = 0; i < self.allReportArr.count; i++) {
           SYJuBaoModel *jubaoModel = self.allReportArr[i];
           UIButton *titBtn = [UIButton buttonWithType:UIButtonTypeCustom];
           //设置按钮的样式
           titBtn.backgroundColor = KUIColorFromRGB(0xDDDDDD);
           [titBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
           [titBtn setTitleColor:KUIColorFromRGB(0x23A0F0) forState:UIControlStateSelected];
           
           titBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
           [titBtn setTitle:jubaoModel.type forState:UIControlStateNormal];
           titBtn.tag = 1000+i;
           [titBtn addTarget:self action:@selector(titBtnClike:) forControlEvents:UIControlEventTouchUpInside];
           titBtn.frame = CGRectMake(titBtnX+i%3*(titBtnW+padding), titBtnY+i/3*(titBtnH+15), titBtnW, titBtnH);
           [self.jubaoView addSubview:titBtn];
           
           if (i == self.allReportArr.count-1) {
               self.jubaoViewHeight.constant = CGRectGetMaxY(titBtn.frame)+20;
           }
       }
    
}

- (void)titBtnClike:(UIButton*)sender{
    for (UIView *subView in self.jubaoView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subView;
            if (button.tag == sender.tag) {
                sender.selected = !sender.selected;
                
                if (sender.selected) {
                    self.juBaoModel = self.allReportArr[sender.tag-1000];
                }else{
                    self.juBaoModel =nil;
                }
            }else{
                button.selected = NO;
            }
        }
    }
}

- (void)initView{
    
    [[self.commitReportBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        if (!self.juBaoModel) {
            [self.view makeToast:@"请先选择举报类型"];
            return;
        }
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
              [params setObject:self.post_id forKey:@"post_id"];
              [params setObject:self.juBaoModel.ID forKey:@"type_id"];
        if (self.juBaoType ==0) {//动态
            [ShareRequest shareRequestDataWithAppendURL:@"/post/post_about/report_post" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
                
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"举报成功！" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"返回首页" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                
                [alertVC addAction:sureAction];
                [self presentViewController:alertVC animated:YES completion:nil];
                
            } Fail:^(NSError *error) {
                
            }];
            
        }else if(self.juBaoType ==1){//评论
            [params setObject:self.commont_id forKey:@"comment_id"];
            [ShareRequest shareRequestDataWithAppendURL:@"/post/comment/del_impeach" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
                [self.navigationController popViewControllerAnimated:YES];
            } Fail:^(NSError *error) {
                
            }];
        }
       
    }];

}
@end

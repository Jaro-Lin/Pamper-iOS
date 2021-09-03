//
//  SYHomePageViewController.m
//  YNPageViewController
//
//  Created by ZYN on 2018/6/22.
//  Copyright © 2018年 yongneng. All rights reserved.
//

#import "SYHomePageViewController.h"
#import "SYHomeListViewController.h"
#import "SYHomeManagerHeadView.h"
#import "UIView+Nib.h"
#import "UIBarButtonItem+Extension.h"
#import "zhPopupController.h"
#import "SYChoosePeterPopView.h"
#import "SYAddPeterViewController.h"
#import "UIView+Extension.h"
#import "SYReportMomentViewController.h"
#import "SYMomentSearchViewController.h"//搜索动态
#import "NSString+Common.h"

@interface SYHomePageViewController () <SYChoosePeterDelegate,UITextFieldDelegate>

@property(nonatomic, strong) SYHomeManagerHeadView *managerHeadView;
@property (nonatomic, copy) NSArray *cacheKeyArray;
@property(nonatomic, strong) SYHomeSearchHeadView *serchView;
@property (nonatomic,assign) BOOL noPeter;

@property(nonatomic, strong) UIButton *reportBtn;

@end

@implementation SYHomePageViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (@available(iOS 11.0, *)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.serchView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                make.left.mas_offset(57);
                make.right.mas_equalTo(-62);
            }];
        });
    }
     [self getDefaulePeter];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KUIColorFromRGB(0xEEEEEE);
    
    self.serchView = (SYHomeSearchHeadView*)[UIView instancesWithNib:@"SYHomeManagerHeadView" index:3];
    self.serchView.frame = CGRectMake(0, 0, KScreenWidth,KNavBarHeight);
    self.navigationItem.titleView = self.serchView;
    self.serchView.inputContent.delegate = self;
    self.serchView.inputContent.returnKeyType = UIReturnKeySearch;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(signInAction:) image:@"icon_signIn" highImage:@"icon_signIn" horizontalAlignment:UIControlContentHorizontalAlignmentCenter];
  
     _titles = @[@"推荐", @"关注", @"同城"];
    self.isNeedFooter= YES;
    self.isNeedHeader = YES;
    
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    self.categoryView.titles = self.titles;
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = KUIColorFromRGB(0x333333);
    self.categoryView.titleColor = KUIColorFromRGB(0x333333);
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;

    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = KUIColorFromRGB(0x707070);
    lineView.indicatorWidth = 30;
    self.categoryView.indicators = @[lineView];

    _pagerView = [self preferredPagingView];
    self.pagerView.mainTableView.gestureDelegate = self;
    [self.view addSubview:self.pagerView];

    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
    
    //动态发布
    self.reportBtn = [UIButton creatBtnWithTitle:@"" textFont:nil normalImage:@"icon_report" selectedImage:@"icon_report" titleColor:nil backGroundColor:nil];
    self.reportBtn.frame = CGRectMake(KScreenWidth-25-48, KScreenHeight-KTabBarHeight*2-19-48, 48, 48);
    [self.view addSubview:self.reportBtn];
    
    [[self.reportBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        SYReportMomentViewController *repprtVC = [[SYReportMomentViewController alloc]init];
        [self.navigationController pushViewController:repprtVC animated:YES];
    }];
    
    //更新用户信息
    [self updataUserInfo];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}

- (JXPagerView *)preferredPagingView {
    return [[JXPagerListRefreshView alloc] initWithDelegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.pagerView.frame = self.view.bounds;
}

#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.managerHeadView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return JXTableHeaderViewHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 40;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    //和categoryView的item数量一致
    return self.categoryView.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    
    SYHomeListViewController *listVC = [[SYHomeListViewController alloc] init];
    
    listVC.title = self.titles[index];
    listVC.isNeedHeader = self.isNeedHeader;
    listVC.isNeedFooter = self.isNeedFooter;
    listVC.pageIndex = index;
    
    return listVC;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
#pragma mark --签到
- (void)signInAction:(UIButton*)sender{
    
    //判断当天是否已经签到
    BOOL isSigin = NO;
    MSUserInfoModel *infoModel = [MSUserInformation sharedManager].userInfo;
    if ([NSString sameWithExpireTime:infoModel.last_sign_day]&& !kStringIsEmpty(infoModel.last_sign_day)) {
        isSigin = YES;
    }

    if (isSigin) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"今日已签到" message:[NSString stringWithFormat:@"您当月已连续签到 %@ 天",infoModel.sign_in_count] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:sureAction];
        [self presentViewController:alertVC animated:YES completion:nil];

    }else{
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"今日还未签到" message:[NSString stringWithFormat:@"您当月已连续签到 %@ 天",infoModel.sign_in_count] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"点击签到" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //弹出签到成功，若获取到优惠券则提示
            [ShareRequest shareRequestDataWithAppendURL:@"/user/user/sign" Params:nil IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
         
                NSInteger sign = [dic[@"sign"]integerValue];
              if(sign ==0){
                    [self.view makeToast:@"今日已签到" duration:1.5f position:CSToastPositionCenter];
              }else if(sign ==1){
                  
                  infoModel.last_sign_day = [NSString timintervalToTimeStr:kDateFormat_yMd timeInterval:[[NSDate new]timeIntervalSince1970]];
                  [[MSUserInformation sharedManager]saveUserInfo:infoModel];
                  
                  //弹出签到成功页面
                  BOOL hasCoupon = ![dic[@"coupon"] isKindOfClass:[NSNull class]];
                  self.zh_popupController = [zhPopupController popupControllerWithMaskType:zhPopupMaskTypeBlackTranslucent];
                  self.zh_popupController.layoutType = zhPopupLayoutTypeCenter;
                  self.zh_popupController.slideStyle = zhPopupSlideStyleFade;
                  
                  SYSignedOnPopView *popView = [[SYSignedOnPopView alloc]initWithFrame:CGRectMake(0, 0,KScreenWidth-78*2,204)];
                  popView.ondMessageLB.text = [NSString stringWithFormat:@"您当月已连续签到 %@ 天",[NSString stringWithFormat:@"%ld",[dic[@"total"]integerValue]+[infoModel.sign_in_count integerValue]]];
                  popView.secondMessageBtn.hidden = !hasCoupon;
                  popView.thirdMessageLB.hidden = !hasCoupon;
                  [self.zh_popupController presentContentView:popView];
                  [[popView.bottomBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
                      [self.zh_popupController dismiss];
                  }];
              }
                
            } Fail:^(NSError *error) {
                
            }];

        }];
        [alertVC addAction:sureAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
}

- (void)addPeter{
    
    SYAddPeterViewController *addVC = [[SYAddPeterViewController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
    
}
- (void)checkOtherPeter{
    
    SYChoosePeterPopView *peterView =(SYChoosePeterPopView*)[UIView instancesWithNib:@"SYChoosePeterPopView" index:0];
    peterView.frame = CGRectMake(0, 0, 252, 192);
    peterView.delegate = self;
    
    self.zh_popupController = [zhPopupController popupControllerWithMaskType:zhPopupMaskTypeBlackTranslucent];
    self.zh_popupController.layoutType = zhPopupLayoutTypeCenter;
    self.zh_popupController.slideStyle = zhPopupSlideStyleFade;
    self.zh_popupController.dismissOnMaskTouched = NO;
    [self.zh_popupController presentContentView:peterView];
    
    
}
#pragma mark -- SYChoosePeterDelegate
- (void)choosedPetInfo:(SYPetModel *)petModel{
    
    self.managerHeadView.peterName.text = petModel.nickname;
    self.managerHeadView.peterOldMan.text = [petModel.sex integerValue]==1 ?@"男":@"女";
    self.managerHeadView.peterYeaLOld.text = petModel.birthdayStr;
    self.managerHeadView.needDoAction.text = @"需要洗澡";
    [self.managerHeadView.peterPhotoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",petModel.server,petModel.avatar]] placeholderImage:kPlaceHoldImageUser];
    [self.zh_popupController dismiss];
    
    [self setDefaultPet:petModel.pid];
}

//设置为默认宠物
- (void)setDefaultPet:(NSString*)pid{
    [ShareRequest shareRequestDataWithAppendURL:@"/pets/pets_about/set_default" Params:@{@"pid":pid} IsShowHud:NO IsInteract:NO Complete:^(NSDictionary *dic) {

    } Fail:^(NSError *error) {
        [self.view makeToast:@"设置默认宠物失败" duration:1.5f position:CSToastPositionCenter];
    }];
}

- (void)cancelChoose{
    [self.zh_popupController dismiss];
}

- (void)updataUserInfo{
    
    [ShareRequest shareRequestDataWithAppendURL:@"/user/about_user/userinfo" Params:nil IsShowHud:NO IsInteract:NO Complete:^(NSDictionary *dic) {
        
        MSUserInfoModel *infoModel = [MSUserInfoModel mj_objectWithKeyValues:dic];
        [[MSUserInformation sharedManager]saveUserInfo:infoModel];
        
    } Fail:^(NSError *error) {
        
    }];
    
}
- (void)getDefaulePeter{
    
    [ShareRequest shareRequestDataWithAppendURL:@"/pets/pets_about/get_default" Params:nil IsShowHud:NO IsInteract:NO Complete:^(NSDictionary *dic) {
        
        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            
            SYPetModel *model = [SYPetModel mj_objectWithKeyValues:dic];
            self.managerHeadView.peterOldMan.text = model.sex;
            self.managerHeadView.peterYeaLOld.text = [NSString stringWithFormat:@"%@岁",model.age];
            self.managerHeadView.needDoAction.text = model.do_someStr;
            
            [self.managerHeadView.peterPhotoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.server,model.avatar]] placeholderImage:kPlaceHoldImage];
            self.managerHeadView.peterName.text = model.nickname;
            
            if (self.managerHeadView.headViewType != headView_HavePeter) {
                self.managerHeadView.headViewType = headView_HavePeter;
            }
        }else{
            self.managerHeadView.headViewType = headView_NoPeter;
        }
        
    } Fail:^(NSError *error) {
        
    }];
    
}
#pragma mark --UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self.navigationController pushViewController:[SYMomentSearchViewController new] animated:YES];
    return NO;
}
#pragma mark --懒加载
- (SYHomeManagerHeadView *)managerHeadView{
    
    if (!_managerHeadView) {
        _managerHeadView = (SYHomeManagerHeadView*)[UIView instancesWithNib:@"SYHomeManagerHeadView" index:0];
           _managerHeadView.frame = CGRectMake(0, 0, KScreenWidth,126);
           _managerHeadView.backgroundColor = [UIColor whiteColor];
           _managerHeadView.headViewType = !headView_NoPeter;
           
           [[_managerHeadView.addPeterBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
               [self addPeter];
           }];
           
           [[_managerHeadView.addOtherPeterBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
               [self addPeter];
              }];
           
           [[_managerHeadView.otherPeter rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
               [self checkOtherPeter];
              }];
    }
    return _managerHeadView;
}
@end

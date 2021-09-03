//
//  SYAddPeterViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/3/28.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYAddPeterViewController.h"
#import "SYAddPeterInfoViewController.h"
#import "UIButton+JKImagePosition.h"
#import "SYPetModel.h"
#import "LCHealthLivingPopView.h"
#import "SYChoosePetVarietiesViewController.h"

@interface SYAddPeterViewController ()<SYChoosePetVarietiesViewControllerDelegate>
@property(nonatomic, strong) NSArray *petTypArr;
@property(nonatomic, strong) NSArray *petsArr;
@property (nonatomic,copy) NSString *type_id;

@property(nonatomic, strong) LCHealthLivingPopView *languagesPopView;
@property(nonatomic, strong) SYPetBreedModel *selectedBreedModel;
@end

@implementation SYAddPeterViewController
- (LCHealthLivingPopView *)languagesPopView{
    if (!_languagesPopView) {
        _languagesPopView = [[[NSBundle mainBundle]loadNibNamed:@"LCHealthLivingPopView" owner:self options:nil]firstObject];
        _languagesPopView.frame = CGRectZero;
    }
    return _languagesPopView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加宠物";
    KViewRadius(self.nextStepBtn, 24);
    KViewRadius(self.catBtn, 16);
    KViewRadius(self.dogBtn, 16);
    
    [self.catBtn jk_setImagePosition:LXMImagePositionTop spacing:-18];
    [self.dogBtn jk_setImagePosition:LXMImagePositionTop spacing:-20];
    [self initButtonsClick];
    
    self.catBtn.selected = YES;
    [self.catBtn setBackgroundColor:KUIColorFromRGB(0x333333)];
    self.type_id = @"1";
    [self requestNetWork];
}

#pragma mark -- 获取宠物种类
- (void)requestNetWork{
    
    //    1--猫 2 --狗
    
    //    [ShareRequest shareRequestGetDataWithAppendURL:@"/pets/pets/get_type" Params:nil IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
    //        self.petTypArr = [SYPetTypeModel mj_objectArrayWithKeyValuesArray:dic];
    //
    //    } Fail:^(NSError *error) {
    //
    //    }];
    
    
}


- (IBAction)nextStepAction:(UIButton *)sender {
    
    if (!self.selectedBreedModel) {
        [self.view makeToast:@"请先选择宠物种类"];
        return;
    }
    SYAddPeterInfoViewController *peterInfoVC = [[SYAddPeterInfoViewController alloc]init];
    peterInfoVC.petModel = self.selectedBreedModel;
    [self.navigationController pushViewController:peterInfoVC animated:YES];
    
}
/**tag 0--狗  1--猫*/
- (IBAction)choosePeterType:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)view;
            if (button.tag == sender.tag) {
                button.selected = YES;
                [button setBackgroundColor:KUIColorFromRGB(0x333333)];
                self.type_id = sender.tag ==0 ?@"2":@"1";
            }else{
                if (button.tag <=1) {
                    button.selected = NO;
                    [button setBackgroundColor:KUIColorFromRGB(0xffffff)];
                }
                
            }
            
        }
    }
    
}

#pragma mark -- 按钮操作
- (void)initButtonsClick{
    //显示弹框
    //    [[self.morePeterBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
    //
    //        [ShareRequest shareRequestDataWithAppendURL:@"/pets/pets/get_varieties" Params:@{@"type_id":self.type_id} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
    //            self.petTypArr = [SYPetBreedModel mj_objectArrayWithKeyValuesArray:dic];
    //            [self showPopView];
    //        } Fail:^(NSError *error) {
    //
    //        }];
    //    }];
    
    
    [[self.morePeterBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        SYChoosePetVarietiesViewController *choosePetVarietiesVC = [[SYChoosePetVarietiesViewController alloc]init];
        choosePetVarietiesVC.type_id = self.type_id;
        choosePetVarietiesVC.delegate = self;
        [self.navigationController pushViewController:choosePetVarietiesVC animated:YES];
    }];
    
    
}
//- (void)showPopView{
//
//    NSInteger count = self.petTypArr.count;
//    if (count >=5 || count <=5) count = 5;
//
//    self.languagesPopView.frame = CGRectMake(0, 0, KScreenWidth, (count+1)*50);
//    self.languagesPopView.dataArray = self.petTypArr;
//
//    self.zh_popupController = [zhPopupController popupControllerWithMaskType:zhPopupMaskTypeBlackTranslucent];
//    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
//    self.zh_popupController.slideStyle = zhPopupSlideStyleFromBottom;
//    [self.zh_popupController presentContentView:self.languagesPopView];
//
//    kSelfWeak;
//    [self.languagesPopView setCancelActionBlock:^{
//        [weakSelf.zh_popupController dismiss];
//    }];
//
//    [self.languagesPopView setSureActionBlock:^(baseModel * _Nonnull selectedModel) {
//
//        if ([selectedModel isKindOfClass:[SYPetBreedModel class]]) {
//            weakSelf.selectedBreedModel = (SYPetBreedModel*)selectedModel;
//            weakSelf.peterName.text = weakSelf.selectedBreedModel.varieties_name;
//            //            NSLog(@"______%@",weakSelf.selectedBreedModel.varieties_name);
//        }
//        [weakSelf.zh_popupController dismiss];
//    }];
//
//}


#pragma mark -- SYChoosePetVarietiesViewControllerDelegate
- (void)choosedPetVarieties:(SYPetBreedModel*)petModel{
    self.selectedBreedModel = petModel;
    self.peterName.text = self.selectedBreedModel.varieties_name;
}
@end

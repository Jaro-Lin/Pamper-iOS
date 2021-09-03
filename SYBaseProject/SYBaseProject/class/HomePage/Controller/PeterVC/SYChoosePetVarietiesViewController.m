//
//  SYChoosePetVarietiesViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/7/5.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYChoosePetVarietiesViewController.h"
#import "MSChineseSort.h"
#import "LCHealthLivingPopView.h"
#import "MSCustomerNaviView.h"
#import "NSArray+Expression.h"

@interface SYChoosePetVarietiesViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    NSMutableArray<SYPetBreedModel *> *dataArray;
}
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;

@property(nonatomic, strong) MSTopSearchView *searchView;
/**选中的path*/
@property(nonatomic, strong) NSIndexPath *selectedPath;
@end

@implementation SYChoosePetVarietiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"宠物类型";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithTitle:@"确定" Font:KFont_M(14) titlesColor:KUIColorFromRGB(0x333333) target:self action:@selector(sureAction:)];
    
    self.searchView = [[NSBundle mainBundle]loadNibNamed:@"MSCustomerNaviView" owner:self options:nil][2];
    self.searchView.frame = CGRectMake(0,8, KScreenWidth, 44);
    [self.view addSubview:self.searchView];
    self.searchView.searchTF.backgroundColor = [UIColor whiteColor];
    self.searchView.searchView.backgroundColor = [UIColor whiteColor];
    self.searchView.searchTF.delegate = self;
    self.searchView.searchTF.returnKeyType = UIReturnKeySearch;
    self.mainTableView.frame = CGRectMake(0,CGRectGetMaxY(self.searchView.frame),KScreenWidth, KScreenHeight-KNavBarHeight-KTabBarSafe_Height-CGRectGetMaxY(self.searchView.frame));
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.rowHeight = 50;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.mainTableView];
    [self.mainTableView.mj_header beginRefreshing];
}
- (void)sureAction:(UIButton*)sender{
    if (!self.selectedPath) {
      [self.view makeToast:@"请先选择宠物类型" duration:1.5f position:CSToastPositionCenter];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(choosedPetVarieties:)]) {
        [self.delegate choosedPetVarieties:self.letterResultArr[self.selectedPath.section][self.selectedPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)headerRereshing{
    [self loadData];
}
- (void)footerRereshing{
    [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
}
//加载数据
-(void)loadData{
    
    [ShareRequest shareRequestDataWithAppendURL:@"/pets/pets/get_varieties" Params:@{@"type_id":self.type_id} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        
        NSArray *dataArray = [SYPetBreedModel mj_objectArrayWithKeyValuesArray:dic];
        if (!kStringIsEmpty(self.searchView.searchTF.text)) {
            dataArray = [dataArray filterPredicateContainsWithKeyWord:self.searchView.searchTF.text];
            
        }
        //根据SYPetBreedModel对象的 varieties_name 属性 按中文 对 SYPetBreedModel数组 排序
        self.indexArray = [MSChineseSort IndexWithArray:dataArray Key:@"varieties_name"];
        self.letterResultArr = [MSChineseSort sortObjectArray:dataArray Key:@"varieties_name"];
        
        if (dataArray.count<=0) {
            [self.mainTableView showNoDataStatusWithString:@"暂无宠物类型" imageName:@"" withOfffset:0];
        }
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
    } Fail:^(NSError *error) {
        [self.mainTableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableView -

//section行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.indexArray count];
}
//每组section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.letterResultArr objectAtIndex:section] count];
}
//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}
//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    return index;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LCHealthLivingPopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCHealthLivingPopViewCell"];
    if (!cell) {
        
        cell = [[LCHealthLivingPopViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LCHealthLivingPopViewCell"];
    }
    baseModel *model = self.letterResultArr[indexPath.section][indexPath.row];
    
    if ([model isKindOfClass:[SYPetBreedModel class]]) {
        SYPetBreedModel *breed = (SYPetBreedModel*)model;
        cell.dataLB.text = breed.varieties_name;
    }
    return cell;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 32)];
    
    UILabel *titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 32)];
    titleLB.backgroundColor = [UIColor whiteColor];
    
    titleLB.text = [NSString stringWithFormat:@"    %@",[self.indexArray objectAtIndex:section]];
    titleLB.textColor = KUIColorFromRGB(0x333333);
    titleLB.font = [UIFont fontWithName:@"Copperplate-Bold" size:18];
    titleLB.backgroundColor = KUIColorFromRGB(0xF7F7F7);
    
    if (section ==0) {
        titleLB.textColor = KUIColorFromRGB(0x666666);
        titleLB.font = [UIFont systemFontOfSize:16];
    }
    
    return titleLB;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedPath = indexPath;
}
#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.mainTableView.mj_header beginRefreshing];
}
@end

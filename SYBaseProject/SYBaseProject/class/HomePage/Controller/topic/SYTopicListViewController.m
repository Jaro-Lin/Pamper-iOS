//
//  SYTopicListViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/3/30.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYTopicListViewController.h"
#import "UIView+Extension.h"
#import "SYTopicMomentsViewController.h"
#import "SYHomeManagerHeadView.h"

@interface SYTopicListTableViewCell:UITableViewCell
@property(nonatomic, strong) UIImageView *topicIcon;
@property(nonatomic, strong) UILabel *topicLB;
@property(nonatomic, strong) UILabel *hotLB;
@property(nonatomic, strong) SYTopicModel *topicModel;
@end

@implementation SYTopicListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.topicIcon = [UIImageView createImageViewImageName:@"topic_more" superUIView:self.contentView];
        self.topicLB = [UILabel creatLabelWithTitle:@"每日分享" textColor:KUIColorFromRGB(0x333333) textFont:[UIFont boldSystemFontOfSize:12]];
        [self.contentView addSubview:self.topicLB];
        
        self.hotLB = [UILabel creatLabelWithTitle:@"76.3w热度" textColor:KUIColorFromRGB(0x333333) textFont:[UIFont boldSystemFontOfSize:12]];
        [self.contentView addSubview:self.hotLB];
    }
    return self;
}
- (void)layoutSubviews{
    
    [self.topicIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).mas_offset(10);
        make.width.height.mas_offset(30);
    }];
    
    [self.topicLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.topicIcon.mas_right).mas_offset(10);
        make.width.mas_lessThanOrEqualTo(KScreenWidth-140);
    }];
    
    [self.hotLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).mas_offset(-20);
        
    }];
}
- (void)setTopicModel:(SYTopicModel *)topicModel{
    _topicModel = topicModel;
    
    
    self.topicLB.text = _topicModel.theme_title;
    self.hotLB.text = [NSString stringWithFormat:@"%@ W热度",_topicModel.use_num];
}

@end

@interface SYTopicListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(nonatomic, strong) NSMutableArray *topicArrM;
@property(nonatomic, strong) SYHomeSearchHeadView *serchView;
@end

@implementation SYTopicListViewController

- (NSMutableArray *)topicArrM{
    if (!_topicArrM) {
        _topicArrM = [[NSMutableArray alloc]init];
    }
    return _topicArrM;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (@available(iOS 11.0, *)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.serchView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                make.left.mas_offset(46);
                make.right.mas_equalTo(-24);
            }];
        });
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

     self.serchView = (SYHomeSearchHeadView*)[UIView instancesWithNib:@"SYHomeManagerHeadView" index:3];
      self.serchView.frame = CGRectMake(46, 0, KScreenWidth-46-24,KNavBarHeight);
      self.navigationItem.titleView = self.serchView;
    
    self.mainTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-KNavBarHeight);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.rowHeight = 60;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mainTableView];
   
    self.currrentPage = 1;
    [self.mainTableView.mj_header beginRefreshing];
}

- (void)headerRereshing{
    self.currrentPage = 1;
    [self requestNetWork];
}
- (void)footerRereshing{
     if (self.totalCount == self.topicArrM.count) {
           [self.mainTableView.mj_footer endRefreshing];
           return;
       }
    self.currrentPage ++;
    [self requestNetWork];
    
}
- (void)requestNetWork{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSNumber numberWithInteger:self.currrentPage] forKey:@"page"];
    [params setObject:KLimitCount forKey:@"limit"];
    
    [ShareRequest shareRequestDataWithAppendURL:@"/post/theme/theme" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
        if (self.currrentPage ==1) {
            [self.topicArrM removeAllObjects];
        }
        self.totalCount = [dic[@"total"] integerValue];
        [self.topicArrM addObjectsFromArray:[SYTopicModel mj_objectArrayWithKeyValuesArray:dic[@"list"]]];
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
    } Fail:^(NSError *error) {
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.topicArrM.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SYTopicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYTopicListTableViewCell"];
    if (!cell) {
        
        cell = [[SYTopicListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SYTopicListTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.topicModel = self.topicArrM[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isTopicChoosed) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(topicSelected:)]) {
            [self.delegate topicSelected:self.topicArrM[indexPath.section]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
        
        SYTopicModel *topicModel = self.topicArrM[indexPath.section];
        SYTopicMomentsViewController *topicVC = [[SYTopicMomentsViewController alloc]init];
        topicVC.title = topicModel.theme_title;
        topicVC.themeID = topicModel.ID;
        [self.navigationController pushViewController:topicVC animated:YES];
    }
    
    
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;;
}
@end

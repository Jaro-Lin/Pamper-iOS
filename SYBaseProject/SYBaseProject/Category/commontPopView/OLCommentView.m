//
//  OLCommentView.m
//  OLive
//
//  Created by xiao on 2019/4/13.
//  Copyright © 2019 oldManLive. All rights reserved.
//

#import "OLCommentView.h"
#import "OLCommtTextView.h"
#import "OLCommentCell.h"
#import <MJRefresh/MJRefresh.h>

@interface OLCommentView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)OLCommtTextView *commtTextView;
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)UILabel *commLb;

@property (nonatomic,assign) NSInteger page;
@property(nonatomic, strong) NSMutableArray *commontArrM;
@end

@implementation OLCommentView
- (NSMutableArray *)commontArrM{
    if (!_commontArrM) {
        _commontArrM = [[NSMutableArray alloc]init];
    }
    return _commontArrM;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCommentUI];
        self.backgroundColor =[UIColor whiteColor];
        //获取评论数据
        self.page = 1;
        [self setupRefresh];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    [UIView animateWithDuration:0.3 animations:^{
        _commtTextView.frame = CGRectMake(0, self.height-50-keyboardRect.size.height, self.width, 50);
        
    }];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        _commtTextView.frame = CGRectMake(0, self.height-50, self.width, 50);
        
    }];
    
}
- (void)createCommentUI{
    __weak typeof(self)weakSelf = self;

    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(44);
        make.bottom.equalTo(self.mas_bottom).mas_offset(-50);
    }];
    _commLb = [UILabel new];
    _commLb.textColor = RGB(51, 51, 51);
    _commLb.font = [UIFont systemFontOfSize:15];
    _commLb.text = @"";
    [self addSubview:_commLb];
    [_commLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(14);
        make.centerX.equalTo(self);
    }];
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setImage:[UIImage imageNamed:@"fubo_message_comment_close"] forState:(UIControlStateNormal)];
    [_cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:(UIControlEventTouchUpInside)];
     [self addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(14);
    }];
    _line = [UIView new];
    _line.backgroundColor = RGB(234, 234, 234);
    [self addSubview:_line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.top.equalTo(self).offset(43);
    }];
    
    _commtTextView = [[OLCommtTextView alloc]init];
    [_commtTextView setSendCommentResp:^(NSString * _Nonnull commontStr) {
        //发送评论
        [weakSelf sendCommont:commontStr];
    }];
    [self addSubview:_commtTextView];
    [_commtTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self);
    }];
}

- (void)cancel:(UIButton *)sender{
    
    if (_cancelCommentView) {
        _cancelCommentView();
    }
}

#pragma mark --- 加载网络数据
-(void)setupRefresh{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self loadComment];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page ++;
      
        [self loadComment];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
}

- (void)loadComment{
   
    

    
}
- (void)sendCommont:(NSString*)comStr{
    
//    NSString *collUrl = [URL_DOMAIN stringByAppendingString:@"fvc-addcom"];
//    OLUserModel *model = [OLUserManager user];
//    NSDictionary *param = @{@"access_token":model.access_token,@"fvc_vid":@(self.fvc_vid),@"fvc_content":comStr};
//
//    [HttpsUtils doHttpPost:collUrl header:nil param:param success:^(NSData *data) {
//        NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        if ([resDic[@"error"]integerValue] == 0) {
//            [SVProgressHUD showInfoWithStatus:@"评论成功"];
//
//            [self endEditing:YES];
//            self.page = 1;
//            [self.tableView.mj_header beginRefreshing];
//            self.tableView.mj_header.automaticallyChangeAlpha = YES;
//            //评论成功
//            !self.sendCommentBlock ?:self.sendCommentBlock();
//        }
//    } fail:^(NSError *error) {
//
//    }];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.commontArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OLCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  80;
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"OLCommentCell" bundle:nil] forCellReuseIdentifier:@"commentCell"];
        if (@available(iOS 11,*)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}


@end

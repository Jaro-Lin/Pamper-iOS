//
//  SYCustomTableViewCell.h
//  SYBaseProject
//
//  Created by sy on 2020/3/25.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+MCLabel.h"
#import "SYHomeToolBarView.h"
#import "SYHomeThemeModel.h"

NS_ASSUME_NONNULL_BEGIN
@class SYCustomTableViewCell;

@protocol YjxCustomTableViewCellDelegate <NSObject>

@optional
- (void)clickFoldLabel:(SYCustomTableViewCell *)cell;
- (void)topicBtnClick:(SYCustomTableViewCell *)cell;
- (void)headIconTapClick:(SYCustomTableViewCell *)cell;

- (void)commontAction:(SYCustomTableViewCell *)cell;
- (void)starAction:(SYCustomTableViewCell *)cell;
- (void)collectionAction:(SYCustomTableViewCell *)cell;
- (void)shareAction:(SYCustomTableViewCell *)cell;
- (void)deletedAction:(SYCustomTableViewCell *)cell;
@end

@interface SYCustomTableViewCell : UITableViewCell

@property(nonatomic, strong) UIButton *deletedBtn;

@property(nonatomic, strong)UIImageView *iconImg;
@property(nonatomic, strong)UILabel *nameL;
@property(nonatomic, strong)UILabel *timeL;
@property(nonatomic, strong)UILabel *textContentL;

@property (nonatomic,strong)UICollectionView *collectView;

//@property(nonatomic, strong)UIButton *moreBtn;
@property(nonatomic, strong) UIButton *topicBtn;

@property (nonatomic, weak) id<YjxCustomTableViewCellDelegate> cellDelegate;

//底部工具栏
@property(nonatomic, strong)SYHomeToolBarView *toolbar;
@property(nonatomic, strong) SYHomeThemeModel *momentModel;
//是否需要收起、全文
@property(nonatomic, assign)BOOL isShowFoldBtn;
@end

NS_ASSUME_NONNULL_END

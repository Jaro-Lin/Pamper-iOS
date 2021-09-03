//
//  SYCustomTableViewCell.h
//  SYBaseProject
//
//  Created by sy on 2020/3/25.
//  Copyright © 2020 YYB. All rights reserved.
//


#import "SYCustomTableViewCell.h"
#import "SYCustomCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIColor+YMHex.h"
#import <AVFoundation/AVFoundation.h>

#import "YBImageBrowser.h"
#import "YBIBVideoData.h"

//列数
#define item_num 3
#define pading 10

@interface SYCustomTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,SYHomeToolBarViewDelegate>

@property(nonatomic, strong) UICollectionViewFlowLayout * layout;
@property(nonatomic, strong) NSArray *imagesArr;
@end
@implementation SYCustomTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //折叠效果
        self.isShowFoldBtn = YES;
        self.contentView.userInteractionEnabled = NO;
        
        [self addSubview:self.deletedBtn];
        [self addSubview:self.iconImg];
        [self addSubview:self.nameL];
        [self addSubview:self.timeL];
        [self addSubview:self.textContentL];
        //        [self addSubview:self.moreBtn];
        [self addSubview:self.topicBtn];
        [self addSubview:self.collectView];
        [self addSubview:self.toolbar];
        
        [self.deletedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).mas_offset(3);
            make.right.equalTo(self.mas_right).mas_offset(-15);
            make.height.width.mas_offset(40);
        }];
        
        [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).mas_offset(KAdaptW(15));
            make.top.mas_equalTo(self.mas_top).mas_offset(KAdaptW(10));
            make.height.mas_offset(KAdaptW(38));
            make.width.mas_offset(KAdaptW(38));
        }];
        
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImg.mas_right).mas_offset(KAdaptW(10));
            make.top.mas_equalTo(self.mas_top).mas_offset(KAdaptW(10));
            make.height.mas_offset(KAdaptW(16));
        }];
        
        
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameL.mas_bottom).mas_offset(5);
            make.height.mas_offset(KAdaptW(16));
            make.left.mas_equalTo(self.iconImg.mas_right).mas_offset(KAdaptW(15));
        }];
        
        [self.textContentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).mas_offset(KAdaptW(15));
            make.right.mas_equalTo(self.mas_right).mas_offset(-KAdaptW(10));
            make.top.mas_equalTo(self.iconImg.mas_bottom).mas_offset(KAdaptW(15));
            make.height.mas_equalTo(@1).priorityLow();//设置一个高度，以便赋值后更新
            
        }];
        
        //        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.mas_equalTo(self.mas_left).mas_offset(10);
        //            //            make.right.mas_equalTo(self.mas_right).mas_offset(-10);
        //            make.top.mas_equalTo(self.textContentL.mas_bottom).mas_offset(10);
        //            make.height.mas_equalTo(@20.0);
        //            make.width.mas_equalTo(@40.0);
        //
        //        }];
        
        [self.topicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).mas_offset(15);
            make.top.mas_equalTo(self.textContentL.mas_bottom).mas_offset(2);
            make.height.mas_equalTo(@30.0);
            make.width.mas_equalTo(KScreenWidth/3.0);
            
        }];
        
        //设置子视图与父视图的约束，以便b子视图变化是能“撑”起父视图
        [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.isShowFoldBtn==YES) {
                make.top.mas_equalTo(self.topicBtn.mas_bottom).mas_offset(10);
            }else {
                make.top.mas_equalTo(self.textContentL.mas_bottom).mas_offset(0);
            }
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width-KAdaptW(5)*2);
            make.centerX.equalTo(self.mas_centerX);
            make.height.mas_equalTo(@1).priorityLow();//设置一个高度，以便赋值后更新
        }];
        
        
        //设置子视图与父视图的约束，以便b子视图变化是能“撑”起父视图
        [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.collectView.mas_bottom);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_offset(KAdaptW(39));
            make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        }];
        
    }
    return self;
}
- (void)setMomentModel:(SYHomeThemeModel *)momentModel{
    
    _momentModel = momentModel;
    
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageServer,_momentModel.avatar]] placeholderImage:kPlaceHoldImageUser];
    self.nameL.text = _momentModel.nickname;
    self.timeL.text = [NSString timintervalToTimeStr:kDateFormat_yMd timeInterval:(kStringIsEmpty(_momentModel.post_time)?[_momentModel.add_time integerValue]:[_momentModel.post_time integerValue])];
    self.textContentL.text = _momentModel.content;
    self.imagesArr = (_momentModel.images.count >0 ?_momentModel.images:_momentModel.image);
    //行距 字间距
//    [_textContentL setColumnSpace:2.0];
//    [_textContentL setRowSpace:2.4];
    
    CGFloat itemWidth = (KScreenWidth-KAdaptW(20)*2-KAdaptW(8)*2)/3.0;
    
    if (self.imagesArr.count >0) {
        self.layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        [self reloadCell:self.imagesArr isShowMore:NO showTopicStr:_momentModel.theme_title];
    }
    if (_momentModel.video.count >0){
        self.layout.itemSize = CGSizeMake((KScreenWidth-KAdaptW(20)*2-KAdaptW(8)*2), itemWidth*2);
        [self reloadCell:@[_momentModel.video] isShowMore:NO showTopicStr:_momentModel.theme_title];
    }
    
    //评论，赞收藏数
    [self.toolbar.commontBtn setTitle:_momentModel.comment forState:UIControlStateNormal];
    [self.toolbar.starBtn setTitle:_momentModel.good forState:UIControlStateNormal];
    [self.toolbar.collectionBtn setTitle:_momentModel.collection forState:UIControlStateNormal];
    
    self.toolbar.starBtn.selected = _momentModel.if_good;
    self.toolbar.collectionBtn.selected = _momentModel.if_collection;
    
}
- (void)reloadCell:(NSArray *)imgarr isShowMore:(BOOL)isShowMore showTopicStr:(NSString*)topic{
    
    self.collectView.collectionViewLayout = self.layout;
    //更新collectionView
    [self.collectView reloadData];
    [self.collectView layoutIfNeeded];
    [self.collectView setNeedsLayout];
    
    CGFloat height_pading;
    CGFloat height_collectionview;
    if (imgarr.count > 0) {
        height_pading = 15;
        height_collectionview = self.collectView.collectionViewLayout.collectionViewContentSize.height;
    }else {
        
        height_pading = 0;
        height_collectionview = 5;
    }
    [self.collectView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height_collectionview));
    }];
    
    if (kStringIsEmpty(topic)) {//不显示主题
        self.topicBtn.hidden = YES;
        [self.collectView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.textContentL.mas_bottom).mas_offset(KAdaptW(0));
            make.height.equalTo(@(height_collectionview));
        }];
    }else{
        
        self.topicBtn.hidden = NO;
        [self.topicBtn setTitle:topic forState:UIControlStateNormal];
        [self.collectView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topicBtn.mas_bottom).mas_offset(KAdaptW(0));
            make.height.equalTo(@(height_collectionview));
        }];
    }
    
}
- (void)foldNewsOrNoTap:(UIButton *)recognizer{
    
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(clickFoldLabel:)]) {
        [self.cellDelegate clickFoldLabel:self];
    }
}
- (void)topicClick:(UIButton*)sender{
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(topicBtnClick:)]) {
        [self.cellDelegate topicBtnClick:self];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.imagesArr.count >0) {
        return self.imagesArr.count;
    }else if (self.momentModel.video.count >0){
        return self.momentModel.video.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
    if (self.imagesArr.count >0) {
        [cell.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageServer,self.imagesArr[indexPath.row][@"address"]?:self.imagesArr[indexPath.row][@"image"]]] placeholderImage:kPlaceHoldImage];
        
    }else{//获取视频封面图
        
        cell.img.image =kImageWithName(@"");
        cell.playBtn.hidden = NO;
        cell.playBtn.userInteractionEnabled = NO;
        
        kSelfWeak;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            UIImage *image = [self getThumbnailImage:[NSString stringWithFormat:@"%@%@",KImageServer,weakSelf.momentModel.video[indexPath.row][@"address"]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                cell.img.image = image;
            });
        });
    }
    
    return cell;
}

-(UIImage *)getThumbnailImage:(NSString *)videoURL{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:videoURL] options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = 0.01;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//分别为上、左、下、右
}

//这个是两行cell之间的最小间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return KAdaptW(8);
}
//两个cell之间的最小间距间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return KAdaptW(8);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *datas = [NSMutableArray array];
    
    if (self.imagesArr.count>0) {
        for (int i = 0; i <self.imagesArr.count; i ++) {
            YBIBImageData *data = [YBIBImageData new];
            data.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageServer,self.imagesArr[i][@"address"]?:self.imagesArr[i][@"image"]]];
            data.projectiveView = self;
            [datas addObject:data];
        }
    }else{
        
        YBIBVideoData *data = [YBIBVideoData new];
        data.videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageServer,_momentModel.video[indexPath.row][@"address"]]];
        data.projectiveView = self;
        [datas addObject:data];
    }
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = indexPath.row;
    // 只有一个保存操作的时候，可以直接右上角显示保存按钮
    browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
    [browser show];
}


-(UICollectionView *)collectView{
    if (!_collectView) {
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat itemWidth = (KScreenWidth-KAdaptW(20)*2-KAdaptW(8)*2)/3.0;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        self.layout = layout;
        
        _collectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectView.backgroundColor = [UIColor whiteColor];
        _collectView.delegate=self;
        _collectView.dataSource=self;
        [_collectView registerClass:[SYCustomCollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    }
    return _collectView;
}
- (UIButton *)deletedBtn{
    if (!_deletedBtn) {
        _deletedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deletedBtn setImage:kImageWithName(@"icon_delteted") forState:UIControlStateNormal];
        _deletedBtn.hidden = YES;
        [_deletedBtn addTarget:self action:@selector(deletedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deletedBtn;
}
- (UIImageView *)iconImg {
    if (!_iconImg) {
        
        _iconImg = [[UIImageView alloc] init];
        _iconImg.backgroundColor = [UIColor whiteColor];
        _iconImg.clipsToBounds = YES;
        _iconImg.contentMode=UIViewContentModeScaleAspectFill;
        _iconImg.layer.cornerRadius = KAdaptW(38)/2.0;
        _iconImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapClick)];
        [_iconImg addGestureRecognizer:tap];
    }
    return _iconImg;
}
- (UILabel *)nameL {
    if (!_nameL) {
        _nameL = [[UILabel alloc] init];
        _nameL.font = KFont_M(15);
        _nameL.textColor = KUIColorFromRGB(0x000000);
    }
    return _nameL;
}
- (UILabel *)timeL {
    if (!_timeL) {
        _timeL = [[UILabel alloc] init];
        _timeL.font = [UIFont systemFontOfSize:KAdaptW(12)];
        _timeL.textColor = KUIColorFromRGB(0x000000);
        _timeL.textAlignment = NSTextAlignmentLeft;
        _timeL.adjustsFontSizeToFitWidth = YES;
    }
    return _timeL;
}
- (UILabel *)textContentL {
    if (!_textContentL) {
        _textContentL = [[UILabel alloc] init];
        _textContentL.font = [UIFont systemFontOfSize:15];
        _textContentL.textColor = KUIColorFromRGB(0x000000);
        _textContentL.numberOfLines = 0;
    }
    return _textContentL;
}

//- (UIButton *)moreBtn {
//    if (!_moreBtn) {
//        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightLight)];
//        _moreBtn.backgroundColor = [UIColor whiteColor];
//        [_moreBtn setTitleColor:[UIColor colorWithHexString:@"#1296db"] forState:(UIControlStateNormal)];
//        [_moreBtn addTarget:self action:@selector(foldNewsOrNoTap:) forControlEvents:(UIControlEventTouchUpInside)];
//
//    }
//    return _moreBtn;
//}

- (UIButton *)topicBtn {
    if (!_topicBtn) {
        _topicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topicBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightLight)];
        _topicBtn.backgroundColor = [UIColor whiteColor];
        [_topicBtn setImage:kImageWithName(@"icon_topic") forState:UIControlStateNormal];
        [_topicBtn setTitleColor:[UIColor colorWithHexString:@"#23A0F0"] forState:(UIControlStateNormal)];
        _topicBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_topicBtn addTarget:self action:@selector(topicClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _topicBtn;
}

- (SYHomeToolBarView *)toolbar {
    if (!_toolbar) {
        _toolbar = [[SYHomeToolBarView alloc] init];
        _toolbar.backgroundColor = [UIColor whiteColor];
        _toolbar.btnDelegate = self;
    }
    return _toolbar;
}

//头像点击
- (void)headerTapClick {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(headIconTapClick:)]) {
        [self.cellDelegate headIconTapClick:self];
    }
}
//底部按钮点击代理
#pragma mark -- btnClickedDelegate

- (void)commontAction{
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(commontAction:)]) {
        [self.cellDelegate commontAction:self];
    }
}
- (void)starAction{
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(starAction:)]) {
        [self.cellDelegate starAction:self];
    }
}
- (void)collectionAction{
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(collectionAction:)]) {
        [self.cellDelegate collectionAction:self];
    }
}
- (void)shareAction{
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(shareAction:)]) {
        [self.cellDelegate shareAction:self];
    }
}
- (void)deletedBtnClick:(UIButton*)sender{
   if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(deletedAction:)]) {
       [self.cellDelegate deletedAction:self];
   }
    
}
//获取文字所需行数
- (NSInteger)needLinesWithWidth:(CGFloat)width currentLabel:(UILabel *)currentLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = currentLabel.font;
    NSString *text = currentLabel.text;
    NSInteger sum = 0;
    //加上换行符
    NSArray *rowType = [text componentsSeparatedByString:@"\n"];
    for (NSString *currentText in rowType) {
        label.text = currentText;
        //获取需要的size
        CGSize textSize = [label systemLayoutSizeFittingSize:CGSizeZero];
        NSInteger lines = ceil(textSize.width/width);
        lines = lines == 0 ? 1 : lines;
        sum += lines;
    }
    return sum;
}
@end

//
//  SYJuBaoViewController.h
//  SYBaseProject
//
//  Created by sy on 2020/4/20.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "BaseVC.h"
#import "SYHomeThemeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SYJuBaoViewController : BaseVC
//@property(nonatomic, strong) SYHomeThemeModel *momentModel;
/**举报类型  0-动态  1-评论*/
@property (nonatomic,assign) NSInteger juBaoType;
@property (nonatomic,copy) NSString *post_id;//动态ID
@property (nonatomic,copy) NSString *commont_id;//评论ID
@property(nonatomic, strong) NSString *topTitleStr;//举报对象-用户名/用户的评论
@end

NS_ASSUME_NONNULL_END

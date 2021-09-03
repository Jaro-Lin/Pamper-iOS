//
//  SYMineFollowTableViewCell.m
//  SYBaseProject
//
//  Created by sy on 2020/4/7.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYMineFollowTableViewCell.h"
#import "NSObject+getCurrentViewController.h"

@implementation SYMineFollowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    KViewRadius(self.userHead, 24);
    
}
- (IBAction)followAction:(UIButton *)sender {

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:sender.selected?@"是否要取消关注?":@"是否关注对方?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {            
            [ShareRequest shareRequestDataWithAppendURL:@"/user/about_user/follow" Params:@{@"uid":self.fansCollectionModel.uid} IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
                 sender.selected = !sender.selected;
            } Fail:^(NSError *error) {
                
            }];
            
        }];
        [alertVC addAction:sureAction];
        [alertVC addAction:cancelAction];
        
        [[self getCurrentVC] presentViewController:alertVC animated:YES completion:nil];
}
- (void)setFansCollectionModel:(SYFansCollectionModel *)fansCollectionModel{
    _fansCollectionModel = fansCollectionModel;
    
    [self.userHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_fansCollectionModel.server,_fansCollectionModel.avatar]] placeholderImage:kPlaceHoldImageUser];
    self.userName.text = _fansCollectionModel.nickname;
    self.userInfo.text = _fansCollectionModel.spe;
    self.followBtn.selected = _fansCollectionModel.if_follow;
}
@end

@implementation SYMineCardsTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    [self uploadBGColor];
}

- (void)uploadBGColor{
    
    NSString *bgName = @"";
    NSString *moreName = @"";
    UIColor *useColor = [UIColor blueColor];
    
    self.bgImageView.image = kImageWithName(bgName);
    self.moreImageView.image = kImageWithName(moreName);
    self.userLB.textColor =useColor;
    self.userLB.text = [NSString stringWithFormat:@"%@\n%@",@"点击",@"使用"];
    
}
- (void)setCardType:(cardBGColor)cardType{
    _cardType = cardType;
    
    NSString*careNameStr = @"";
    switch (_cardType) {
        case cardBGColor_red:
            careNameStr = @"cardRed";
            break;
        case cardBGColor_blue:
            careNameStr = @"cardBlue";
            break;
        case cardBGColor_green:
            careNameStr = @"cardGreen";
            break;
        case cardBGColor_orangeColor:
            careNameStr = @"cardOrange";
            break;
        default:
            break;
    }
    self.bgImageView.image = kImageWithName(careNameStr);
    
}
@end

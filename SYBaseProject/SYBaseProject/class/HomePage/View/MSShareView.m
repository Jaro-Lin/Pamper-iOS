//
//  MSShareView.m
//  magicShop
//
//  Created by sy on 2019/11/2.
//  Copyright © 2019 YYB. All rights reserved.
//

#import "MSShareView.h"
#import "WechatPayManager.h"
#import "zhPopupController.h"
#import "NSObject+getCurrentViewController.h"
#import "TWShare.h"
#import <YYKit/UIImage+YYAdd.h>

@interface MSShareView ()

@property (nonatomic,copy) NSString *showType;
@property(nonatomic, strong) NSDictionary *shareDic;
@property(nonatomic, strong) UIImage *iconImage;
@end
@implementation MSShareView
-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.cancelBottomMargin.constant = KTabBarSafe_Height;
    self.backgroundColor = [UIColor whiteColor];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    [[self.weChatBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        if (self.iconImage) {
            [self shareActionToWeChat:0];
        }else{
            [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageServer,self.shareDic[@"icon"]]] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                if (image) {
                    self.iconImage = image;
                    [self shareActionToWeChat:0];
                }
            }];
        }
         [[self getCurrentVC].zh_popupController dismiss];
    }];
    
    [[self.pengyouQuanBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        if (self.iconImage) {
            [self shareActionToWeChat:1];
        }else{
            [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageServer,self.shareDic[@"icon"]]] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                if (image) {
                    self.iconImage = image;
                    [self shareActionToWeChat:1];
                }
            }];
        }
         [[self getCurrentVC].zh_popupController dismiss];
    }];
    
    [[self.QQChatBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        if (self.iconImage) {
            [self shareActionToQQ:0];
        }else{
            [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageServer,self.shareDic[@"icon"]]] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                if (image) {
                    self.iconImage = image;
                    [self shareActionToQQ:0];
                }
            }];
        }
        
        [[self getCurrentVC].zh_popupController dismiss];
    }];
    [[self.QQZoneBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        if (self.iconImage) {
            [self shareActionToQQ:1];
        }else{
            [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageServer,self.shareDic[@"icon"]]] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                if (image) {
                    self.iconImage = image;
                    [self shareActionToQQ:1];
                }
            }];
        }
        
        [[self getCurrentVC].zh_popupController dismiss];
    }];
    
//    [[self.weiboBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
//        [[self getCurrentVC].zh_popupController dismiss];
//    }];
    
    [[self.linkBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x){
      
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"连接已复制，分享给好友去吧！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (!kStringIsEmpty(self.shareDic[@"download"])) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = self.shareDic[@"download"];
            }
        }];

        [alertVC addAction:sureAction];
        [[self getCurrentVC] presentViewController:alertVC animated:YES completion:nil];
  
        [[self getCurrentVC].zh_popupController dismiss];
    }];
    
    
    [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[self getCurrentVC].zh_popupController dismiss];
    }];
}

//type 0-微信 1-朋友圈
- (void)shareActionToWeChat:(int)type{
    
    
    OSMessage *message = [[OSMessage alloc] init];
    message.title = self.shareDic[@"title"];
    UIImage *image = [self.iconImage imageByResizeToSize:CGSizeMake(100, 100) contentMode:UIViewContentModeScaleAspectFill];
   
    message.image = UIImageJPEGRepresentation(image, 1.0);
    message.thumbnail = UIImageJPEGRepresentation(image, 0.1);
    message.desc = self.shareDic[@"content"];
    message.link = self.shareDic[@"download"];

    [TWShare shareMessage:message withShareType:(type ==0 ?TWSNSShareTypeWXSceneSession:TWSNSShareTypeWXSceneTimeline) completionHandler:^(OSMessage *message, NSError *error) {
        
    }];
    
//    [[WechatPayManager shareManager]sharedMsgTo:type title:self.shareDic[@"title"] description:self.shareDic[@"content"] image:self.iconImage url:self.shareDic[@"download"] callbac:^(int code, NSString *message) {
//
//    }];
}
//type 0-qq好友 1-空间
- (void)shareActionToQQ:(int)type{
    
    OSMessage *message = [[OSMessage alloc] init];
    message.title = self.shareDic[@"title"];
    message.image = UIImageJPEGRepresentation(self.iconImage, 1.0);
    message.thumbnail = UIImageJPEGRepresentation(self.iconImage, 0.1);
    message.desc = self.shareDic[@"content"];
    message.link = self.shareDic[@"download"];

    [TWShare shareMessage:message withShareType:(type ==0 ?TWSNSShareTypeQQ:TWSNSShareTypeQQZone) completionHandler:^(OSMessage *message, NSError *error) {
        
    }];
}

- (void)showPopView:(NSString *)showType{
    
    _showType = showType;
    [self getShareContent];//获取分享内容
    
    self.frame = CGRectMake(0, 0, KScreenWidth, 220+KTabBarSafe_Height);
    [self getCurrentVC].zh_popupController = [zhPopupController popupControllerWithMaskType:zhPopupMaskTypeBlackTranslucent];
    [self getCurrentVC].zh_popupController.slideStyle = zhPopupSlideStyleFromBottom;
    [self getCurrentVC].zh_popupController.layoutType = zhPopupLayoutTypeBottom;
//    [self getCurrentVC].zh_popupController.dismissOnMaskTouched = NO;
    [[self getCurrentVC].zh_popupController presentContentView:self];
}

- (void)dismissPopView{
    [[self getCurrentVC].zh_popupController dismiss];
}

- (void)getShareContent{
    
    [ShareRequest shareRequestDataWithAppendURL:@"/post/post_about/share" Params:@{@"type":self.showType} IsShowHud:NO IsInteract:NO Complete:^(NSDictionary *dic) {
        self.shareDic = dic;
        [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageServer,dic[@"icon"]]] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (image) {
                self.iconImage = image;
            }
        }];
        
    } Fail:^(NSError *error) {
        
    }];
}

@end


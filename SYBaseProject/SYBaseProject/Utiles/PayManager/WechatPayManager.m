//
//  WechatPayManager.m
//  DuoBao
//
//  Created by tanson on 2018/2/1.
//  Copyright © 2018年 tanson. All rights reserved.
//

#import "WechatPayManager.h"
#import <YYKit/UIImage+YYAdd.h>

@interface WechatPayManager()

@property (nonatomic,copy) void (^payCallBack)(int errCode,NSString *eMsg);

@property (nonatomic,copy) void (^msgCallBack)(int errCode,NSString *eMsg);

@end

@implementation WechatPayManager

+(instancetype)shareManager{
    
    static dispatch_once_t onceToken;
    static WechatPayManager * ins;
    dispatch_once(&onceToken, ^{
        ins = [WechatPayManager new];
    });
    return ins;
}

+(BOOL)isWXAppInstalled{
    return [WXApi isWXAppInstalled];
}

-(BOOL)payWithSignData:(NSDictionary *)data payCallback:(void (^)(int, NSString *))payCallback{
    _payCallBack = payCallback;
    
    NSString *partnerId = data[@"partnerid"];
    if([partnerId isKindOfClass:[NSNull class]]) {
        partnerId = @"";
    }
    
    NSString *nonceStr = data[@"noncestr"];
    if([nonceStr isKindOfClass:[NSNull class]]) {
        nonceStr = @"";
    }
                          
    NSString *prepayId = data[@"prepayid"];
    if([prepayId isKindOfClass:[NSNull class]]) {
        prepayId = @"";
    }
    
    NSString *paySign = data[@"sign"];
    if([paySign isKindOfClass:[NSNull class]]) {
        paySign = @"";
    }
    
    PayReq *req = [[PayReq alloc] init];
    req.partnerId  = partnerId;
    req.prepayId   = prepayId;
    req.package    = data[@"package"];
    req.nonceStr   = nonceStr;
    req.timeStamp  = [data[@"timestamp"] unsignedIntValue];
    req.sign       = paySign;
    
//    LOG(@"微信支付调用:%d",[WXApi sendReq:req]);
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
    return YES;
}

-(BOOL)sharedMiniProjectTo:(int)type
                     title:(NSString*)title
               description:(NSString*)description
                  userName:(NSString *)userName
                      path:(NSString *)path
                       url:(NSString*)url
                     imageData:(NSData*)imageData
                   callbac:(void (^)(int, NSString *))callback {
    _msgCallBack = callback;
    
    WXMediaMessage *msg = [WXMediaMessage message];
    msg.title = title;
    msg.description = description;
    
    WXMiniProgramObject * obj = [WXMiniProgramObject object];
    obj.webpageUrl = url;
    obj.userName = userName;
    obj.path = path;
    obj.hdImageData = imageData;
    obj.miniProgramType = 0;
    msg.mediaObject = obj;
    
    SendMessageToWXReq * req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = msg;
    req.scene = type;
    
     [WXApi sendReq:req completion:nil];
    return YES;
}

-(BOOL) sharedMsgTo:(int)type
              title:(NSString*)title
        description:(NSString*)description
              image:(UIImage*)image
                url:(NSString*)url
            callbac:(void (^)(int, NSString *))callback{
    
    _msgCallBack = callback;
    
    WXMediaMessage *msg = [WXMediaMessage message];
    msg.title = title;
    msg.description = description;
    image = [image imageByResizeToSize:CGSizeMake(100, 100) contentMode:UIViewContentModeScaleAspectFill];
    [msg setThumbImage:image];

    WXWebpageObject * webObj = [WXWebpageObject object];
    webObj.webpageUrl = url;
    msg.mediaObject = webObj;
    
    SendMessageToWXReq * req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = msg;
    req.scene = type;
    [WXApi sendReq:req completion:nil];
    
    return YES;
}

-(BOOL) sharedMsgTo:(int)type
              title:(NSString*)title
        description:(NSString*)description
              imageUrl:(NSString*)imageUrl
                url:(NSString*)url
            callbac:(void (^)(int, NSString *))callback{
    
    _msgCallBack = callback;
    
    WXMediaMessage *msg = [WXMediaMessage message];
    msg.title = title;
    msg.description = description;
//    image = [image imageByResizeToSize:CGSizeMake(100, 100) contentMode:UIViewContentModeScaleAspectFill];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    UIImage *image = [UIImage imageWithData:imageData];
    image = [image imageByResizeToSize:CGSizeMake(30, 30) contentMode:UIViewContentModeScaleAspectFill];
    [msg setThumbImage:image];
    
    WXWebpageObject * webObj = [WXWebpageObject object];
    webObj.webpageUrl = url;
    msg.mediaObject = webObj;
    
    SendMessageToWXReq * req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = msg;
    req.scene = type;
     [WXApi sendReq:req completion:nil];
    return YES;
}

-(BOOL)sharedMiniProjectTo:(int)type
                  userName:(NSString *)userName
                      path:(NSString *)path
                     image:(UIImage*)image {
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = userName;  //拉起的小程序的username
    launchMiniProgramReq.path = path;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
    launchMiniProgramReq.miniProgramType = type; //拉起小程序的类型
     [WXApi sendReq:launchMiniProgramReq completion:nil];
    return  YES;
}

/*
-(BOOL)sendAuthReq{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"com.yipingaudio.audioLive";
    return [WXApi sendReq:req];
}
*/

#pragma mark - WXApiDelegate

- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) { //分享到微信和朋友圈
        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;
        if(response.errCode == WXSuccess){
            if (self.msgCallBack) {
                 self.msgCallBack(0,@"");
            }
        }else{
            self.msgCallBack(response.errCode, response.errStr);
        }
        self.msgCallBack = nil;
        
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {// 微信授权
        if (resp.errCode == WXSuccess) {
//            NSNotification *notification = [NSNotification notificationWithName:NOTIFICATION_WX_AUTH_SUCCESS object:resp];
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
    } else if([resp isKindOfClass:[PayResp class]]){
        
        PayResp * response = (PayResp*)resp;
        if(response.errCode == WXSuccess){ //服务器端查询支付通知或查询API返回的结果再提示成功
            self.payCallBack(0,nil);
        }else{
            if(self.payCallBack){
                self.payCallBack(resp.errCode, [NSString stringWithFormat:@"支付失败"]);
            }
        }
        self.payCallBack = nil;
    }
}

- (void)onReq:(BaseReq *)req {
    
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
    }
}

@end

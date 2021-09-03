//
//  WechatPayManager.h
//  DuoBao
//
//  Created by tanson on 2018/2/1.
//  Copyright © 2018年 tanson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface WechatPayManager : NSObject<WXApiDelegate>

+(instancetype) shareManager;
+(BOOL) isWXAppInstalled;

//支付
-(void) payWithSignData:(NSDictionary*)data
            payCallback:(void (^)(int errCode,NSString *eMsg))payCallback;

//分享 会话(WXSceneSession)  朋友圈(WXSceneTimeline）
-(BOOL)sharedMiniProjectTo:(int)type
                     title:(NSString*)title
               description:(NSString*)description
                  userName:(NSString *)userName
                      path:(NSString *)path
                       url:(NSString*)url
                 imageData:(NSData*)imageData
                   callbac:(void (^)(int, NSString *))callback;

-(BOOL) sharedMsgTo:(int)type
              title:(NSString*)title
        description:(NSString*)description
              image:(UIImage*)image
                url:(NSString*)url
            callbac:(void (^)(int code, NSString * eMsg))callback;

-(BOOL) sharedMsgTo:(int)type
              title:(NSString*)title
        description:(NSString*)description
           imageUrl:(NSString*)imageUrl
                url:(NSString*)url
            callbac:(void (^)(int, NSString *))callback;

-(BOOL) sharedMiniProjectTo:(int)type
                      userName:(NSString *)userName
                       path:(NSString *)path
                      image:(UIImage*)image;

@end

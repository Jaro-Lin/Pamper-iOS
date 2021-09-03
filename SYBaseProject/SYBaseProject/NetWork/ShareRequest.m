//
//  ShareRequest.m
//  QinzBaseProject
//
//  Created by Qinz on 2017/4/10.
//  Copyright © 2017年 Qinz. All rights reserved.
//


#import "ShareRequest.h"
#import "SVProgressHUD.h"
#import "BaseHttpRequest.h"
#import "UIApplication+JKNetworkActivityIndicator.h"
#import "AFNetworking.h"
#import "MSUserInformation.h"
#import "SYLogManagerViewController.h"
#import "baseNavigationController.h"

static NSInteger state;
static NSString *message;
static NSInteger num;

@implementation ShareRequest

+(void)shareRequestDataWithAppendURL:(NSString *)url Params:(NSDictionary *)params IsShowHud:(BOOL)isShowHud IsInteract:(BOOL)isInteract Complete:(void(^)(NSDictionary *dic))completeBlock Fail:(void (^)(NSError *error))failBlock{
    
    params = [self setTokenParam:params];
    
    [[UIApplication sharedApplication] jk_beganNetworkActivity];
    
    if (isShowHud) {
        //        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        if (isInteract) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        }else{
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        }
        [SVProgressHUD show];
        /*   ====== 显示gif加载动画用下面这段代码 ====== */
        //[SVProgressHUD showImage:[UIImage sd_animatedGIFNamed:@"pika"] status:nil];
    }
    
    //设置请求头
    //    [self setHTTPHeader];
    
    [BaseHttpRequest POST:[NSString stringWithFormat:@"%@%@",requestServerURL,url] Parameters:params success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        
        [[UIApplication sharedApplication] jk_endedNetworkActivity];
        
        num = 0;
        LOG(@"\n😊请求的地址为😊:\n————————————————————————————————————————————————\n%@%@\n————————————————————————————————————————————————",requestServerURL,url);
        //展示传递给后台的参数
        LOG(@"🌴传递给后台的参数为🌴:\n************************************************\n");
        
        if (params == nil) {
            LOG(@"没⃣有⃣传⃣递⃣任⃣何⃣参⃣数⃣");
        }
        num = 0;
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            LOG(@"第%ld个参数为:%@=%@", num,key, obj);
            num++;
        }];
        LOG(@"\n************************************************");
        
        LOG(@"🍻请求返回的数据🍻:\n=================================================\n%@\n=================================================",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        id result =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
//            [[UIApplication sharedApplication].keyWindow makeToast:result[@"message"] ?:result[@"msg"]];
            
            if ([result[@"code"] integerValue] == 1) { //请求成功
                completeBlock(result[@"data"]);
            }else{
                
                if ([result[@"code"] integerValue] == 101){ //token失效 重新登录
                    [self loginAgain];
                }else{
                    failBlock([NSError new]);
                    [[UIApplication sharedApplication].keyWindow makeToast:result[@"message"] duration:1.5f position:CSToastPositionCenter];
                }
            }
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] jk_endedNetworkActivity];
        failBlock(error);
        [[UIApplication sharedApplication].keyWindow makeToast:error.localizedDescription duration:1.5f position:CSToastPositionCenter];
        
        LOG(@"%@----error",error);
    }];
}

/** 自动缓存网络请求 */
+ (void)autoShareRequestDataWithAppendURL:(NSString *)url Params:(NSDictionary *)params IsShowHud:(BOOL)isShowHud IsInteract:(BOOL)isInteract ResponseCache:(void(^)(NSDictionary *cacheDic))responseCacheBlcok Complete:(void(^)(NSDictionary *dic))completeBlock Fail:(void (^)(NSError *error))failBlock{
    
    params = [self setTokenParam:params];
    
    [[UIApplication sharedApplication] jk_beganNetworkActivity];
    
    if (isShowHud) {
        //         [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        if (isInteract) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        }else{
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        }
        [SVProgressHUD show];
        /*   ====== 显示gif加载动画用下面这段代码 ====== */
        //[SVProgressHUD showImage:[UIImage sd_animatedGIFNamed:@"pika"] status:nil];
    }
    
    //设置请求头
    [self setHTTPHeader];
    
    [BaseHttpRequest POST:[NSString stringWithFormat:@"%@%@",requestServerURL,url] parameters:params responseCache:^(id responseCache) {
        
        [SVProgressHUD dismiss];
        
        id result =[NSJSONSerialization JSONObjectWithData:responseCache options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            id cachedata = [result valueForKey:@"data"];
            if ([cachedata isKindOfClass:[NSDictionary class]]) {
                message = [cachedata valueForKey:@"message"];
                state = [[cachedata valueForKey:@"state"] integerValue];
                if (state == 0) {
                    responseCacheBlcok(cachedata);
                }
            }
        }
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] jk_endedNetworkActivity];
        num = 0;
        LOG(@"\n😊请求的地址为😊:\n————————————————————————————————————————————————\n%@%@\n————————————————————————————————————————————————",requestServerURL,url);
        //展示传递给后台的参数
        LOG(@"🌴传递给后台的参数为🌴:\n************************************************\n");
        
        if (params == nil) {
            LOG(@"没⃣有⃣传⃣递⃣任⃣何⃣参⃣数⃣");
        }
        num = 0;
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            LOG(@"第%ld个参数为:%@=%@", num,key, obj);
            num++;
        }];
        LOG(@"\n************************************************");
        
        LOG(@"🍻请求返回的数据🍻:\n=================================================\n%@\n=================================================",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        id result =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            [[UIApplication sharedApplication].keyWindow makeToast:result[@"message"] ?:result[@"msg"]];
            if ([result[@"code"] integerValue] == 1) { //请求成功
                completeBlock(result[@"data"]);
                
            }else{
                
                if ([result[@"code"] integerValue] == 101){ //token失效 重新登录
                    [self loginAgain];
                    
                }else{
                    failBlock([NSError new]);
                    [[UIApplication sharedApplication].keyWindow makeToast:result[@"message"] duration:1.5f position:CSToastPositionCenter];
                }
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] jk_endedNetworkActivity];         failBlock(error);
    }];
}


+(void)uploadImg:(UIImage *)image appendURL:(NSString *)url IsShowHud:(BOOL)isShowHud IsInteract:(BOOL)isInteract Complete:(void(^)(NSDictionary *dic))completeBlock Fail:(void (^)(NSError *error))failBlock{
    
    if (isShowHud) {
        
        if (isInteract) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        }else{
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        }
        [SVProgressHUD show];
    }
    [[UIApplication sharedApplication] jk_beganNetworkActivity];
    [BaseHttpRequest uploadImagesWithURL:[NSString stringWithFormat:@"%@%@",requestServerURL,url] parameters:nil name:@"file" images:@[image] fileNames:@[] imageScale:0.8 imageType:@"" progress:^(NSProgress *progress) {
       
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] jk_endedNetworkActivity];
        
        //上传成功
        NSDictionary * resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        completeBlock(resultDic);
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] jk_endedNetworkActivity];
        //上传失败
        failBlock(error);
    }];
}

+(void)shareRequestUploadFileappendURL:(NSString *)url parameters:(id)parameters filePath:(NSString *)filePath fileName:(NSString*)name IsShowHud:(BOOL)isShowHud IsInteract:(BOOL)isInteract progress:(void(^)(NSProgress *progress))progressBlcock Complete:(void(^)(NSDictionary *dic))completeBlock Fail:(void (^)(NSError *error))failBlock{
    
    if (isShowHud) {
        if (isInteract) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        }else{
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        }
        [SVProgressHUD show];
    }
    [[UIApplication sharedApplication] jk_beganNetworkActivity];
    [BaseHttpRequest uploadFileWithURL:[NSString stringWithFormat:@"%@%@",requestServerURL,url] parameters:parameters name:name?:@"file" filePath:filePath progress:^(NSProgress *progress) {
         progressBlcock(progress);
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
               [[UIApplication sharedApplication] jk_endedNetworkActivity];
               
               //上传成功
               NSDictionary * resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
               completeBlock(resultDic);
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
               [[UIApplication sharedApplication] jk_endedNetworkActivity];
               //上传失败
               failBlock(error);
    }];
}
#pragma mark - 获取imei
+(NSString *) imei
{
    NSUUID* uuid = [[UIDevice currentDevice] identifierForVendor];
    return [uuid UUIDString];
}

#pragma mark - 获取时间戳
+(NSString*) time_stamp
{
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    return timeSp;
}

+(void)shareRequestGetDataWithAppendURL:(NSString *)url Params:(NSDictionary *)params IsShowHud:(BOOL)isShowHud IsInteract:(BOOL)isInteract Complete:(void(^)(NSDictionary *dic))completeBlock Fail:(void (^)(NSError *error))failBlock{
    
    params = [self setTokenParam:params];
    
    [[UIApplication sharedApplication] jk_beganNetworkActivity];
    
    if (isShowHud) {
        //         [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        if (isInteract) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        }else{
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        }
        [SVProgressHUD show];
    }
    
    //设置请求头
    [self setHTTPHeader];
    
    [BaseHttpRequest GET:[NSString stringWithFormat:@"%@%@",requestServerURL,url] parameters:(id)params success:^(id responseObject) {
        
        NSLog(@"responseObject ===%@",responseObject);
        
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] jk_endedNetworkActivity];
        
        num = 0;
        LOG(@"\n😊请求的地址为😊:\n————————————————————————————————————————————————\n%@%@\n————————————————————————————————————————————",requestServerURL,url);
        //展示传递给后台的参数
        LOG(@"🌴传递给后台的参数为🌴:\n************************************************\n");
        
        if (params == nil) {
            LOG(@"没⃣有⃣传⃣递⃣任⃣何⃣参⃣数⃣");
        }
        num = 0;
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            LOG(@"第%ld个参数为:%@=%@", (long)num,key, obj);
            num++;
        }];
        LOG(@"\n************************************************");
        
        LOG(@"🍻请求返回的数据🍻:\n==========================\n%@\n================================",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        id result =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"responseObject ===%@",result);
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            [[UIApplication sharedApplication].keyWindow makeToast:result[@"message"] ?:result[@"msg"]];
            if ([result[@"code"] integerValue] == 1) { //请求成功
                completeBlock(result);
                return ;
            }else{
                
                if ([result[@"code"] integerValue] == 101){ //token失效 重新登录
                    [self loginAgain];
                }else{
                    failBlock([NSError new]);
                    [[UIApplication sharedApplication].keyWindow makeToast:result[@"message"] duration:1.5f position:CSToastPositionCenter];
                }
                
            }
        }
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] jk_endedNetworkActivity];
        failBlock(error);
        //lsq
        [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接错误"];
        
        LOG(@"%@----error",error);
        
    }];
}

+(void)shareRequestDeleteDataWithAppendURL:(NSString *)url Params:(NSDictionary *)params IsShowHud:(BOOL)isShowHud IsInteract:(BOOL)isInteract Complete:(void(^)(NSDictionary *dic))completeBlock Fail:(void (^)(NSError *error))failBlock
{
    params = [self setTokenParam:params];
    [[UIApplication sharedApplication] jk_beganNetworkActivity];
    
    if (isShowHud) {
        //         [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        if (isInteract) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        }else{
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        }
        [SVProgressHUD show];
        /*   ====== 显示gif加载动画用下面这段代码 ====== */
        //[SVProgressHUD showImage:[UIImage sd_animatedGIFNamed:@"pika"] status:nil];
    }
    
    //设置请求头
    [self setHTTPHeader];
    //设置请求参数放在body里面
    [BaseHttpRequest setParamTypeInBody];
    
    [BaseHttpRequest DELETE:[NSString stringWithFormat:@"%@%@",requestServerURL,url] parameters:params success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        
        [[UIApplication sharedApplication] jk_endedNetworkActivity];
        
        num = 0;
        LOG(@"\n😊请求的地址为😊:\n————————————————————————————————————————————————\n%@%@\n————————————————————————————————————————————————",requestServerURL,url);
        //展示传递给后台的参数
        LOG(@"🌴传递给后台的参数为🌴:\n************************************************\n");
        
        if (params == nil) {
            LOG(@"没⃣有⃣传⃣递⃣任⃣何⃣参⃣数⃣");
        }
        num = 0;
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            LOG(@"第%ld个参数为:%@=%@", num,key, obj);
            num++;
        }];
        LOG(@"\n************************************************");
        
        LOG(@"🍻请求返回的数据🍻:\n=================================================\n%@\n=================================================",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        id result =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            [[UIApplication sharedApplication].keyWindow makeToast:result[@"message"] ?:result[@"msg"]];
            if ([result[@"code"] integerValue] == 1) { //请求成功
                completeBlock(result[@"data"]);
            }else{
                
                if ([result[@"code"] integerValue] == 101){ //token失效 重新登录
                    [self loginAgain];
                    
                }else{
                    failBlock([NSError new]);
                    [[UIApplication sharedApplication].keyWindow makeToast:result[@"message"] duration:1.5f position:CSToastPositionCenter];
                }
            }
        }
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] jk_endedNetworkActivity];
        failBlock(error);
        
        LOG(@"%@----error",error);
    }];
}

+(void)shareRequestPUTDataWithAppendURL:(NSString *)url Params:(NSDictionary *)params IsShowHud:(BOOL)isShowHud IsInteract:(BOOL)isInteract Complete:(void(^)(NSDictionary *dic))completeBlock Fail:(void (^)(NSError *error))failBlock
{
    params = [self setTokenParam:params];
    [[UIApplication sharedApplication] jk_beganNetworkActivity];
    
    if (isShowHud) {
        //             [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        if (isInteract) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        }else{
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        }
        [SVProgressHUD show];
        /*   ====== 显示gif加载动画用下面这段代码 ====== */
        //[SVProgressHUD showImage:[UIImage sd_animatedGIFNamed:@"pika"] status:nil];
    }
    
    //设置请求头
    [self setHTTPHeader];
    
    num = 0;
    LOG(@"\n😊请求的地址为😊:\n————————————————————————————————————————————————\n%@%@\n————————————————————————————————————————————————",requestServerURL,url);
    //展示传递给后台的参数
    LOG(@"🌴传递给后台的参数为🌴:\n************************************************\n");
    
    if (params == nil) {
        LOG(@"没⃣有⃣传⃣递⃣任⃣何⃣参⃣数⃣");
    }
    num = 0;
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        LOG(@"第%ld个参数为:%@=%@", num,key, obj);
        num++;
    }];
    LOG(@"\n************************************************");
    
    
    [BaseHttpRequest PUT:[NSString stringWithFormat:@"%@%@",requestServerURL,url] parameters:params success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        
        [[UIApplication sharedApplication] jk_endedNetworkActivity];
        
        
        LOG(@"🍻请求返回的数据🍻:\n=================================================\n%@\n=================================================",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        id result =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            [[UIApplication sharedApplication].keyWindow makeToast:result[@"message"] ?:result[@"msg"]];
            if ([result[@"code"] integerValue] == 1) { //请求成功
                completeBlock(result[@"data"]);
                
            }else{
                
                if ([result[@"code"] integerValue] == 101){ //token失效 重新登录
                    [self loginAgain];
                    
                }else{
                    failBlock([NSError new]);
                }
            }
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] jk_endedNetworkActivity];
        failBlock(error);
        
        LOG(@"%@----error",error);
    }];
    
    
}



+ (void)shareRequestDownloadWithURL:(NSString *)URL
                          IsShowHud:(BOOL)isShowHud
                         IsInteract:(BOOL)isInteract
                            fileDir:(NSString*)fileDir
                           progress:(void(^)(NSProgress *progress))progressBlcock
                            success:(void(^)(NSString *filePath))success
                            failure:(void(^)( NSError*error))failure
{
    /* 下载路径 */
    
    [[UIApplication sharedApplication] jk_beganNetworkActivity];
    
    if (isShowHud) {
        //         [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        if (isInteract) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        }else{
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        }
        [SVProgressHUD show];
        /*   ====== 显示gif加载动画用下面这段代码 ====== */
        //[SVProgressHUD showImage:[UIImage sd_animatedGIFNamed:@"pika"] status:nil];
    }
    
    [BaseHttpRequest downloadWithURL:URL fileDir:fileDir progress:^(NSProgress *progress) {
        
        progressBlcock(progress);
        
    } success:^(NSString *filePath) {
        
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] jk_endedNetworkActivity];
        success(filePath);
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] jk_endedNetworkActivity];
        failure(error);
        
    }];
}

+ (void)setHTTPHeader{
    
    /// 设置请求数据为JSON格式
    [BaseHttpRequest setRequestSerializer:YSRequestSerializerJSON];
    
    if (!kStringIsEmpty([MSUserInformation sharedManager].user.token)) { //加入请求头
        [BaseHttpRequest setValue:[MSUserInformation sharedManager].user.token forHTTPHeaderField:@"token"];
        LOG(@"______token=%@",[MSUserInformation sharedManager].user.token);
    }
}
//固定增加token参数
+ (NSDictionary*)setTokenParam:(NSDictionary*)param{
    
    NSMutableDictionary *parames = [[NSMutableDictionary alloc]init];
    [parames addEntriesFromDictionary:param];
    
    if (!kStringIsEmpty([MSUserInformation sharedManager].user.token)) { //加入token
        [parames setObject:[MSUserInformation sharedManager].user.token forKey:@"token"];
//        [parames setObject:@"33iUii1Ym6GB22ExZoMOHa52vXMfWQoa" forKey:@"token"];
    }
    return [parames copy];
}

+ (void)cancelAllRequest{
    [BaseHttpRequest cancelAllRequest];
}

+(void)loginAgain{
    
    [[UIApplication sharedApplication].keyWindow makeToast:@"请重新登录" duration:1.5f position:CSToastPositionCenter];
    //清空本地token
    [[MSUserInformation sharedManager]clearUser];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[baseNavigationController alloc]initWithRootViewController:[SYLogManagerViewController new]];
}



@end

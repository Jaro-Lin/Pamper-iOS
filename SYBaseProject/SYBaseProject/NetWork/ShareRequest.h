//
//  ShareRequest.h
//  QinzBaseProject
//
//  Created by Qinz on 2017/4/10.
//  Copyright © 2017年 Qinz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShareRequest : NSObject

/**
  无缓存网络请求-POST
 @param url 请求URL后缀
 @param params 请求参数
 @param isShowHud 是否显示加载指示器
 @param isInteract 是否允许用户交互
 @param completeBlock 成功回调
 @param failBlock 失败回调
 */
+(void)shareRequestDataWithAppendURL:(NSString *)url Params:(NSDictionary *)params IsShowHud:(BOOL)isShowHud IsInteract:(BOOL)isInteract Complete:(void(^)(NSDictionary *dic))completeBlock Fail:(void (^)(NSError *error))failBlock;


/**
 自动缓存网络请求-POST
 @param url 请求URL后缀
 @param params 请求参数
 @param isShowHud 是否显示加载指示器
 @param isInteract 是否允许用户交互
 @param responseCacheBlcok 获取缓存数据的回调
 @param completeBlock 成功回调
 @param failBlock 失败回调
 */
+ (void)autoShareRequestDataWithAppendURL:(NSString *)url Params:(NSDictionary *)params IsShowHud:(BOOL)isShowHud IsInteract:(BOOL)isInteract ResponseCache:(void(^)(NSDictionary *cacheDic))responseCacheBlcok Complete:(void(^)(NSDictionary *dic))completeBlock Fail:(void (^)(NSError *error))failBlock;


/**
 无缓存网络请求-GET
 @param url 请求URL后缀
 @param params 请求参数
 @param isShowHud 是否显示加载指示器
 @param isInteract 是否允许用户交互
 @param completeBlock 成功回调
 @param failBlock 失败回调
 */
+(void)shareRequestGetDataWithAppendURL:(NSString *)url Params:(NSDictionary *)params IsShowHud:(BOOL)isShowHud IsInteract:(BOOL)isInteract Complete:(void(^)(NSDictionary *dic))completeBlock Fail:(void (^)(NSError *error))failBlock;

/**
 无缓存网络请求-Delete
 @param url 请求URL后缀
 @param params 请求参数
 @param isShowHud 是否显示加载指示器
 @param isInteract 是否允许用户交互
 @param completeBlock 成功回调
 @param failBlock 失败回调
 */
+(void)shareRequestDeleteDataWithAppendURL:(NSString *)url Params:(NSDictionary *)params IsShowHud:(BOOL)isShowHud IsInteract:(BOOL)isInteract Complete:(void(^)(NSDictionary *dic))completeBlock Fail:(void (^)(NSError *error))failBlock;

/**
 无缓存网络请求-PUT
 @param url 请求URL后缀
 @param params 请求参数
 @param isShowHud 是否显示加载指示器
 @param isInteract 是否允许用户交互
 @param completeBlock 成功回调
 @param failBlock 失败回调
 */
+(void)shareRequestPUTDataWithAppendURL:(NSString *)url Params:(NSDictionary *)params IsShowHud:(BOOL)isShowHud IsInteract:(BOOL)isInteract Complete:(void(^)(NSDictionary *dic))completeBlock Fail:(void (^)(NSError *error))failBlock;


/**
 上传图片（单张）
 @param image 图片资源（NSData）
 @param isShowHud 是否显示加载指示器
 @param isInteract 是否允许用户交互
 @param completeBlock 成功回调
 @param failBlock 失败回调
 */
+(void)uploadImg:(UIImage *)image appendURL:(NSString *)url IsShowHud:(BOOL)isShowHud IsInteract:(BOOL)isInteract Complete:(void(^)(NSDictionary *dic))completeBlock Fail:(void (^)(NSError *error))failBlock;

/// 上传文件 图片-视频
/// @param parameters 参数，可为空
/// @param filePath 文件本地路径
/// @param name          后台文件路径
/// @param isShowHud 是否显示加载指示器
/// @param isInteract 是否允许用户交互
/// @param completeBlock 成功回调
/// @param failBlock 失败回调
+(void)shareRequestUploadFileappendURL:(NSString *)url parameters:(id)parameters filePath:(NSString *)filePath fileName:(NSString*)name IsShowHud:(BOOL)isShowHud IsInteract:(BOOL)isInteract progress:(void(^)(NSProgress *progress))progressBlcock Complete:(void(^)(NSDictionary *dic))completeBlock Fail:(void (^)(NSError *error))failBlock;

/**
 下载文件
  @param URL 请求完整地址
 @param fileDir 文件存储目录(默认存储目录为Download)
 @param progressBlcock 文件下载的进度信息
 @param success 下载成功的回调(回调参数filePath:文件的路径)
 @param failure 下载失败的回调
 */
+ (void)shareRequestDownloadWithURL:(NSString *)URL
                          IsShowHud:(BOOL)isShowHud
                         IsInteract:(BOOL)isInteract
                            fileDir:(NSString*)fileDir
                              progress:(void(^)(NSProgress *progress))progressBlcock
                               success:(void(^)(NSString *filePath))success
                               failure:(void(^)(NSError*error))failure;


+ (void)cancelAllRequest;


@end

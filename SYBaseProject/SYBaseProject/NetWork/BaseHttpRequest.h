//
//  BaseHttpRequest.h
//  BaseProject
//
//  Created by Qinz on 2017/11/28.
//  Copyright © 2017年 Qinz. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KReuqstOutTime  30

typedef NS_ENUM(NSUInteger, YSNetworkStatusType) {
    /// 未知网络
    YSNetworkStatusUnknown,
    /// 无网络
    YSNetworkStatusNotReachable,
    /// 手机网络
    YSNetworkStatusReachableViaWWAN,
    /// WIFI网络
    YSNetworkStatusReachableViaWiFi
};

typedef NS_ENUM(NSUInteger, YSRequestSerializer) {
    /// 设置请求数据为JSON格式
    YSRequestSerializerJSON,
    /// 设置请求数据为二进制格式
    YSRequestSerializerHTTP,
};

typedef NS_ENUM(NSUInteger, YSResponseSerializer) {
    /// 设置响应数据为JSON格式
    YSResponseSerializerJSON,
    /// 设置响应数据为二进制格式
    YSResponseSerializerHTTP,
};


/// 网络状态的Block
typedef void(^YSNetworkStatus)(YSNetworkStatusType status);

/// 请求成功的Block
typedef void(^YSHttpRequestSuccess)(id responseObject);

/// 请求失败的Block
typedef void(^YSHttpRequestFailed)(NSError *error);

/// 缓存的Block
typedef void(^YSHttpRequestCache)(id responseCache);

/// 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小
typedef void (^YSHttpProgress)(NSProgress *progress);


@interface BaseHttpRequest : NSObject


// 有网YES, 无网:NO
+ (BOOL)isNetwork;

/// 手机网络:YES, 反之:NO
+ (BOOL)isWWANNetwork;

/// WiFi网络:YES, 反之:NO
+ (BOOL)isWiFiNetwork;

/// 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
+ (void)networkStatusWithBlock:(YSNetworkStatus)networkStatus;

/**
 GET请求，无缓存

 @param URL 请求URL
 @param parameters 请求参数
 @param success 成功回调
 @param failure 失败回调
 @return 返回的对象可取消请求,调用cancel方法
 */
+ ( NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(id)parameters
                           success:(YSHttpRequestSuccess)success
                           failure:(YSHttpRequestFailed)failure;

/**
 GET请求，自动缓存

 @param URL 请求URL
 @param parameters 请求参数
 @param responseCache 缓存数据的回调
 @param success 成功回调
 @param failure 失败回调
 @return 返回的对象可取消请求,调用cancel方法
 */
+ (NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(id)parameters
                     responseCache:(YSHttpRequestCache)responseCache
                           success:(YSHttpRequestSuccess)success
                           failure:(YSHttpRequestFailed)failure;



/**
 POST请求,无缓存

 @param URL 请求URL的后缀
 @param parameters 请求参数
 @param success 成功回调
 @param failure 失败回调
 @return 返回的对象可取消请求,调用cancel方法
 */
+(NSURLSessionTask*)POST:(NSString*)URL Parameters:(id)parameters  success:(YSHttpRequestSuccess)success
                 failure:(YSHttpRequestFailed)failure;


/**
 POST请求,自动缓存

 @param URL 请求URL的后缀
 @param parameters 请求参数
 @param responseCache 缓存数据的回调
 @param success  成功回调
 @param failure 失败回调
 @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id)parameters
                      responseCache:(YSHttpRequestCache)responseCache
                            success:(YSHttpRequestSuccess)success
                            failure:(YSHttpRequestFailed)failure;


/**
 上传文件

 @param URL 请求的完整地址
 @param parameters 请求参数
 @param name 文件对应服务器上的字段
 @param filePath 文件本地的沙盒路径
 @param progress 上传进度信息
 @param success 请求成功的回调
 @param failure 请求失败的回调
 @return 返回的对象可取消请求,调用cancel方法
 */
+ (NSURLSessionTask *)uploadFileWithURL:(NSString *)URL
                                      parameters:(id)parameters
                                            name:(NSString *)name
                                        filePath:(NSString *)filePath
                                        progress:(YSHttpProgress)progress
                                         success:(YSHttpRequestSuccess)success
                                failure:(YSHttpRequestFailed)failure;






/**
 上传单/多张图片

 @param URL 请求完整地址
 @param parameters 请求参数
 @param name 图片对应服务器上的字段
 @param images  图片数组
 @param fileNames  图片文件名数组, 可以为nil, 数组内的文件名默认为当前日期时间"yyyyMMddHHmmss"
 @param imageScale 图片文件压缩比 范围 (0.f ~ 1.f)
 @param imageType 图片文件的类型,例:png、jpg(默认类型)....
 @param progress 上传进度信息
 @param success 请求成功的回调
 @param failure 请求失败的回调
 @return 返回的对象可取消请求,调用cancel方法
 */
+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                                        parameters:(id)parameters
                                              name:(NSString *)name
                                            images:(NSArray<UIImage *> *)images
                                         fileNames:(NSArray<NSString *> *)fileNames
                                        imageScale:(CGFloat)imageScale
                                         imageType:(NSString *)imageType
                                          progress:(YSHttpProgress)progress
                                           success:(YSHttpRequestSuccess)success
                                  failure:(YSHttpRequestFailed)failure;




/**
 下载文件

 @param URL 请求完整地址
 @param fileDir 文件存储目录(默认存储目录为Download)
 @param progress 文件下载的进度信息
 @param success 下载成功的回调(回调参数filePath:文件的路径)
 @param failure 下载失败的回调
 @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
+ ( NSURLSessionTask *)downloadWithURL:(NSString *)URL
                                       fileDir:(NSString *)fileDir
                                      progress:(YSHttpProgress)progress
                                       success:(void(^)(NSString *filePath))success
                               failure:(YSHttpRequestFailed)failure;



/**
 Delete请求，无缓存
 
 @param URL 请求URL
 @param parameters 请求参数
 @param success 成功回调
 @param failure 失败回调
 @return 返回的对象可取消请求,调用cancel方法
 */
+ ( NSURLSessionTask *)DELETE:(NSString *)URL
                parameters:(id)parameters
                   success:(YSHttpRequestSuccess)success
                   failure:(YSHttpRequestFailed)failure;

/**
 PUT请求，无缓存
 
 @param URL 请求URL
 @param parameters 请求参数
 @param success 成功回调
 @param failure 失败回调
 @return 返回的对象可取消请求,调用cancel方法
 */
+ ( NSURLSessionTask *)PUT:(NSString *)URL
                   parameters:(id)parameters
                      success:(YSHttpRequestSuccess)success
                      failure:(YSHttpRequestFailed)failure;



/** 取消所有HTTP请求 */
+ (void)cancelAllRequest;

/** 取消指定URL的HTTP请求 */
+ (void)cancelRequestWithURL:(NSString *)URL;

/** 获取网络缓存的总大小 bytes(字节) */
+ (NSInteger)getAllHttpCacheSize;

/** 删除所有网络缓存 */
+ (void)removeAllHttpCache;


#pragma mark - 设置AFHTTPSessionManager相关属性,因为全局只有一个AFHTTPSessionManager实例,所以以下设置方式全局生效

/**
 *  设置网络请求参数的格式:默认为二进制格式
 *
 *  @param requestSerializer YSRequestSerializerJSON(JSON格式),PPRequestSerializerHTTP(二进制格式),
 */
+ (void)setRequestSerializer:(YSRequestSerializer)requestSerializer;

/**
 *  设置服务器响应数据格式:默认为JSON格式
 *
 *  @param responseSerializer YSResponseSerializerJSON(JSON格式),PPResponseSerializerHTTP(二进制格式)
 */
+ (void)setResponseSerializer:(YSResponseSerializer)responseSerializer;

/**
 *  设置请求超时时间:默认为30S
 *
 *  @param time 时长
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

/// 设置请求头
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/// 设置请求参数放在body里面 还是拼接在url后面
+ (void)setParamTypeInBody;

@end

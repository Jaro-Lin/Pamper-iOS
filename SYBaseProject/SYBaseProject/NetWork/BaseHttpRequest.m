//
//  BaseHttpRequest.m
//  BaseProject
//
//  Created by Qinz on 2017/11/28.
//  Copyright © 2017年 Qinz. All rights reserved.
//

#import "BaseHttpRequest.h"
#import <AFNetworking.h>

#define FormDataWay 0
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

@implementation BaseHttpRequest

static YYCache *ysCache;

static NSMutableArray *_allSessionTask;
static AFHTTPSessionManager *_sessionManager;
static NSDictionary *mustParameterDic;

static  NSDictionary *_requstParams;//业务参数

#pragma mark -- 开始监测网络状态
+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - 监听网络状态的回调
+ (void)networkStatusWithBlock:(YSNetworkStatus)networkStatus {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                networkStatus ? networkStatus(YSNetworkStatusUnknown) : nil;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus ? networkStatus(YSNetworkStatusNotReachable) : nil;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus ? networkStatus(YSNetworkStatusReachableViaWWAN) : nil;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus ? networkStatus(YSNetworkStatusReachableViaWiFi) : nil;
                break;
        }
    }];
    
}

+ (BOOL)isNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isWWANNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isWiFiNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

+ (void)initialize {
    
    [self initNetWorkParameter];
    
}

#pragma mark --初始化网络请求参数
+(void)initNetWorkParameter{
    
    //初始化网络请求相关设置
    _sessionManager = [AFHTTPSessionManager manager];
    _sessionManager.requestSerializer.timeoutInterval = KReuqstOutTime;
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"multipart/form-data", nil];
    
    //    //默认是json解析,此时让它返回二进制格式的数据
    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

#pragma mark -- GET请求相关
+ ( NSURLSessionTask *)GET:(NSString *)URL
                parameters:(id)parameters
                   success:(YSHttpRequestSuccess)success
                   failure:(YSHttpRequestFailed)failure{
    
    return [self GET:URL parameters:parameters responseCache:nil success:success failure:failure];
}


+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(id)parameters
            responseCache:(YSHttpRequestCache)responseCache
                  success:(YSHttpRequestSuccess)success
                  failure:(YSHttpRequestFailed)failure{
    //读取缓存
    if (responseCache != nil) {
        if ([ysCache objectForKey:URL] != nil) {
            responseCache([ysCache objectForKey:URL]);
        }
    }
    NSURLSessionTask*sessionTask = [_sessionManager GET:URL parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allSessionTask] removeObject:task];
        
        success ? success(responseObject) : nil;
        //对数据进行异步缓存
        if (responseCache!= nil) {
            [ysCache setObject:responseObject forKey:URL withBlock:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil;
    return sessionTask;
}


#pragma mark -- POST请求相关
+(NSURLSessionTask*)POST:(NSString *)URL Parameters:(id)parameters success:(YSHttpRequestSuccess)success failure:(YSHttpRequestFailed)failure{
    
    return [self POST:URL parameters:parameters responseCache:nil success:success failure:failure];
}

+(NSURLSessionTask *)POST:(NSString *)URL parameters:(id)parameters responseCache:(YSHttpRequestCache)responseCache success:(YSHttpRequestSuccess)success failure:(YSHttpRequestFailed)failure{
    
    _requstParams = parameters;
    
    NSURLSessionTask * sessionTask =  [self temPostURL:URL parameters:parameters responseCache:responseCache success:success failure:failure];
    
    return sessionTask;
}

+(NSURLSessionTask *)temPostURL:(NSString*)URL parameters:(id)parameters responseCache:(YSHttpRequestCache)responseCache success:(YSHttpRequestSuccess)success failure:(YSHttpRequestFailed)failure{
    
    //读取缓存
    if (responseCache != nil) {
        if ([ysCache objectForKey:URL] != nil) {
            responseCache([ysCache objectForKey:URL]);
        }
    }
    NSURLSessionTask *sessionTask;
    if (FormDataWay) {//表单形式
        sessionTask = [_sessionManager POST:URL parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if (parameters && [parameters isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *parames = (NSDictionary*)parameters;
                //上传其他参数
                for (NSString *key in parames.allKeys) {
                    
                    if ([[parames objectForKey:key] isKindOfClass:[NSArray class]]) {
                        
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[parames objectForKey:key]];
                        [formData appendPartWithFormData:data name:key];
                    }else{
                        
                        NSString *str =(NSString *)[NSString stringWithFormat:@"%@",[parames objectForKey:key]];
                        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                        
                        [formData appendPartWithFormData:data name:key];
                        
                    }
                    
                }
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [[self allSessionTask] removeObject:task];
            
            success ? success(responseObject) : nil;
            //对数据进行异步缓存
            if (responseCache!= nil) {
                [ysCache setObject:responseObject forKey:URL withBlock:nil];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[self allSessionTask] removeObject:task];
            failure ? failure(error) : nil;
        }];
        
        
    }else{
        sessionTask = [_sessionManager POST:URL parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [[self allSessionTask] removeObject:task];
            
            success ? success(responseObject) : nil;
            //对数据进行异步缓存
            if (responseCache!= nil) {
                [ysCache setObject:responseObject forKey:URL withBlock:nil];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            
            [[self allSessionTask] removeObject:task];
            failure ? failure(error) : nil;
        }];
        
    }
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil;
    return sessionTask;
}

#pragma mark -- Delete相关--
+ ( NSURLSessionTask *)DELETE:(NSString *)URL
                   parameters:(id)parameters
                      success:(YSHttpRequestSuccess)success
                      failure:(YSHttpRequestFailed)failure
{
    return [self DELETE:URL parameters:parameters responseCache:nil success:success failure:failure];
}

+ (NSURLSessionTask *)DELETE:(NSString *)URL
                  parameters:(id)parameters
               responseCache:(YSHttpRequestCache)responseCache
                     success:(YSHttpRequestSuccess)success
                     failure:(YSHttpRequestFailed)failure{
    //读取缓存
    if (responseCache != nil) {
        if ([ysCache objectForKey:URL] != nil) {
            responseCache([ysCache objectForKey:URL]);
        }
    }
    
    NSURLSessionTask*sessionTask = [_sessionManager DELETE:URL parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allSessionTask] removeObject:task];
        
        success ? success(responseObject) : nil;
        //对数据进行异步缓存
        if (responseCache!= nil) {
            [ysCache setObject:responseObject forKey:URL withBlock:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil;
    return sessionTask;
}

#pragma mark -- PUT--网络请求---
+ ( NSURLSessionTask *)PUT:(NSString *)URL
                parameters:(id)parameters
                   success:(YSHttpRequestSuccess)success
                   failure:(YSHttpRequestFailed)failure
{
    return [self PUT:URL parameters:parameters responseCache:nil success:success failure:failure];
}

+ (NSURLSessionTask *)PUT:(NSString *)URL
               parameters:(id)parameters
            responseCache:(YSHttpRequestCache)responseCache
                  success:(YSHttpRequestSuccess)success
                  failure:(YSHttpRequestFailed)failure{
    //读取缓存
    if (responseCache != nil) {
        if ([ysCache objectForKey:URL] != nil) {
            responseCache([ysCache objectForKey:URL]);
        }
    }
    
    NSURLSessionTask*sessionTask = [_sessionManager PUT:URL parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allSessionTask] removeObject:task];
        
        success ? success(responseObject) : nil;
        //对数据进行异步缓存
        if (responseCache!= nil) {
            [ysCache setObject:responseObject forKey:URL withBlock:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil;
    return sessionTask;
}

#pragma mark -- 存储着所有的请求task数组
+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

#pragma mark - 获取时间戳
+(NSString*) time_stamp
{
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    return timeSp;
}

#pragma mark- 转json字符串
+(NSString*) dataToJSON:(NSDictionary*)params{
    if (params) {
        //字典转json
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
        return  error==nil?[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]:@"";
    }else{
        return @"";
    }
}

#pragma mark --取消所有网络请求
+ (void)cancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
            NSLog(@"tack销毁");
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

#pragma mark --取消指定网络请求
+ (void)cancelRequestWithURL:(NSString *)URL {
    if (!URL) { return; }
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}


#pragma mark --获取网络缓存大小
+ (NSInteger)getAllHttpCacheSize {
    return [ysCache.diskCache totalCost];
}

#pragma mark --删除所有网络缓存
+ (void)removeAllHttpCache {
    [ysCache.diskCache removeAllObjects];
}

#pragma mark --上传文件
+ (NSURLSessionTask *)uploadFileWithURL:(NSString *)URL
                             parameters:(id)parameters
                                   name:(NSString *)name
                               filePath:(NSString *)filePath
                               progress:(YSHttpProgress)progress
                                success:(YSHttpRequestSuccess)success
                                failure:(YSHttpRequestFailed)failure{
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:name error:&error];
        (failure && error) ? failure(error) : nil;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
    
}

#pragma mark --上传单/多张图片
+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                               parameters:(id)parameters
                                     name:(NSString *)name
                                   images:(NSArray<UIImage *> *)images
                                fileNames:(NSArray<NSString *> *)fileNames
                               imageScale:(CGFloat)imageScale
                                imageType:(NSString *)imageType
                                 progress:(YSHttpProgress)progress
                                  success:(YSHttpRequestSuccess)success
                                  failure:(YSHttpRequestFailed)failure{
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSUInteger i = 0; i < images.count; i++) {
            // 图片经过等比压缩后得到的二进制文件
            NSData *imageData = UIImageJPEGRepresentation(images[i], imageScale ?: 1.f);
            // 默认图片的文件名, 若fileNames为nil就使用
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            
            
            NSString *imageFileName = NSStringFormat(@"%@%ld.%@",str,i,imageType?:@"jpg");
            
            //            [formData appendPartWithFileData:imageData
            //                                        name:name
            //                                    fileName:fileNames ? NSStringFormat(@"%@.%@",fileNames[i],imageType?:@"jpg") : imageFileName
            //                                    mimeType:NSStringFormat(@"image/%@",imageType ?: @"jpg")];
            
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:@"yyb.png"
                                    mimeType:@"png"];
            //             [formData appendPartWithFileData:imgData
            //            //                                    name:@"upload_file"
            //            //                                fileName:@"png"
            //            //                                mimeType:@"png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}


#pragma mark - 下载文件
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(YSHttpProgress)progress
                              success:(void(^)(NSString *))success
                              failure:(YSHttpRequestFailed)failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    __block NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录
        //        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        /* 下载路径 */
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *filePath = [path stringByAppendingPathComponent:fileDir];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        // NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self allSessionTask] removeObject:downloadTask];
        if(failure && error) {failure(error) ; return ;};
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        
    }];
    //开始下载
    [downloadTask resume];
    // 添加sessionTask到数组
    downloadTask ? [[self allSessionTask] addObject:downloadTask] : nil ;
    
    return downloadTask;
}




#pragma mark - 重置AFHTTPSessionManager相关属性

+ (void)setAFHTTPSessionManagerProperty:(void (^)(AFHTTPSessionManager *))sessionManager {
    sessionManager ? sessionManager(_sessionManager) : nil;
}

+ (void)setRequestSerializer:(YSRequestSerializer)requestSerializer {
    _sessionManager.requestSerializer = requestSerializer== YSRequestSerializerHTTP ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
}

+ (void)setResponseSerializer:(YSResponseSerializer)responseSerializer {
    _sessionManager.responseSerializer = responseSerializer == YSResponseSerializerHTTP ? [AFHTTPResponseSerializer serializer] : [AFJSONResponseSerializer serializer];
}

+ (void)setRequestTimeoutInterval:(NSTimeInterval)time {
    _sessionManager.requestSerializer.timeoutInterval = time;
}

+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}

/// 设置请求参数放在body里面 还是拼接在url后面
+ (void)setParamTypeInBody{
    
    //只有get请求将参数凭接在url后面；
    
    _sessionManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"GET"]];
    
}


@end

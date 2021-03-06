//
//  NSFileManager+WHExtension.m
//  WHCategoriesDemo
//
//  Created by 王卫华 on 17/1/4.
//  Copyright © 2017年 王卫华. All rights reserved.
//

#import "NSFileManager+WHExtension.h"

@implementation NSFileManager (WHExtension)

+ (NSString *)wh_documentsPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+(NSString *)wh_libraryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

+(NSString *)wh_cachesPath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (void)wh_getFileSize:(NSString *)dirPath completion:(WHCompletionBlock)completion
{
    // 获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    BOOL isDir;
    BOOL isExist = [mgr fileExistsAtPath:dirPath isDirectory:&isDir];
    // 如果不为文件夹或文件夹不存在，则抛出异常
    if (!isExist || !isDir) [[NSException exceptionWithName:@"pathError" reason:@"please check the dirdctoryPath!" userInfo:nil] raise];
    
    __block NSInteger size = 0;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSDirectoryEnumerator *fileEnumerator = [mgr enumeratorAtPath:dirPath];
        for (NSString *fileName in fileEnumerator) {
            // 拼接全路径
            NSString *filePath = [dirPath stringByAppendingPathComponent:fileName];
            
            BOOL isDir;
            BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDir];
            // 如果为文件夹或隐藏文件，则跳过
            if (!isExist || isDir || [filePath containsString:@".DS"]) continue;
            // 获取文件属性
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
            
        }
        // 计算完成回调
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion) completion(size);
        });
    });
    
}

+ (void)wh_clearDirPath:(NSString *)dirPath
{
    // 获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    BOOL isDir;
    BOOL isExist = [mgr fileExistsAtPath:dirPath isDirectory:&isDir];
    // 如果不为文件夹或文件夹不存在，则抛出异常
    if (!isExist || !isDir) [[NSException exceptionWithName:@"pathError" reason:@"please check the dirdctoryPath!" userInfo:nil] raise];
    
    NSDirectoryEnumerator *fileEnumerator = [mgr enumeratorAtPath:dirPath];
    for (NSString *fileName in fileEnumerator) {
        // 拼接全路径
        NSString *filePath = [dirPath stringByAppendingPathComponent:fileName];
        // 删除路径
        [mgr removeItemAtPath:filePath error:nil];
    }
}

+ (void)wh_getCacheSizeCompletion:(WHCompletionBlock)completion
{
    [self wh_getFileSize:[self wh_cachesPath] completion:^(NSInteger size) {
        if (completion) completion(size);
    }];
}

+ (void)wh_clearCache
{
    [self wh_clearDirPath:[self wh_cachesPath]];
}

/** 保存文件到指定目录 +新建一个文件夹名称 */
+ (NSString*)wh_saveFile:(whFilePath)filePath file:(NSString *)fileName videoData:(NSData *)data{
    NSString *path;
    switch (filePath) {
            
        case whFilePath_documents:
            path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName ?:@"tampVideo"];
            break;
        case whFilePath_library:
            path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:fileName ?:@"tampVideo"];
            break;
        case whFilePath_caches:
            path = [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:fileName ?:@"tampVideo"];
            break;
        default:
            break;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *saveFileName = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",nowTimeStr]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
       BOOL isDir = FALSE;
       BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    
    if(!(isDirExist && isDir)){
        
                 BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        
                if(!bCreateDir){
                         NSLog(@"创建文件夹失败！");
                      }
                   NSLog(@"创建文件夹成功，文件路径%@",path);
     
              }
  
    if (data) {
        [data writeToFile:saveFileName atomically:YES];
        return saveFileName;
    }else{
        return @"";
    }

}


@end

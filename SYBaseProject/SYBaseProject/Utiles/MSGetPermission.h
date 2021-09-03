//
//  MSGetPermission.h
//  magicShop
//
//  Created by sy on 2019/12/8.
//  Copyright © 2019 YYB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSGetPermission : NSObject


/**
 获取系统相册权限
 @param callBack callback
 */
+(void)getPhotosPermission:(void(^)(BOOL has))callBack;

/**
 获取相机权限
 @param callBack callback(是否有权限)
 */
+(void)getCaptureDevicePermission:(void(^)(BOOL has))callBack;

/**
 获取麦克风权限
 @param callBack callback(是否有权限)
 */
+(void)getAudioRecordPermission:(void(^)(BOOL has))callBack;

/**
 同时获取相机+录音权限
 @param callBack callback
 */
+(void)getCaptureAndRecodPermission:(void(^)(BOOL hasCapturePermiss,BOOL hasRecodPermiss))callBack;

/**
 获取通讯录权限
 @param callBack callback
 */
+(void)getAddressBookPermission:(void(^)(BOOL has))callBack;
@end

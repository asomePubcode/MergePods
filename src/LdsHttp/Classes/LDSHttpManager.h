//
//  LDSHttpManager.h
//  SmartHome
//
//  Created by 廖亚雄 on 2018/3/2.
//  Copyright © 2018年 廖亚雄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LdsHttpRequest.h"


#define gLdsHttp [LDSHttpManager sharedInstance]

extern NSString * _Nonnull const kResonpeErrorInfoData;

@interface LDSHttpManager : NSObject


+ (instancetype _Nonnull )sharedInstance;
/**
 http set header

 @param header header
 */
+ (void) setHttpHeader:(NSDictionary *_Nonnull)header;

/**
 http request

 @param urlString url
 @param params params
 @param httpMethod GET/POST
 @param completedblock completed callback
 @param failedBlock failed callback
 */
+(void)requestWithURL:(NSString *_Nonnull)urlString
               params:(NSMutableDictionary *_Nullable)params
           httpMethod:(NSString *_Nullable)httpMethod
       completedBlock:(void (^_Nullable)(id _Nullable result))completedblock
          failedBlock:(void (^_Nullable)(NSError * _Nullable error))failedBlock;

/// HTTP 通用请求
/// @param config 请求参数
/// @param uploadProgress 上传进度回调
/// @param downloadProgress 下载进度回调
/// @param success 成功回调
/// @param failure 失败回调
- (void)request:(LdsHttpRequest * _Nonnull)config
               uploadProgress:(nullable void (^)(NSProgress * _Nonnull uploadProgress))uploadProgress
             downloadProgress:(nullable void (^)(NSProgress * _Nonnull downloadProgress))downloadProgress
                      success:(void (^_Nullable)(id _Nullable result))success
                      failure:(void (^_Nullable)(NSError * _Nullable error))failure;

/// HTTP download
/// @param config 请求参数
/// @param downloadProgress 下载进度回调
/// @param success 成功回调
/// @param failure 失败回调
- (void)download:(LdsHttpRequest * _Nonnull)config
downloadProgress:(nullable void (^)(NSProgress * _Nonnull downloadProgress))downloadProgress
         success:(void (^_Nullable)(id _Nullable result))success
         failure:(void (^_Nullable)(NSError * _Nullable error))failure;

/// HTTP upload
/// @param config 请求参数
/// @param uploadProgress 上传进度回调
/// @param success 成功回调
/// @param failure 失败回调
- (void)upload:(LdsHttpRequest * _Nonnull)config
  uploadProgress:(nullable void (^)(NSProgress * _Nonnull uploadProgress))uploadProgress
         success:(void (^_Nullable)(id _Nullable result))success
         failure:(void (^_Nullable)(NSError * _Nullable error))failure;

/**
 cancel request

 @param requestID requestID
 */
- (void)cancelRequestWithRequestID:(NSNumber *_Nonnull)requestID;

/**
 cancel request list

 @param requestIDList requestIDList
 */
- (void)cancelRequestWithRequestIDList:(NSArray *_Nonnull)requestIDList;

@end

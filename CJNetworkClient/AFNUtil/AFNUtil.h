//
//  AFNUtil.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>

typedef void(^CJRequestSuccess)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject);
typedef void(^CJRequestFailure)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

/**< 注意在缓存机制中，success与failuer指的都是是获取数据成功的与否，而不是请求成功的与否 */
typedef void(^CJRequestCacheSuccess)(NSURLSessionDataTask *_Nullable task, id _Nullable responseObject, BOOL isCacheData);
typedef void(^CJRequestCacheFailure)(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error, BOOL isCacheData);

/*
NSString *errorMessage = [task errorMessage];
if ([errorMessage isEqualToString:@""]) {
    errorMessage = error.description;
}
*/

@interface AFNUtil : NSObject

+ (void)hud_showNoNetwork;

//AFHTTPSessionManager : AFURLSessionManager

/**
 *  POST请求
 *
 *  @param manager          manager
 *  @param Url              Url
 *  @param parameters       parameters
 *  @param uploadProgress   uploadProgress
 *  @param success          success
 *  @param failure          failure
 *
 *  return NSURLSessionDataTask
 */
+ (nullable NSURLSessionDataTask *)useManager:(nullable AFHTTPSessionManager *)manager
                               postRequestUrl:(nullable NSString *)Url
                                   parameters:(nullable id)parameters
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                      success:(nullable CJRequestSuccess)success
                                      failure:(nullable CJRequestFailure)failure;

/**
 *  POST请求
 *
 *  @param manager          manager
 *  @param Url              Url
 *  @param parameters       parameters
 *  @param cacheReuqestData 是否缓存网络数据
 *  @param uploadProgress   uploadProgress
 *  @param success          success
 *  @param failure          failure
 *
 *  return NSURLSessionDataTask
 */
+ (nullable NSURLSessionDataTask *)useManager:(nullable AFHTTPSessionManager *)manager
                               postRequestUrl:(nullable NSString *)Url
                                   parameters:(nullable id)parameters
                             cacheReuqestData:(BOOL)cacheReuqestData
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                      success:(nullable CJRequestCacheSuccess)success
                                      failure:(nullable CJRequestCacheFailure)failure;


+ (NSError *)networkErrorWithLocalizedDescription:(NSString *)localizedDescription;

@end

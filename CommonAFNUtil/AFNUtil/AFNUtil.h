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


typedef void(^CJRequestSuccess)(NSURLSessionDataTask *task, id responseObject);
typedef void(^CJRequestFailure)(NSURLSessionDataTask *task, NSError *error);
//void (^)(AFHTTPRequestOperation *operation, NSString *failMesg)

/**< 注意在缓存机制中，success与failuer指的都是是获取数据成功的与否，而不是请求成功的与否 */
typedef void(^CJRequestCacheSuccess)(NSURLSessionDataTask *task, id responseObject, BOOL isCacheData);
typedef void(^CJRequestCacheFailure)(NSURLSessionDataTask *task, NSError *error, BOOL isCacheData);

@interface AFNUtil : NSObject

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
+ (NSURLSessionDataTask *)useManager:(AFHTTPSessionManager *)manager
                      postRequestUrl:(NSString *)Url
                          parameters:(id)parameters
                            progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                             success:(CJRequestSuccess)success
                             failure:(CJRequestFailure)failure;

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
+ (NSURLSessionDataTask *)useManager:(AFHTTPSessionManager *)manager
                      postRequestUrl:(NSString *)Url
                          parameters:(NSDictionary *)parameters
                    cacheReuqestData:(BOOL)cacheReuqestData
                            progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                             success:(CJRequestCacheSuccess)success
                             failure:(CJRequestCacheFailure)failure;


@end

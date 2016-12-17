//
//  CommonAFNInstance.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/10/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNUtil.h"
#import "AFNUtilCache.h"

@interface CommonAFNInstance : NSObject

+ (CommonAFNInstance *)shareCommonAFNInstance;


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
- (NSURLSessionDataTask *)useManager:(AFHTTPSessionManager *)manager
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
- (NSURLSessionDataTask *)useManager:(AFHTTPSessionManager *)manager
                      postRequestUrl:(NSString *)Url
                          parameters:(NSDictionary *)parameters
                    cacheReuqestData:(BOOL)cacheReuqestData
                            progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                             success:(CJRequestCacheSuccess)success
                             failure:(CJRequestCacheFailure)failure;



@end

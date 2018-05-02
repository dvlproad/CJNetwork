//
//  AFHTTPSessionManager+CJCacheRequest.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "CJNetworkMonitor.h"
#import "CJNetworkDefine.h"

#import "CJRequestCacheDataUtil.h"

/**
 *  AFN的请求方法(包含缓存方法)
 */
@interface AFHTTPSessionManager (CJCategory) {
    
}
@property (nonatomic, copy) void (^_Nullable cjNoNetworkHandle)(void);    /**< 没有网络时候要执行的操作(添加此此代码块，解除对SVProgressHUD的依赖) */

/**
 *  POST请求
 *
 *  @param Url              Url
 *  @param parameters       parameters
 *  @param uploadProgress   uploadProgress
 *  @param success          success
 *  @param failure          failure
 *
 *  return NSURLSessionDataTask
 */
- (nullable NSURLSessionDataTask *)cj_postRequestUrl:(nullable NSString *)Url
                                 parameters:(nullable id)parameters
                                   progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                    success:(nullable AFRequestSuccess)success
                                    failure:(nullable AFRequestFailure)failure;


/**
 *  发起请求
 *
 *  @param Url          Url
 *  @param params       params
 *  @param cache        是否缓存网络数据(如果有缓存，则即代表可以从缓存中获取数据)
 *  @param success      请求成功的回调success
 *  @param failure      请求失败的回调failure
 *
 *  return NSURLSessionDataTask
 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                                        cache:(BOOL)cacheReuqestData
                                      success:(nullable void (^)(NSDictionary *_Nullable responseObject, BOOL isCacheData))success
                                      failure:(nullable void (^)(NSError * _Nullable error, CJRequestFailureType failureType))failure;


/**
 *  发起请求
 *
 *  @param Url          Url
 *  @param params       params
 *  @param cache        是否缓存网络数据(如果有缓存，则即代表可以从缓存中获取数据)
 *  @param encacheBlock 对请求的结果response保存缓存的方法
 *  @param decacheBlock 对请求得到的缓存解密的方法
 *  @param uploadProgress   uploadProgress
 *  @param success      请求成功的回调success
 *  @param failure      请求失败的回调failure
 *
 *  return NSURLSessionDataTask
 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                                        cache:(BOOL)cache
                               encacheBlock:(nullable NSData * _Nullable (^)(NSDictionary * _Nullable requestParmas))encacheBlock
                                decacheBlock:(nullable NSDictionary * _Nullable (^)(NSString * _Nullable responseString))decacheBlock
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                      success:(nullable void (^)(NSDictionary *_Nullable responseObject, BOOL isCacheData))success
                                      failure:(nullable void (^)(NSError * _Nullable error, CJRequestFailureType failureType))failure;

@end

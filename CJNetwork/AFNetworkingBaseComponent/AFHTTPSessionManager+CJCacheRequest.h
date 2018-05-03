//
//  AFHTTPSessionManager+CJCacheRequest.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "CJRequestCacheDataUtil.h"

typedef NS_OPTIONS(NSUInteger, CJNeedGetCacheOption) {
    CJNeedGetCacheOptionNone = 1 << 0,             /**< 不缓存 */
    CJNeedGetCacheOptionNetworkUnable = 1 << 1,    /**< 无网 */
    CJNeedGetCacheOptionRequestFailure = 1 << 2,   /**< 有网，但是请求地址或者服务器错误等 */
};

/**
 *  AFN的请求方法(包含缓存方法)
 */
@interface AFHTTPSessionManager (CJCacheRequest) {
    
}

#pragma mark - CJCache
/**
 *  发起POST请求
 *
 *  @param Url          Url
 *  @param params       params
 *  @param isNetworkEnabled 当前的网络状态是否可用
 *  @param cache        是否缓存网络数据(如果有缓存，则即代表可以从缓存中获取数据)
 *  @param success      请求成功的回调success
 *  @param failure      请求失败的回调failure
 *
 *  @return NSURLSessionDataTask
 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                         currentNetworkStatus:(BOOL)isNetworkEnabled
                                        cache:(BOOL)cache
                                      success:(nullable void (^)(NSDictionary *_Nullable responseObject, BOOL isCacheData))success
                                      failure:(nullable void (^)(NSError * _Nullable error))failure;

#pragma mark - CJCacheEncrypt
/**
 *  发起POST请求
 *
 *  @param Url          Url
 *  @param params       params
 *  @param isNetworkEnabled 当前的网络状态是否可用
 *  @param cache        是否缓存网络数据(如果有缓存，则即代表可以从缓存中获取数据)
 *  @param encrypt      是否加密
 *  @param encryptBlock 对请求的参数requestParmas加密的方法
 *  @param decryptBlock 对请求得到的responseString解密的方法
 *  @param success      请求成功的回调success
 *  @param failure      请求失败的回调failure
 *
 *  @return NSURLSessionDataTask
 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                         currentNetworkStatus:(BOOL)isNetworkEnabled
                                        cache:(BOOL)cache
                                      encrypt:(BOOL)encrypt
                                 encryptBlock:(NSData * (^)(NSDictionary *requestParmas))encryptBlock
                                 decryptBlock:(NSDictionary * (^)(NSString *responseString))decryptBlock
                                      success:(nullable void (^)(NSDictionary *_Nullable responseObject, BOOL isCacheData))success
                                      failure:(nullable void (^)(NSError * _Nullable error))failure;

@end

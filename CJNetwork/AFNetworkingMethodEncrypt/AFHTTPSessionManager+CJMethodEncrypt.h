//
//  AFHTTPSessionManager+CJMethodEncrypt.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//
//  通过传进去的方法，单独处理加密问题，如果不想单独设置而是全局设置，请使用AFHTTPSessionManager+CJSerializerEncrypt.h

#import <AFNetworking/AFNetworking.h>
#import "CJRequestCommonHelper.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  AFN的请求方法(包含缓存和加密方法)
 */
@interface AFHTTPSessionManager (CJMethodEncrypt) {
    
}

#pragma mark - CJEncrypt
/*
 *  发起POST请求
 *
 *  @param Url                  Url
 *  @param params               params
 *  @param cacheSettingModel    cacheSettingModel需要缓存网络数据的情况(如果有缓存，则即代表可以从缓存中获取数据)
 *  @param logType              logType
 *  @param encrypt          是否加密
 *  @param encryptBlock     对请求的参数requestParmas加密的方法
 *  @param decryptBlock     对请求得到的responseString解密的方法
 *  @param success          请求成功的回调success
 *  @param failure          请求失败的回调failure
 *
 *  return NSURLSessionDataTask
 */
- (nullable NSURLSessionDataTask *)cjMethodEncrypt_postUrl:(NSString *)Url
                                                    params:(nullable id)params
                                         cacheSettingModel:(nullable CJRequestCacheSettingModel *)cacheSettingModel
                                                   logType:(CJRequestLogType)logType
                                           encrypt:(BOOL)encrypt
                                      encryptBlock:(nullable NSData * _Nullable (^)(NSDictionary * _Nullable requestParmas))encryptBlock
                                      decryptBlock:(nullable NSDictionary * _Nullable (^)(NSString * _Nullable responseString))decryptBlock
                                           success:(nullable void (^)(CJSuccessRequestInfo * _Nonnull successRequestInfo))success
                                           failure:(nullable void (^)(CJFailureRequestInfo * _Nonnull failureRequestInfo))failure;


NS_ASSUME_NONNULL_END

@end

//
//  AFHTTPSessionManager+CJEncrypt.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/6/13.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "CJNetworkMonitor.h"
#import "CJNetworkDefine.h"

#import "CJRequestCacheDataUtil.h"

@interface AFHTTPSessionManager (CJEncrypt)

/**
 *  发起请求
 *
 *  @param Url          Url
 *  @param params       params
 *  @param encrypt      是否加密
 *  @param encryptBlock 对请求的参数requestParmas加密的方法
 *  @param decryptBlock 对请求得到的responseString解密的方法
 *  @param success      请求成功的回调success
 *  @param failure      请求失败的回调failure
 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                                      encrypt:(BOOL)encrypt
                                 encryptBlock:(nullable NSData * _Nullable (^)(NSDictionary * _Nullable requestParmas))encryptBlock
                                 decryptBlock:(nullable NSDictionary * _Nullable (^)(NSString * _Nullable responseString))decryptBlock
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                      success:(nullable void (^)(NSDictionary *_Nullable responseObject))success
                                      failure:(nullable void (^)(NSError * _Nullable error))failure;

@end

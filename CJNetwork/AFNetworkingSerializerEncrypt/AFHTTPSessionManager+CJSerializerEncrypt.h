//
//  AFHTTPSessionManager+CJSerializerEncrypt.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/6/13.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AFHTTPSessionManager+CJRequestCommon.h"

@interface AFHTTPSessionManager (CJSerializerEncrypt)

/**
 *  发起GET请求
 *
 *  @param Url              Url
 *  @param allParams        allParams
 *  @param settingModel     settingModel
 *  @param success          请求成功的回调success
 *  @param failure          请求失败的回调failure
 *
 *  @return NSURLSessionDataTask
 */
- (nullable NSURLSessionDataTask *)cj_getUrl:(nullable NSString *)Url
                                      params:(nullable NSDictionary *)allParams
                                settingModel:(CJRequestSettingModel *)settingModel
                                     success:(nullable void (^)(id _Nullable responseObject))success
                                     failure:(void (^)(NSString *errorMessage))failure;

/**
 *  发起POST请求(是否加密等都通过Serializer处理)
 *
 *  @param Url              Url
 *  @param allParams        allParams
 *  @param settingModel     settingModel
 *  @param success          请求成功的回调success
 *  @param failure          请求失败的回调failure
 *
 *  @return NSURLSessionDataTask
 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(nullable NSString *)Url
                                       params:(nullable id)allParams
                                 settingModel:(CJRequestSettingModel *)settingModel
                                      success:(nullable void (^)(id _Nullable responseObject))success
                                      failure:(void (^)(NSString *errorMessage))failure;

/**
 *  发起请求(当为GET请求时，不需要加密；而当为POST请求时，是否加密等都通过Serializer处理)
 *
 *  @param Url              Url
 *  @param allParams        allParams
 *  @param method           request method
 *  @param settingModel     settingModel
 *  @param success          请求成功的回调success
 *  @param failure          请求失败的回调failure
 *
 *  @return NSURLSessionDataTask
 */
- (nullable NSURLSessionDataTask *)cj_requestUrl:(nullable NSString *)Url
                                          params:(nullable id)allParams
                                          method:(CJRequestMethod)method
                                    settingModel:(CJRequestSettingModel *)settingModel
                                         success:(nullable void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo))success
                                         failure:(nullable void (^)(CJFailureRequestInfo * _Nullable failureRequestInfo))failure;


@end

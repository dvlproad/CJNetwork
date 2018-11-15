//
//  AFHTTPSessionManager+CJSerializerEncrypt.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/6/13.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "CJRequestSettingModel.h"
#import "CJNetworkInfoModel.h"

@interface AFHTTPSessionManager (CJSerializerEncrypt)

/**
 *  发起GET请求
 *
 *  @param Url              Url
 *  @param params           params
 *  @param settingModel     settingModel
 *  @param success          请求成功的回调success
 *  @param failure          请求失败的回调failure
 *
 *  @return NSURLSessionDataTask
 */
- (nullable NSURLSessionDataTask *)cj_getUrl:(nullable NSString *)Url
                                      params:(nullable NSDictionary *)params
                                settingModel:(CJRequestSettingModel *)settingModel
                                     success:(nullable void (^)(CJSuccessNetworkInfo * _Nullable successNetworkInfo))success
                                     failure:(nullable void (^)(CJFailureNetworkInfo * _Nullable failureNetworkInfo))failure;


/**
 *  发起POST请求(是否加密等都通过Serializer处理)
 *
 *  @param Url              Url
 *  @param params           params
 *  @param settingModel     settingModel
 *  @param success          请求成功的回调success
 *  @param failure          请求失败的回调failure
 *
 *  @return NSURLSessionDataTask
 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                                 settingModel:(CJRequestSettingModel *)settingModel
                                      success:(nullable void (^)(CJSuccessNetworkInfo * _Nullable successNetworkInfo))success
                                      failure:(nullable void (^)(CJFailureNetworkInfo * _Nullable failureNetworkInfo))failure;

@end

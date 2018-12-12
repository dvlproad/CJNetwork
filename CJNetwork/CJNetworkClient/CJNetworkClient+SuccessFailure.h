//
//  CJNetworkClient+SuccessFailure.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  有两个回调，分别为 success + failure

#import "CJNetworkClient.h"

@interface CJNetworkClient (SuccessFailure)

#pragma mark - Real
- (NSURLSessionDataTask *)real2_getApi:(NSString *)apiSuffix
                                params:(NSDictionary *)params
                          settingModel:(CJRequestSettingModel *)settingModel
                               success:(void (^)(CJResponseModel *responseModel))success
                               failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

- (NSURLSessionDataTask *)real2_postApi:(NSString *)apiSuffix
                                 params:(id)params
                           settingModel:(CJRequestSettingModel *)settingModel
                                success:(void (^)(CJResponseModel *responseModel))success
                                failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

#pragma mark simulate
- (NSURLSessionDataTask *)simulate2_getApi:(NSString *)apiSuffix
                                    params:(NSDictionary *)params
                              settingModel:(CJRequestSettingModel *)settingModel
                                   success:(void (^)(CJResponseModel *responseModel))success
                                   failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

- (NSURLSessionDataTask *)simulate2_postApi:(NSString *)apiSuffix
                                     params:(id)params
                               settingModel:(CJRequestSettingModel *)settingModel
                                    success:(void (^)(CJResponseModel *responseModel))success
                                    failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

#pragma mark - localApi
- (NSURLSessionDataTask *)local2_getApi:(NSString *)apiSuffix
                                 params:(NSDictionary *)params
                           settingModel:(CJRequestSettingModel *)settingModel
                                success:(void (^)(CJResponseModel *responseModel))success
                                failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

- (NSURLSessionDataTask *)local2_postApi:(NSString *)apiSuffix
                                  params:(id)params
                            settingModel:(CJRequestSettingModel *)settingModel
                                 success:(void (^)(CJResponseModel *responseModel))success
                                 failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

@end

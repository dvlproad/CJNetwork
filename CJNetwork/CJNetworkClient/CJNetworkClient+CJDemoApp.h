//
//  CJNetworkClient+CJDemoApp.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  below are the cjdemo app's upload image example, other app can refer to it
//  below are the cjdemo app's upload image example, other app can refer to it
//  below are the cjdemo app's upload image example, other app can refer to it

#import "CJNetworkClient.h"
#import "CJNetworkClient+SuccessFailure.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJNetworkClient (CJDemoApp)

#pragma mark - RealApi
- (NSURLSessionDataTask *)cjdemoR1_uploadImageApi:(NSString *)apiSuffix
                                        urlParams:(nullable id)urlParams
                                       formParams:(nullable id)formParams
                                       imageDatas:(NSArray<NSData *> *)imageDatas
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                    completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (NSURLSessionDataTask *)cjdemoR2_uploadImageApi:(NSString *)apiSuffix
                                        urlParams:(nullable id)urlParams
                                       formParams:(nullable id)formParams
                          imageKeyDataDictionarys:(NSDictionary *)imageKeyDataDicts
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                          success:(void (^)(CJResponseModel *responseModel))success
                                          failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

#pragma mark - simulateApi
- (NSURLSessionDataTask *)cjdemoS1_uploadImageApi:(NSString *)apiSuffix
                                        urlParams:(nullable id)urlParams
                                       formParams:(nullable id)formParams
                          imageKeyDataDictionarys:(NSDictionary *)imageKeyDataDicts
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                    completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (NSURLSessionDataTask *)cjdemoS2_uploadImageApi:(NSString *)apiSuffix
                                        urlParams:(nullable id)urlParams
                                       formParams:(nullable id)formParams
                          imageKeyDataDictionarys:(NSDictionary *)imageKeyDataDicts
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                          success:(void (^)(CJResponseModel *responseModel))success
                                          failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

#pragma mark - localApi
- (nullable NSURLSessionDataTask *)cjdemoL1_uploadImageApi:(NSString *)apiSuffix
                                                 urlParams:(nullable id)urlParams
                                                formParams:(nullable id)formParams
                                   imageKeyDataDictionarys:(NSDictionary *)imageKeyDataDicts
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                    completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (nullable NSURLSessionDataTask *)cjdemoL2_uploadImageApi:(NSString *)apiSuffix
                                                 urlParams:(nullable id)urlParams
                                                formParams:(nullable id)formParams
                                   imageKeyDataDictionarys:(NSDictionary *)imageKeyDataDicts
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                          success:(void (^)(CJResponseModel *responseModel))success
                                          failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

@end

NS_ASSUME_NONNULL_END

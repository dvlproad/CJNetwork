//
//  CJNetworkClient+SuccessFailure.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  有两个回调，分别为 success + failure

#import "CJNetworkClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJNetworkClient (SuccessFailure)

#pragma mark - RealApi
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

- (NSURLSessionDataTask *)real2_uploadApi:(NSString *)apiSuffix
                                   params:(nullable NSDictionary *)customParams
                             settingModel:(CJRequestSettingModel *)settingModel
                                  fileKey:(nullable NSString *)fileKey
                                fileValue:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                 progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                  success:(void (^)(CJResponseModel *responseModel))success
                                  failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;
- (NSURLSessionDataTask *)real2_uploadUrl:(NSString *)Url
                                   params:(nullable NSDictionary *)customParams
                             settingModel:(CJRequestSettingModel *)settingModel
                                  fileKey:(nullable NSString *)fileKey
                                fileValue:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                 progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                  success:(void (^)(CJResponseModel *responseModel))success
                                  failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;


#pragma mark - simulateApi
// 为方便接口的重复利用回调中的responseModel使用id类型
- (NSURLSessionDataTask *)simulate2_getApi:(NSString *)apiSuffix
                                    params:(NSDictionary *)params
                              settingModel:(CJRequestSettingModel *)settingModel
                                   success:(void (^)(id responseModel))success
                                   failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

- (NSURLSessionDataTask *)simulate2_postApi:(NSString *)apiSuffix
                                     params:(id)params
                               settingModel:(CJRequestSettingModel *)settingModel
                                    success:(void (^)(id responseModel))success
                                    failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

- (NSURLSessionDataTask *)simulate2_uploadApi:(NSString *)apiSuffix
                                       params:(nullable NSDictionary *)customParams
                                 settingModel:(CJRequestSettingModel *)settingModel
                                      fileKey:(nullable NSString *)fileKey
                                    fileValue:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                      success:(void (^)(id responseModel))success
                                      failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

#pragma mark - localApi
// 为方便接口的重复利用回调中的responseModel使用id类型
- (nullable NSURLSessionDataTask *)local2_getApi:(NSString *)apiSuffix
                                 params:(NSDictionary *)params
                           settingModel:(CJRequestSettingModel *)settingModel
                                success:(void (^)(id responseModel))success
                                failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

- (nullable NSURLSessionDataTask *)local2_postApi:(NSString *)apiSuffix
                                  params:(id)params
                            settingModel:(CJRequestSettingModel *)settingModel
                                 success:(void (^)(id responseModel))success
                                 failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

- (nullable NSURLSessionDataTask *)local2_uploadApi:(NSString *)apiSuffix
                                             params:(nullable NSDictionary *)customParams
                                       settingModel:(CJRequestSettingModel *)settingModel
                                            fileKey:(nullable NSString *)fileKey
                                          fileValue:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                           progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                            success:(void (^)(id responseModel))success
                                            failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

NS_ASSUME_NONNULL_END

@end

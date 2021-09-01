//
//  CJNetworkClient+Upload2.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  有两个回调，分别为 success + failure

#import "CJNetworkClient.h"
#import <CQNetworkRequestPublic/CQNetworkUploadSuccessFailureClientProtocal.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJNetworkClient (Upload2) <CQNetworkUploadSuccessFailureClientProtocal>

#pragma mark - RealApi

- (NSURLSessionDataTask *)real2_uploadApi:(NSString *)apiSuffix
                                urlParams:(nullable id)urlParams
                               formParams:(nullable id)formParams
                             settingModel:(nullable CJRequestSettingModel *)settingModel
                         uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                 progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                  success:(void (^)(CJResponseModel *responseModel))success
                                  failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;
- (NSURLSessionDataTask *)real2_uploadUrl:(NSString *)Url
                                urlParams:(nullable id)urlParams
                               formParams:(nullable id)formParams
                             settingModel:(nullable CJRequestSettingModel *)settingModel
                         uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                 progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                  success:(void (^)(CJResponseModel *responseModel))success
                                  failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;


#pragma mark - simulateApi
// 为方便接口的重复利用回调中的responseModel使用id类型
- (NSURLSessionDataTask *)simulate2_uploadApi:(NSString *)apiSuffix
                                    urlParams:(nullable id)urlParams
                                   formParams:(nullable id)formParams
                                 settingModel:(nullable CJRequestSettingModel *)settingModel
                             uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                      success:(void (^)(id responseModel))success
                                      failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

#pragma mark - localApi
// 为方便接口的重复利用回调中的responseModel使用id类型
- (nullable NSURLSessionDataTask *)local2_uploadApi:(NSString *)apiSuffix
                                          urlParams:(nullable id)urlParams
                                         formParams:(nullable id)formParams
                                       settingModel:(nullable CJRequestSettingModel *)settingModel
                                   uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                           progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                            success:(void (^)(id responseModel))success
                                            failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

@end

NS_ASSUME_NONNULL_END

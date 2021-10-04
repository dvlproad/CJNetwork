//
//  CJNetworkClient+Upload2.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJNetworkClient+Upload2.h"
#import "CJNetworkClient+Upload1.h"

@implementation CJNetworkClient (Upload2)

#pragma mark - RealApi

- (NSURLSessionDataTask *)real2_uploadApi:(NSString *)apiSuffix
                                urlParams:(nullable id)urlParams
                               formParams:(nullable id)formParams
                             settingModel:(nullable CJRequestSettingModel *)settingModel
                         uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                 progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                  success:(void (^)(CJResponseModel *responseModel))success
                                  failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self real1_uploadApi:apiSuffix urlParams:urlParams formParams:formParams settingModel:settingModel uploadFileModels:uploadFileModels progress:uploadProgress completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
        [self __splitCompleteBlockWithFailureType:failureType responseModel:responseModel toSuccess:success failure:failure];
    }];
}
- (NSURLSessionDataTask *)real2_uploadUrl:(NSString *)Url
                                urlParams:(nullable id)urlParams
                               formParams:(nullable id)formParams
                             settingModel:(nullable CJRequestSettingModel *)settingModel
                         uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                 progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                  success:(void (^)(CJResponseModel *responseModel))success
                                  failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self real1_uploadUrl:Url urlParams:urlParams formParams:formParams settingModel:settingModel uploadFileModels:uploadFileModels progress:uploadProgress completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
        [self __splitCompleteBlockWithFailureType:failureType responseModel:responseModel toSuccess:success failure:failure];
    }];
}

#pragma mark - simulateApi

- (NSURLSessionDataTask *)simulate2_uploadApi:(NSString *)apiSuffix
                                    urlParams:(nullable id)urlParams
                                   formParams:(nullable id)formParams
                                 settingModel:(nullable CJRequestSettingModel *)settingModel
                             uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                      success:(void (^)(id responseModel))success
                                      failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self simulate1_uploadApi:apiSuffix urlParams:urlParams formParams:formParams settingModel:settingModel uploadFileModels:uploadFileModels progress:uploadProgress completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
        [self __splitCompleteBlockWithFailureType:failureType responseModel:responseModel toSuccess:success failure:failure];
    }];
}

#pragma mark - localApi

- (nullable NSURLSessionDataTask *)local2_uploadApi:(NSString *)apiSuffix
                                          urlParams:(nullable id)urlParams
                                         formParams:(nullable id)formParams
                                       settingModel:(nullable CJRequestSettingModel *)settingModel
                                   uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                           progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                            success:(void (^)(id responseModel))success
                                            failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self local1_uploadApi:apiSuffix urlParams:urlParams formParams:formParams settingModel:settingModel uploadFileModels:uploadFileModels progress:uploadProgress completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
        [self __splitCompleteBlockWithFailureType:failureType responseModel:responseModel toSuccess:success failure:failure];
    }];
}

#pragma mark - Private
- (void)__splitCompleteBlockWithFailureType:(CJResponeFailureType)failureType
                            responseModel:(CJResponseModel *)responseModel
                                toSuccess:(void (^)(CJResponseModel *responseModel))success
                                  failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    if (failureType == CJResponeFailureTypeCommonFailure) {
        !failure ?: failure(NO, responseModel.message);
        
    } else if (failureType == CJResponeFailureTypeRequestFailure) {
        !failure ?: failure(YES, responseModel.message);
        
    } else {
        !success ?: success(responseModel);
    }
}

@end

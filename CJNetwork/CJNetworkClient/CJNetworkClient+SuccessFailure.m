//
//  CJNetworkClient+SuccessFailure.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJNetworkClient+SuccessFailure.h"
#import "CJRequestSimulateUtil.h"

@implementation CJNetworkClient (SuccessFailure)

#pragma mark - Real
- (NSURLSessionDataTask *)real2_getApi:(NSString *)apiSuffix
                                params:(NSDictionary *)params
                          settingModel:(CJRequestSettingModel *)settingModel
                               success:(void (^)(CJResponseModel *responseModel))success
                               failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self real_getApi:apiSuffix params:params settingModel:settingModel completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
        [self splitCompleteBlockWithFailureType:failureType responseModel:responseModel toSuccess:success failure:failure];
    }];
}

- (NSURLSessionDataTask *)real2_postApi:(NSString *)apiSuffix
                                 params:(id)params
                           settingModel:(CJRequestSettingModel *)settingModel
                                success:(void (^)(CJResponseModel *responseModel))success
                                failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self real_postApi:apiSuffix params:params settingModel:settingModel completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
        [self splitCompleteBlockWithFailureType:failureType responseModel:responseModel toSuccess:success failure:failure];
    }];
}

- (NSURLSessionDataTask *)real2_postUploadUrl:(nullable NSString *)Url
                                       params:(nullable NSDictionary *)customParams
                                 settingModel:(CJRequestSettingModel *)settingModel
                                      fileKey:(nullable NSString *)fileKey
                                    fileValue:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                      success:(void (^)(CJResponseModel *responseModel))success
                                      failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self real_postUploadUrl:Url params:customParams settingModel:settingModel fileKey:fileKey fileValue:uploadFileModels progress:uploadProgress completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
        [self splitCompleteBlockWithFailureType:failureType responseModel:responseModel toSuccess:success failure:failure];
    }];
}


#pragma mark simulate
- (NSURLSessionDataTask *)simulate2_getApi:(NSString *)apiSuffix
                                    params:(NSDictionary *)params
                              settingModel:(CJRequestSettingModel *)settingModel
                                   success:(void (^)(CJResponseModel *responseModel))success
                                   failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self simulate_getApi:apiSuffix params:params settingModel:settingModel completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
        [self splitCompleteBlockWithFailureType:failureType responseModel:responseModel toSuccess:success failure:failure];
    }];
}

- (NSURLSessionDataTask *)simulate2_postApi:(NSString *)apiSuffix
                                     params:(id)params
                               settingModel:(CJRequestSettingModel *)settingModel
                                    success:(void (^)(CJResponseModel *responseModel))success
                                    failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self simulate_postApi:apiSuffix params:params settingModel:settingModel completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
        [self splitCompleteBlockWithFailureType:failureType responseModel:responseModel toSuccess:success failure:failure];
    }];
}

- (NSURLSessionDataTask *)simulate2_postUploadUrl:(nullable NSString *)Url
                                       params:(nullable NSDictionary *)customParams
                                 settingModel:(CJRequestSettingModel *)settingModel
                                      fileKey:(nullable NSString *)fileKey
                                    fileValue:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                      success:(void (^)(CJResponseModel *responseModel))success
                                      failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self simulate_postUploadUrl:Url params:customParams settingModel:settingModel fileKey:fileKey fileValue:uploadFileModels progress:uploadProgress completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
        [self splitCompleteBlockWithFailureType:failureType responseModel:responseModel toSuccess:success failure:failure];
    }];
}

#pragma mark - localApi
- (NSURLSessionDataTask *)local2_getApi:(NSString *)apiSuffix
                                 params:(NSDictionary *)params
                           settingModel:(CJRequestSettingModel *)settingModel
                                success:(void (^)(CJResponseModel *responseModel))success
                                failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self local_getApi:apiSuffix params:params settingModel:settingModel completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
        [self splitCompleteBlockWithFailureType:failureType responseModel:responseModel toSuccess:success failure:failure];
    }];
}

- (NSURLSessionDataTask *)local2_postApi:(NSString *)apiSuffix
                                  params:(id)params
                            settingModel:(CJRequestSettingModel *)settingModel
                                 success:(void (^)(CJResponseModel *responseModel))success
                                 failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self local_postApi:apiSuffix params:params settingModel:settingModel completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
        [self splitCompleteBlockWithFailureType:failureType responseModel:responseModel toSuccess:success failure:failure];
    }];
}

- (NSURLSessionDataTask *)local2_postUploadUrl:(nullable NSString *)Url
                                        params:(nullable NSDictionary *)customParams
                                  settingModel:(CJRequestSettingModel *)settingModel
                                       fileKey:(nullable NSString *)fileKey
                                     fileValue:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                      progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                       success:(void (^)(CJResponseModel *responseModel))success
                                       failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self local_postUploadUrl:Url params:customParams settingModel:settingModel fileKey:fileKey fileValue:uploadFileModels progress:uploadProgress completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
        [self splitCompleteBlockWithFailureType:failureType responseModel:responseModel toSuccess:success failure:failure];
    }];
}

#pragma mark - Base
///**
// *  进行请求
// *
// *  @param Url          Url
// *  @param customParams customParams
// *  @param method       method
// *  @param settingModel settingModel
// *  @param success      success(CJResponeFailureTypeNeedFurtherJudgeFailure走的方法)
// *  @param failure      failure(CJResponeFailureTypeRequestFailure和CJResponeFailureTypeCommonFailure走的方法)
// */
//- (nullable NSURLSessionDataTask *)requestUrl:(nullable NSString *)Url
//                                       params:(nullable id)customParams
//                                       method:(CJRequestMethod)method
//                                 settingModel:(CJRequestSettingModel *)settingModel
//                                      success:(void (^)(CJResponseModel *responseModel))success
//                                      failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
//{
//    return [self requestUrl:Url params:customParams method:method settingModel:settingModel completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
//
//        if (failureType == CJResponeFailureTypeCommonFailure) {
//            !failure ?: failure(NO, responseModel.message);
//
//        } else if (failureType == CJResponeFailureTypeRequestFailure) {
//            !failure ?: failure(YES, responseModel.message);
//
//        } else {
//            !success ?: success(responseModel);
//        }
//    }];
//}


- (void)splitCompleteBlockWithFailureType:(CJResponeFailureType)failureType
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

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

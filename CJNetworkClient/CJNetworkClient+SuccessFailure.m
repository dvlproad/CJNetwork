//
//  CJNetworkClient+SuccessFailure.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJNetworkClient+SuccessFailure.h"

#import "CJNetworkClient+Completion.h"

@implementation CJNetworkClient (SuccessFailure)

#pragma mark - RealApi
- (NSURLSessionDataTask *)real2_getApi:(NSString *)apiSuffix
                                params:(NSDictionary *)params
                          settingModel:(nullable CJRequestSettingModel *)settingModel
                               success:(void (^)(CJResponseModel *responseModel))success
                               failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self real1_getApi:apiSuffix params:params settingModel:settingModel completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
        [self __splitCompleteBlockWithFailureType:failureType responseModel:responseModel toSuccess:success failure:failure];
    }];
}

- (NSURLSessionDataTask *)real2_postApi:(NSString *)apiSuffix
                                 params:(id)params
                           settingModel:(nullable CJRequestSettingModel *)settingModel
                                success:(void (^)(CJResponseModel *responseModel))success
                                failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self real1_postApi:apiSuffix params:params settingModel:settingModel completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
        [self __splitCompleteBlockWithFailureType:failureType responseModel:responseModel toSuccess:success failure:failure];
    }];
}


#pragma mark - simulateApi
- (NSURLSessionDataTask *)simulate2_getApi:(NSString *)apiSuffix
                                    params:(NSDictionary *)params
                              settingModel:(nullable CJRequestSettingModel *)settingModel
                                   success:(void (^)(id responseModel))success
                                   failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self simulate1_getApi:apiSuffix params:params settingModel:settingModel completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
        [self __splitCompleteBlockWithFailureType:failureType responseModel:responseModel toSuccess:success failure:failure];
    }];
}

- (NSURLSessionDataTask *)simulate2_postApi:(NSString *)apiSuffix
                                     params:(id)params
                               settingModel:(nullable CJRequestSettingModel *)settingModel
                                    success:(void (^)(id responseModel))success
                                    failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self simulate1_postApi:apiSuffix params:params settingModel:settingModel completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
        [self __splitCompleteBlockWithFailureType:failureType responseModel:responseModel toSuccess:success failure:failure];
    }];
}

#pragma mark - localApi
- (nullable NSURLSessionDataTask *)local2_getApi:(NSString *)apiSuffix
                                 params:(NSDictionary *)params
                           settingModel:(nullable CJRequestSettingModel *)settingModel
                                success:(void (^)(id responseModel))success
                                failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self local1_getApi:apiSuffix params:params settingModel:settingModel completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
        [self __splitCompleteBlockWithFailureType:failureType responseModel:responseModel toSuccess:success failure:failure];
    }];
}

- (nullable NSURLSessionDataTask *)local2_postApi:(NSString *)apiSuffix
                                  params:(id)params
                            settingModel:(nullable CJRequestSettingModel *)settingModel
                                 success:(void (^)(id responseModel))success
                                 failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self local1_postApi:apiSuffix params:params settingModel:settingModel completeBlock:^(CJResponeFailureType failureType, CJResponseModel *responseModel) {
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

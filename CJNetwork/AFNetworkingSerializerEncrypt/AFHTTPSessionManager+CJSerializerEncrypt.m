//
//  AFHTTPSessionManager+CJSerializerEncrypt.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/6/13.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "AFHTTPSessionManager+CJSerializerEncrypt.h"

@implementation AFHTTPSessionManager (CJSerializerEncrypt)

/* 完整的描述请参见文件头部 */
- (nullable NSURLSessionDataTask *)cj_getUrl:(NSString *)Url
                                      params:(nullable NSDictionary *)allParams
                                settingModel:(nullable CJRequestSettingModel *)settingModel
                                     success:(nullable void (^)(id _Nullable responseObject))success
                                     failure:(nullable void (^)(NSString *errorMessage))failure
{
    return [self cj_requestUrl:Url params:allParams method:CJRequestMethodGET settingModel:settingModel success:^(CJSuccessRequestInfo * _Nullable successRequestInfo) {
        NSDictionary *responseDictionary = successRequestInfo.responseObject;
        if (success) {
            success(responseDictionary);
        }
        
    } failure:^(CJFailureRequestInfo * _Nullable failureRequestInfo) {
        NSString *errorMessage = failureRequestInfo.errorMessage;
        if (failure) {
            failure(errorMessage);
        }
    }];
}

/** 完整的描述请参见文件头部 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(NSString *)Url
                                       params:(nullable id)allParams
                                 settingModel:(nullable CJRequestSettingModel *)settingModel
                                      success:(nullable void (^)(id _Nullable responseObject))success
                                      failure:(nullable void (^)(NSString *errorMessage))failure
{
    return [self cj_requestUrl:Url params:allParams method:CJRequestMethodPOST settingModel:settingModel success:^(CJSuccessRequestInfo * _Nullable successRequestInfo) {
        NSDictionary *responseDictionary = successRequestInfo.responseObject;
        if (success) {
            success(responseDictionary);
        }
        
    } failure:^(CJFailureRequestInfo * _Nullable failureRequestInfo) {
        NSString *errorMessage = failureRequestInfo.errorMessage;
        if (failure) {
            failure(errorMessage);
        }
    }];
}


- (nullable NSURLSessionDataTask *)cj_requestUrl:(NSString *)Url
                                          params:(nullable id)allParams
                                          method:(CJRequestMethod)method
                                    settingModel:(nullable CJRequestSettingModel *)settingModel
                                         success:(nullable void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo))success
                                         failure:(nullable void (^)(CJFailureRequestInfo * _Nullable failureRequestInfo))failure
{
    if (settingModel == nil) {
        settingModel = [[CJRequestSettingModel alloc] init];
        settingModel.logType = CJRequestLogTypeConsoleLog;
    }
    
    BOOL shouldStartRequestNetworkData = [self __didEventBeforeStartRequestWithUrl:Url params:allParams settingModel:settingModel success:success];
    if (shouldStartRequestNetworkData == NO) {
        return nil;
    }

    if (method == CJRequestMethodGET) {
        NSURLSessionDataTask *URLSessionDataTask =
        [self GET:Url parameters:allParams progress:settingModel.uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self __didRequestSuccessForTask:task withResponseObject:responseObject isCacheData:NO forUrl:Url params:allParams settingModel:settingModel success:success];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self __didRequestFailureForTask:task withResponseError:error forUrl:Url params:allParams settingModel:settingModel failure:failure];
        }];
        
        return URLSessionDataTask;
        
    } else {
        NSURLSessionDataTask *URLSessionDataTask =
        [self POST:Url parameters:allParams progress:settingModel.uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self __didRequestSuccessForTask:task withResponseObject:responseObject isCacheData:NO forUrl:Url params:allParams settingModel:settingModel success:success];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self __didRequestFailureForTask:task withResponseError:error forUrl:Url params:allParams settingModel:settingModel failure:failure];
        }];
        
        return URLSessionDataTask;
    }
}

@end

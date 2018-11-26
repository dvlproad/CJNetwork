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
- (nullable NSURLSessionDataTask *)cj_getUrl:(nullable NSString *)Url
                                      params:(nullable NSDictionary *)params
                                settingModel:(CJRequestSettingModel *)settingModel
                                     success:(nullable void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo))success
                                     failure:(nullable void (^)(CJFailureRequestInfo * _Nullable failureRequestInfo))failure
{
    return [self cj_requestUrl:Url params:params method:CJRequestMethodGET settingModel:settingModel success:success failure:failure];
}

/** 完整的描述请参见文件头部 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                                 settingModel:(CJRequestSettingModel *)settingModel
                                      success:(nullable void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo))success
                                      failure:(nullable void (^)(CJFailureRequestInfo * _Nullable failureRequestInfo))failure
{
    return [self cj_requestUrl:Url params:params method:CJRequestMethodPOST settingModel:settingModel success:success failure:failure];
}


- (nullable NSURLSessionDataTask *)cj_requestUrl:(nullable NSString *)Url
                                          params:(nullable id)params
                                          method:(CJRequestMethod)method
                                    settingModel:(CJRequestSettingModel *)settingModel
                                         success:(nullable void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo))success
                                         failure:(nullable void (^)(CJFailureRequestInfo * _Nullable failureRequestInfo))failure
{
    if (settingModel == nil) {
        settingModel = [[CJRequestSettingModel alloc] init];
        settingModel.logType = CJRequestLogTypeConsoleLog;
    }
    
    BOOL shouldStartRequestNetworkData = [self __didEventBeforeStartRequestWithUrl:Url params:params settingModel:settingModel success:success];
    if (shouldStartRequestNetworkData == NO) {
        return nil;
    }

    if (method == CJRequestMethodGET) {
        NSURLSessionDataTask *URLSessionDataTask =
        [self GET:Url parameters:params progress:settingModel.uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self __didRequestSuccessForTask:task withResponseObject:responseObject isCacheData:NO forUrl:Url params:params settingModel:settingModel success:success];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self __didRequestFailureForTask:task withResponseError:error forUrl:Url params:params settingModel:settingModel failure:failure];
        }];
        
        return URLSessionDataTask;
        
    } else {
        NSURLSessionDataTask *URLSessionDataTask =
        [self POST:Url parameters:params progress:settingModel.uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self __didRequestSuccessForTask:task withResponseObject:responseObject isCacheData:NO forUrl:Url params:params settingModel:settingModel success:success];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self __didRequestFailureForTask:task withResponseError:error forUrl:Url params:params settingModel:settingModel failure:failure];
        }];
        
        return URLSessionDataTask;
    }
}

@end

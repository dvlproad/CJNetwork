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
                                     success:(nullable void (^)(CJSuccessNetworkInfo * _Nullable successNetworkInfo))success
                                     failure:(nullable void (^)(CJFailureNetworkInfo * _Nullable failureNetworkInfo))failure
{
    if (settingModel == nil) {
        settingModel = [[CJRequestSettingModel alloc] init];
        settingModel.logType = CJNetworkLogTypeConsoleLog;
    }
    
    __weak typeof(self)weakSelf = self;
    NSURLSessionDataTask *dataTask =
    [self GET:Url parameters:params progress:settingModel.uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf __didRequestSuccessForTask:task withResponseObject:responseObject isCacheData:NO forUrl:Url params:params settingModel:settingModel success:success];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf __didCacheRequestFailureForTask:task withResponseError:error forUrl:Url params:params settingModel:settingModel failure:failure getCacheSuccess:success];
    }];
    
    return dataTask;
}

/** 完整的描述请参见文件头部 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                                 settingModel:(CJRequestSettingModel *)settingModel
                                      success:(nullable void (^)(CJSuccessNetworkInfo * _Nullable successNetworkInfo))success
                                      failure:(nullable void (^)(CJFailureNetworkInfo * _Nullable failureNetworkInfo))failure
{
    if (settingModel == nil) {
        settingModel = [[CJRequestSettingModel alloc] init];
        settingModel.logType = CJNetworkLogTypeConsoleLog;
    }
    
    __weak typeof(self)weakSelf = self;
    NSURLSessionDataTask *URLSessionDataTask =
    [self POST:Url parameters:params progress:settingModel.uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf __didRequestSuccessForTask:task withResponseObject:responseObject isCacheData:NO forUrl:Url params:params settingModel:settingModel success:success];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf __didCacheRequestFailureForTask:task withResponseError:error forUrl:Url params:params settingModel:settingModel failure:failure getCacheSuccess:success];
    }];
    
    return URLSessionDataTask;
}


@end

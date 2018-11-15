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
        [weakSelf __didRequestSuccessForTask:task withResponseObject:responseObject forUrl:Url params:params settingModel:settingModel success:success];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf __didRequestFailureForTask:task withResponseError:error forUrl:Url params:params settingModel:settingModel failure:failure];
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
        [weakSelf __didRequestSuccessForTask:task withResponseObject:responseObject forUrl:Url params:params settingModel:settingModel success:success];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf __didRequestFailureForTask:task withResponseError:error forUrl:Url params:params settingModel:settingModel failure:failure];
    }];
    
    return URLSessionDataTask;
}


#pragma mark - Private
///请求得到数据时候执行的方法
- (void)__didRequestSuccessForTask:(NSURLSessionDataTask * _Nonnull)task
              withResponseObject:(nullable id)responseObject
                          forUrl:(nullable NSString *)Url
                          params:(nullable id)params
                    settingModel:(CJRequestSettingModel *)settingModel
                         success:(nullable void (^)(CJSuccessNetworkInfo * _Nullable successNetworkInfo))success
{
    NSURLRequest *request = task.originalRequest;
    CJNetworkLogType logType = settingModel.logType;
    
    CJSuccessNetworkInfo *successNetworkInfo = [CJSuccessNetworkInfo successNetworkLogWithType:logType Url:Url params:params request:request responseObject:responseObject];
    if (success) {
        success(successNetworkInfo);
    }
    
}

///请求不到数据时候（无网 或者 有网但服务器异常等无数据时候）执行的方法
- (void)__didRequestFailureForTask:(NSURLSessionDataTask * _Nonnull)task
               withResponseError:(NSError * _Nullable)error
                          forUrl:(nullable NSString *)Url
                          params:(nullable id)params
                    settingModel:(CJRequestSettingModel *)settingModel
                         failure:(nullable void (^)(CJFailureNetworkInfo * _Nullable failureNetworkInfo))failure
{
    NSURLRequest *request = task.originalRequest;
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    CJNetworkLogType logType = settingModel.logType;
    CJFailureNetworkInfo *failureNetworkInfo = [CJFailureNetworkInfo errorNetworkLogWithType:logType Url:Url params:params request:request error:error URLResponse:response];
    if (failure) {
        failure(failureNetworkInfo);
    }
}


@end

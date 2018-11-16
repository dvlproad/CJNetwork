//
//  AFHTTPSessionManager+CJReponseOrError.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/6/13.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "AFHTTPSessionManager+CJReponseOrError.h"

@implementation AFHTTPSessionManager (CJReponseOrError)

///得到缓存数据时候执行的方法
- (void)__didGetCacheSuccessWithResponseObject:(nullable id)responseObject
                            forUrl:(nullable NSString *)Url
                            params:(nullable id)params
                      settingModel:(CJRequestSettingModel *)settingModel
                           success:(nullable void (^)(CJSuccessNetworkInfo * _Nullable successNetworkInfo))success
{
    NSURLRequest *request = nil;
    CJNetworkLogType logType = settingModel.logType;
    
    CJSuccessNetworkInfo *successNetworkInfo = [CJSuccessNetworkInfo successNetworkLogWithType:logType Url:Url params:params request:request responseObject:responseObject];
    successNetworkInfo.isCacheData = YES;
    if (success) {
        success(successNetworkInfo);
    }
}

///网络请求获取到数据时候执行的方法(responseObject必须是解密后的数据)
- (void)__didRequestSuccessForTask:(NSURLSessionDataTask * _Nonnull)task
                withResponseObject:(nullable id)responseObject
                       isCacheData:(BOOL)isCacheData
                            forUrl:(nullable NSString *)Url
                            params:(nullable id)params
                      settingModel:(CJRequestSettingModel *)settingModel
                           success:(nullable void (^)(CJSuccessNetworkInfo * _Nullable successNetworkInfo))success
{
    CJNetworkCacheStrategy cacheStrategy = settingModel.cacheStrategy;
    if (cacheStrategy != CJNetworkCacheStrategyNoneCache) {  //是否需要本地缓存现在请求下来的网络数据
        [CJRequestCacheDataUtil cacheNetworkData:responseObject byRequestUrl:Url parameters:params cacheTimeInterval:settingModel.cacheTimeInterval];
    }
    
    NSURLRequest *request = task.originalRequest;
    CJNetworkLogType logType = settingModel.logType;
    
    CJSuccessNetworkInfo *successNetworkInfo = [CJSuccessNetworkInfo successNetworkLogWithType:logType Url:Url params:params request:request responseObject:responseObject];
    successNetworkInfo.isCacheData = isCacheData;
    if (success) {
        success(successNetworkInfo);
    }
}

///网络请求不到数据的时候（无网 或者 有网但服务器异常等无数据时候）执行的方法
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

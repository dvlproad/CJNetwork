//
//  AFHTTPSessionManager+CJReponseOrError.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/6/13.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "AFHTTPSessionManager+CJReponseOrError.h"

@implementation AFHTTPSessionManager (CJReponseOrError)

///请求得到数据时候执行的方法
- (void)__didRequestSuccessForTask:(NSURLSessionDataTask * _Nonnull)task
                withResponseObject:(nullable id)responseObject
                       isCacheData:(BOOL)isCacheData
                            forUrl:(nullable NSString *)Url
                            params:(nullable id)params
                      settingModel:(CJRequestSettingModel *)settingModel
                           success:(nullable void (^)(CJSuccessNetworkInfo * _Nullable successNetworkInfo))success
{
    BOOL shouldCache = settingModel.shouldCache;
    if (shouldCache) {  //是否需要本地缓存现在请求下来的网络数据
        [CJRequestCacheDataUtil cacheNetworkData:responseObject byRequestUrl:Url parameters:params];
    }
    
    NSURLRequest *request = task.originalRequest;
    CJNetworkLogType logType = settingModel.logType;
    
    CJSuccessNetworkInfo *successNetworkInfo = [CJSuccessNetworkInfo successNetworkLogWithType:logType Url:Url params:params request:request responseObject:responseObject];
    successNetworkInfo.isCacheData = isCacheData;
    if (success) {
        success(successNetworkInfo);
    }
}

///请求不到数据时候（无网 或者 有网但服务器异常等无数据时候）执行的方法
- (void)__didCacheRequestFailureForTask:(NSURLSessionDataTask * _Nonnull)task
                 withResponseError:(NSError * _Nullable)error
                            forUrl:(nullable NSString *)Url
                            params:(nullable id)params
                      settingModel:(CJRequestSettingModel *)settingModel
                           failure:(nullable void (^)(CJFailureNetworkInfo * _Nullable failureNetworkInfo))failure
                   getCacheSuccess:(nullable void (^)(CJSuccessNetworkInfo * _Nullable successNetworkInfo))success
{
    BOOL shouldGetCache = settingModel.shouldCache;
    
    if (shouldGetCache) {
        [CJRequestCacheDataUtil requestCacheDataByUrl:Url params:params success:^(NSDictionary * _Nullable responseObject) {
            [self __didRequestSuccessForTask:task withResponseObject:responseObject isCacheData:YES forUrl:Url params:params settingModel:settingModel success:success];
            
        } failure:^(CJRequestCacheFailureType failureType) {
            //从服务器请求不到数据，连从缓存中也都取不到
            [self __didRequestFailureForTask:task withResponseError:error forUrl:Url params:params settingModel:settingModel failure:failure];
        }];
        
    } else {
        NSLog(@"提示：这里之前未缓存，无法读取缓存，提示网络不给力");
        //errorNetworkLog
        [self __didRequestFailureForTask:task withResponseError:error forUrl:Url params:params settingModel:settingModel failure:failure];
    }
}

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

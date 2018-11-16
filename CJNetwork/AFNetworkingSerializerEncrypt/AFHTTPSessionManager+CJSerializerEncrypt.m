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
    
    CJNetworkCacheStrategy cacheStrategy = settingModel.cacheStrategy;
    BOOL beforeStartRequestWillShowCache = YES; //在开始请求之前是否会先用缓存数据做一次快速显示
    BOOL shouldStartRequestNetworkData = YES;   //是否应该请求网络，如果最后不需要以实际的网络值显示，且能获取到缓存值，则不用进行请求
    if (cacheStrategy == CJNetworkCacheStrategyEndWithCacheIfExist) {
        //成功/失败的时候，如果有缓存，则不用再去取网络错误值
        beforeStartRequestWillShowCache = YES;
        shouldStartRequestNetworkData = NO;
        
    } else if (cacheStrategy == CJNetworkCacheStrategyUseCacheToTransition) {
        //成功/失败的时候，如果有缓存，使用缓存过去，最终以网络数据显示
        beforeStartRequestWillShowCache = YES;
        shouldStartRequestNetworkData = YES;
        
    } else { //CJNetworkCacheStrategyNoneCache
        //NSLog(@"提示：这里之前不使用缓存，也就无法读取缓存，提示网络不给力");
        beforeStartRequestWillShowCache = NO;
        shouldStartRequestNetworkData = YES;
    }
    
    if (beforeStartRequestWillShowCache) {
        NSDictionary * responseObject = [CJRequestCacheDataUtil requestCacheDataByUrl:Url params:params];
        if (responseObject) {
            [self __didGetCacheSuccessWithResponseObject:responseObject forUrl:Url params:params settingModel:settingModel success:success];
        } else { //获取缓存失败一定要进行请求，且一旦进行请求，最后肯定是以网络请求数据作为最后的显示，要不你请求干嘛
            shouldStartRequestNetworkData = YES;
        }
    }
    
    if (shouldStartRequestNetworkData == NO) {
        return nil;
    }
    
    __weak typeof(self)weakSelf = self;
    NSURLSessionDataTask *dataTask =
    [self GET:Url parameters:params progress:settingModel.uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf __didRequestSuccessForTask:task withResponseObject:responseObject isCacheData:NO forUrl:Url params:params settingModel:settingModel success:success];
        
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
        [weakSelf __didRequestSuccessForTask:task withResponseObject:responseObject isCacheData:NO forUrl:Url params:params settingModel:settingModel success:success];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf __didRequestFailureForTask:task withResponseError:error forUrl:Url params:params settingModel:settingModel failure:failure];
    }];
    
    return URLSessionDataTask;
}


@end

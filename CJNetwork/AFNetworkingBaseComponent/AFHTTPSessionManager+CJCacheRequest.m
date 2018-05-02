//
//  AFHTTPSessionManager+CJCacheRequest.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "AFHTTPSessionManager+CJCacheRequest.h"
#import <objc/runtime.h>

#import "CJRequestErrorMessageUtil.h"

@implementation AFHTTPSessionManager (CJCategory)

#pragma mark - runtime
//static NSString *cjNoNetworkHandleKey = @"cjNoNetworkHandleKey";
//
//- (void (^)(void))cjNoNetworkHandle {
//    return objc_getAssociatedObject(self, (__bridge const void *)(cjNoNetworkHandleKey));
//}
//
//- (void)setCjNoNetworkHandle:(void (^)(void))cjNoNetworkHandle {
//    objc_setAssociatedObject(self, (__bridge const void *)(cjNoNetworkHandleKey), cjNoNetworkHandle, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}

/** 完整的描述请参见文件头部 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                                        cache:(BOOL)cache
                                      success:(nullable void (^)(NSDictionary *_Nullable responseObject, BOOL isCacheData))success
                                      failure:(nullable void (^)(NSError * _Nullable error))failure
{
    CJNeedGetCacheOption cacheOption = CJNeedGetCacheOptionNetworkUnable | CJNeedGetCacheOptionRequestFailure;
    NSURLSessionDataTask *URLSessionDataTask = [self cj_postUrl:Url
                                                         params:params
                                                    cacheOption:cacheOption
                                                       progress:nil
                                                        success:success
                                                        failure:failure];
    return URLSessionDataTask;
    
}


/**
 *  发起请求
 *
 *  @param Url              Url
 *  @param params           params
 *  @param cacheOption      需要缓存网络数据的情况(如果有缓存，则即代表可以从缓存中获取数据)
 *  @param uploadProgress   uploadProgress
 *  @param success          请求成功的回调success
 *  @param failure          请求失败的回调failure
 *
 *  return NSURLSessionDataTask
 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                                  cacheOption:(CJNeedGetCacheOption)cacheOption
                                 //encacheBlock:(nullable NSData * _Nullable (^)(NSDictionary * _Nullable requestParmas))encacheBlock
                                 //decacheBlock:(nullable NSDictionary * _Nullable (^)(NSString * _Nullable responseString))decacheBlock
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                      success:(nullable void (^)(NSDictionary *_Nullable responseObject, BOOL isCacheData))success
                                      failure:(nullable void (^)(NSError * _Nullable error))failure
{
    //注：如果网络一直判断失败，请检查之前是否从不曾调用过[[CJNetworkMonitor sharedInstance] startNetworkMonitoring];如是，请提前调用至少一次即可
    BOOL isNetworkEnabled = [CJNetworkMonitor sharedInstance].networkSuccess;
    if (isNetworkEnabled == NO) {
        /* 网络不可用，读取本地缓存数据 */
        if (cacheOption | CJNeedGetCacheOptionNetworkUnable) { //网络不可用的情况下有用到缓存
            [CJRequestCacheDataUtil requestCacheDataByUrl:Url params:params success:^(NSDictionary * _Nullable responseObject) {
                if (success) {
                    success(responseObject, YES);
                }
            } failure:^(CJRequestCacheFailureType failureType) {
                if (failure) {
                    NSString *errorMessage = NSLocalizedString(@"网络不给力", nil);
                    NSError *error = [CJRequestErrorMessageUtil getNewErrorWithError:nil cjErrorMeesage:errorMessage];

                    if (failure == CJRequestCacheFailureTypeCacheKeyNil) {
                        failure(error);
                    } else {
                        failure(error);
                    }
                    
                }
            }];
            
        } else {
            NSLog(@"提示：这里之前未缓存，无法读取缓存，提示网络不给力");
            if (failure) {
                NSString *errorMessage = NSLocalizedString(@"网络不给力", nil);
                NSError *error = [CJRequestErrorMessageUtil getNewErrorWithError:nil cjErrorMeesage:errorMessage];
                failure(error);
            }
            
            
        }
        
        return nil;
        
    } else {
        /* 网络可用，直接下载数据，并根据是否需要缓存来进行缓存操作 */
        NSURLSessionDataTask *URLSessionDataTask = [self POST:Url parameters:params progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject, NO);//有网络的时候,responseObject等就不是来源磁盘(缓存),故为NO
            }
            
            BOOL shouldCache = cacheOption | CJNeedGetCacheOptionNetworkUnable | CJNeedGetCacheOptionRequestFailure; //是否需要本地缓存现在请求下来的网络数据
            if (shouldCache) {
                [CJRequestCacheDataUtil cacheNetworkData:responseObject byRequestUrl:Url parameters:params];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (cacheOption | CJNeedGetCacheOptionRequestFailure) { //有网，但是请求地址或者服务器错误等
                [CJRequestCacheDataUtil requestCacheDataByUrl:Url params:params success:^(NSDictionary * _Nullable responseObject) {
                    if (success) {
                        success(responseObject, YES);
                    }
                } failure:^(CJRequestCacheFailureType failureType) {
                    //从服务器请求不到数据，连从缓存中也都取不到
                    if (failure) {
                        NSString *errorMessage = NSLocalizedString(@"网络不给力", nil);
                        NSError *error = [CJRequestErrorMessageUtil getNewErrorWithError:nil cjErrorMeesage:errorMessage];
                        if (failure == CJRequestCacheFailureTypeCacheKeyNil) {
                            failure(error);
                        } else {
                            failure(error);
                        }
                        
                    }
                }];
                
            } else {
                if (failure) {
                    NSString *cjErrorMeesage = [CJRequestErrorMessageUtil getErrorMessageFromURLSessionTask:task];
                    NSError *newError = [CJRequestErrorMessageUtil getNewErrorWithError:error cjErrorMeesage:cjErrorMeesage];
                    failure(newError);
                }
            }
            
        }];
        
        return URLSessionDataTask;
    }
}


@end

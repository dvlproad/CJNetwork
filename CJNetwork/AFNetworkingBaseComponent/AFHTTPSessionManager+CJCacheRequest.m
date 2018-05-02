//
//  AFHTTPSessionManager+CJCacheRequest.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "AFHTTPSessionManager+CJCacheRequest.h"
#import <objc/runtime.h>

@implementation AFHTTPSessionManager (CJCategory)

#pragma mark - runtime
static NSString *cjNoNetworkHandleKey = @"cjNoNetworkHandleKey";

- (void (^)(void))cjNoNetworkHandle {
    return objc_getAssociatedObject(self, (__bridge const void *)(cjNoNetworkHandleKey));
}

- (void)setCjNoNetworkHandle:(void (^)(void))cjNoNetworkHandle {
    objc_setAssociatedObject(self, (__bridge const void *)(cjNoNetworkHandleKey), cjNoNetworkHandle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


/** 完整的描述请参见文件头部 */
- (nullable NSURLSessionDataTask *)cj_postRequestUrl:(nullable NSString *)Url
                                          parameters:(nullable id)parameters
                                            progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                             success:(nullable AFRequestSuccess)success
                                             failure:(nullable AFRequestFailure)failure
{
    //注：如果网络一直判断失败，请检查之前是否从不曾调用过[[CJNetworkMonitor sharedInstance] startNetworkMonitoring];如是，请提前调用至少一次即可
    BOOL isNetworkEnabled = [CJNetworkMonitor sharedInstance].networkSuccess;
    if (isNetworkEnabled == NO) {//网络不可用
        [self hud_showNoNetwork];
        return nil;
    }
    
    //网络可用
    NSURLSessionDataTask *URLSessionDataTask = [self POST:Url parameters:parameters progress:uploadProgress success:success failure:failure];
    
    return URLSessionDataTask;
}

/** 完整的描述请参见文件头部 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                                        cache:(BOOL)cacheReuqestData
                                      success:(nullable void (^)(NSDictionary *_Nullable responseObject, BOOL isCacheData))success
                                      failure:(nullable void (^)(NSError * _Nullable error, CJRequestFailureType failureType))failure
{
//    NSDictionary * (^encacheBlock)(NSString *responseString) = ^NSDictionary *(NSString *responseString) {
//        NSDictionary *responseObject = [BBXCrypt decryptWithJsonStr:responseString];
//        return responseObject;
//    };
    
}

- (nullable NSURLSessionDataTask *)cj_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                                        cache:(BOOL)cacheReuqestData
                                 encacheBlock:(nullable NSData * _Nullable (^)(NSDictionary * _Nullable requestParmas))encacheBlock
                                 decacheBlock:(nullable NSDictionary * _Nullable (^)(NSString * _Nullable responseString))decacheBlock
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                      success:(nullable void (^)(NSDictionary *_Nullable responseObject, BOOL isCacheData))success
                                      failure:(nullable void (^)(NSError * _Nullable error, CJRequestFailureType failureType))failure
{
    //注：如果网络一直判断失败，请检查之前是否从不曾调用过[[CJNetworkMonitor sharedInstance] startNetworkMonitoring];如是，请提前调用至少一次即可
    BOOL isNetworkEnabled = [CJNetworkMonitor sharedInstance].networkSuccess;
    if (isNetworkEnabled == NO) {
        /* 网络不可用，读取本地缓存数据 */
        if (cacheReuqestData) {
            [CJRequestCacheDataUtil requestCacheDataByUrl:Url params:params success:^(NSDictionary * _Nullable responseObject) {
                if (success) {
                    success(responseObject, YES);
                }
            } failure:^(NSError * _Nullable error, CJRequestFailureType failureType) {
                if (failure) {
                    failure(error, failureType);
                }
            }];
            
        } else {
            NSLog(@"提示：这里之前未缓存，无法读取缓存，提示网络不给力");
            
//            if (failure) {
//                failure(nil, CJRequestFailureTypeNoNetworkAndNoCache);
//            }
            [self hud_showNoNetwork];
        }
        
        
        
    } else {
        /* 网络可用，直接下载数据，并根据是否需要缓存来进行缓存操作 */
        NSURLSessionDataTask *URLSessionDataTask = [self POST:Url parameters:params progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject, NO);//有网络的时候,responseObject等就不是来源磁盘(缓存),故为NO
            }
            
            if (cacheReuqestData) { //是否需要本地缓存现在请求下来的网络数据
                [CJRequestCacheDataUtil cacheNetworkData:responseObject byRequestUrl:Url parameters:params];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //有网，但是请求地址或者服务器错误等
            if (failure) {
                failure(error, fromRequestCacheData);
            }
        }];
        
        return URLSessionDataTask;
    }
}

#pragma mark - 私有方法
- (void)hud_showNoNetwork {
    if (self.cjNoNetworkHandle) {
//        NSString *errorMessage = NSLocalizedString(@"网络不给力", nil);
//        NSError *error = [self networkErrorWithLocalizedDescription:errorMessage];
//        failure(error, CJRequestFailureTypeNoCacheRequest);
        self.cjNoNetworkHandle();
        //附：cjNoNetworkHandle一般为[SVProgressHUD showErrorWithStatus:NSLocalizedString(@"网络不给力", nil)];
    } else {
        NSLog(@"网络不给力");
    }
}




@end

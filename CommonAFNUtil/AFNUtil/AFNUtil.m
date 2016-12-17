//
//  AFNUtil.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "AFNUtil.h"
#import "AFHTTPRequestOperation+Get.h"
#import "CommonDataCacheManager.h"

@implementation AFNUtil

#pragma mark - 公共方法
/** 完整的描述请参见文件头部 */
+ (NSURLSessionDataTask *)useManager:(AFHTTPSessionManager *)manager
                      postRequestUrl:(NSString *)Url
                          parameters:(id)parameters
                            progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                             success:(CJRequestSuccess)success
                             failure:(CJRequestFailure)failure {
    
    BOOL isNetworkEnabled = [AFNetworkReachabilityManager sharedManager].isReachable;
    if (isNetworkEnabled == NO) {//网络不可用
        [self hud_showNoNetwork];
        return nil;
    }
        
    //网络可用
    NSURLSessionDataTask *URLSessionDataTask = [manager POST:Url parameters:parameters progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
//            NSMutableDictionary *responseObject_dic = [operation responseObject_dic:operation];
//            success(operation, responseObject_dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
//        NSString *failMesg = [operation failMesg:operation];
//            failure(operation, failMesg);
    }];
    
    return URLSessionDataTask;
}

/** 完整的描述请参见文件头部 */
+ (NSURLSessionDataTask *)useManager:(AFHTTPSessionManager *)manager
                      postRequestUrl:(NSString *)Url
                          parameters:(NSDictionary *)parameters
                    cacheReuqestData:(BOOL)cacheReuqestData
                            progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                             success:(CJRequestCacheSuccess)success
                             failure:(CJRequestCacheFailure)failure {
    BOOL isNetworkEnabled = [AFNetworkReachabilityManager sharedManager].isReachable;
    if (isNetworkEnabled == NO) {
        /* 网络不可用，读取本地缓存数据 */
        BOOL canGetRequestDataFromCache = cacheReuqestData;
        [self requestDataFromCache:canGetRequestDataFromCache
                      ByRequestUrl:Url
                        parameters:parameters
                           success:success
                           failure:failure];
        
        return nil;
        
    } else {
        /* 网络可用，直接下载数据，并根据是否需要缓存来进行缓存操作 */
        NSURLSessionDataTask *URLSessionDataTask = [manager POST:Url parameters:parameters progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            BOOL fromRequestCacheData = NO;//有网络的时候,responseObject等就不是来源磁盘(缓存),故为NO
            if (success) {
                success(task, responseObject, fromRequestCacheData);
            }
            
            if (cacheReuqestData) { //本地缓存
                NSString *requestCacheKey = [self getRequestCacheKeyByRequestUrl:Url parameters:parameters];
                if (nil == requestCacheKey) {
                    NSLog(@"error: cacheKey == nil, 无法进行缓存");
                    
                }else{
                    if (!responseObject){
                        [[CommonDataCacheManager sharedCacheManager] removeMemoryCacheForKey:requestCacheKey];
                        
                    } else {
                        //TODO:responseObject(json) 转data
                        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
                        [[CommonDataCacheManager sharedCacheManager] cacheData:[dic convertToData] forCacheKey:requestCacheKey toDisk:YES];
                    }
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            BOOL fromRequestCacheData = NO;//有网络的时候,responseObject等就不是来源磁盘(缓存),故为NO
            if (failure) {
                failure(task, error, fromRequestCacheData);
            }
        }];
       
        return URLSessionDataTask;
    }
}

#pragma mark - 私有方法
+ (void)hud_showNoNetwork{
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"网络不给力", nil)];
}

/**
 *  获取请求的缓存数据（此方法，只有网络不给力的时候才会调用到）
 *
 *  @param fromRequestCacheData 是否获取请求的缓存数据
 *  @param Url                  Url
 *  @param parameters           parameters
 *  @param success              success
 *  @param failure              failure
 */
+ (void)requestDataFromCache:(BOOL)fromRequestCacheData
                ByRequestUrl:(NSString *)Url
                  parameters:(NSDictionary *)parameters
                     success:(CJRequestCacheSuccess)success
                     failure:(CJRequestCacheFailure)failure {
    NSURLSessionDataTask *URLSessionDataTask = nil;
    
    if (fromRequestCacheData == NO) {
        NSLog(@"提示：这里之前未缓存，无法读取缓存，提示网络不给力");
        [self hud_showNoNetwork];
        
        if (failure) {
            NSError *error = nil;
            failure(URLSessionDataTask, error, fromRequestCacheData);
        }
        return;
    }
    
    NSString *requestCacheKey = [self getRequestCacheKeyByRequestUrl:Url parameters:parameters];
    if (nil == requestCacheKey) {
        NSLog(@"error: cacheKey == nil, 无法读取缓存，提示网络不给力");
        [self hud_showNoNetwork];
        
        if (failure) {
            NSError *error = nil;
            failure(URLSessionDataTask, error, fromRequestCacheData);
        }
        return;
    }
    
    NSData *requestCacheData = [[CommonDataCacheManager sharedCacheManager] dataFromKey:requestCacheKey isMemoryCacheNil_then_getFromDisk:YES];
    if (requestCacheData) {
        //NSLog(@"读到缓存数据，但不保证该数据是最新的，因为网络还是不给力");
        
        if (success) {
            NSDictionary *responseObject = [requestCacheData convertToDictionary];
            success(URLSessionDataTask, responseObject, fromRequestCacheData);
        }
        
    } else {
        NSLog(@"未读到缓存数据，提示网络不给力");
        [self hud_showNoNetwork];
        
        if (failure) {
            NSError *error = nil;
            failure(URLSessionDataTask, error, fromRequestCacheData);
        }
    }
}

/**
 *  获取请求的缓存key
 *
 *  @param Url          Url
 *  @param parameters   parameters
 *
 *  return 请求的缓存key
 */
+ (NSString *)getRequestCacheKeyByRequestUrl:(NSString *)Url
                                  parameters:(NSDictionary *)parameters{
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [mutableDictionary setObject:Url forKey:@"cjRequestUrl"];
    
    NSString *string = [parameters convertToString];
    NSString *requestCacheKey = [string MD5];
    
    return requestCacheKey;
}


@end

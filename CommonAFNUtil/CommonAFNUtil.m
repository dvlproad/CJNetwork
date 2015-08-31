//
//  CommonAFNUtil.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CommonAFNUtil.h"
#import "ResponseAFNHandler.h"
#import "CommonHUD.h"
#import "CommonDataCacheManager.h"


@implementation CommonAFNUtil

#pragma mark - GET方式
+ (AFHTTPRequestOperation *)useManager:(AFHTTPRequestOperationManager *)manager getRequestUrl:(NSString *)Url params:(NSDictionary *)params delegate:(id<WebServiceAFNDelegate>)delegate tag:(NSInteger)tag{
    
    AFHTTPRequestOperation *operation =
    [manager GET:Url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ResponseAFNHandler onSuccess:operation callback:delegate tag:tag];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ResponseAFNHandler onFailure:operation callback:delegate tag:tag];
        
    }];
    return operation;
}


#pragma mark - POST方式获取数据
+ (AFHTTPRequestOperation *)useManager:(AFHTTPRequestOperationManager *)manager postRequestUrl:(NSString *)Url params:(NSDictionary *)params delegate:(id<WebServiceAFNDelegate>)delegate tag:(NSInteger)tag{
    
    AFHTTPRequestOperation *operation =
    [manager POST:Url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ResponseAFNHandler onSuccess:operation callback:delegate tag:tag];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ResponseAFNHandler onFailure:operation callback:delegate tag:tag];
        
    }];
    return operation;
}



+ (AFHTTPRequestOperation *)useManager:(AFHTTPRequestOperationManager *)manager
                        postRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    AFHTTPRequestOperation *operation =
    [self useManager:manager postRequestUrl:Url params:params useCache:NO success:^(AFHTTPRequestOperation *operation, id responseObject, BOOL isCacheData) {
        //因为useCache已设为NO，所以isCacheData一定为NO，所以这里无需if (isCacheData == YES)来区分情况。
        success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL isCacheData) {
        NSLog(@"error.userInfo = %@", error.userInfo);
        failure(operation, error);
    }];
    
    return operation;
    
    /*
    //上述等价于如下代码
    BOOL isNetworkEnabled = [AFNetworkReachabilityManager sharedManager].isReachable;
    if (isNetworkEnabled == NO) {
        NSLog(@"网络不给力");
        return nil;
        
    }else{
        AFHTTPRequestOperationManager *manager = [CommonAFNUtil manager];
        
        AFHTTPRequestOperation *operation =
        [manager POST:Url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                success(operation, responseObject);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure(operation, error);
            }
            
        }];
        return operation;
    }
    */
}


/*
typedef void(^onRequestSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject, BOOL isCacheData);
typedef void(^onRequestFailureBlock)(AFHTTPRequestOperation *operation, NSError *error, BOOL isCacheData);
注释：
 isCacheData代表数据来源：是否来自磁盘即缓存。
 当无网络的时候，就从磁盘中读取缓存，此时isCacheData=YES;与此同时，由于未使用网络所以operation也都为nil,而responseObject有值，error也为nil.
 有网络的时候，就直接使用网络数据，此时isCacheData=NO;与此同时，由于有使用网络所以operation、responseObject、error也都为当时的operation、responseObject、error。

 - (AFHTTPRequestOperation *)postRequestUrl:(NSString *)Url
 params:(NSDictionary *)params
 useCache:(BOOL)useCache
 success:(onRequestSuccessBlock)success
 failure:(onRequestFailureBlock)failure;
 */

+ (AFHTTPRequestOperation *)useManager:(AFHTTPRequestOperationManager *)manager
                        postRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                              useCache:(BOOL)useCache
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject, BOOL isCacheData))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error, BOOL isCacheData))failure{
    
    BOOL isNetworkEnabled = [AFNetworkReachabilityManager sharedManager].isReachable;
    if (isNetworkEnabled == NO) {
#pragma mark 网络不可用，读取本地缓存数据
        if (useCache == NO) {
            NSLog(@"提示：这里之前未缓存，无法读取缓存，提示网络不给力");
            [CommonHUD hud_showNoNetwork];
            return nil;
        }
        
        NSString *cacheKey = [[params convertToString] MD5];
        if (nil == cacheKey) {
            NSLog(@"error: cacheKey == nil, 无法读取缓存，提示网络不给力");
            [CommonHUD hud_showNoNetwork];
            return nil;
        }
        
        NSData *cacheData = [[CommonDataCacheManager sharedCacheManager]dataFromKey:cacheKey isMemoryCacheNil_then_getFromDisk:YES];
        if (cacheData) {
            NSDictionary *responseObject = [cacheData convertToDictionary];
            if (success) {
                success(nil, responseObject, YES);
            }
            
        }else{
            if (failure) {
                NSLog(@"未读到缓存数据，提示网络不给力");
                [CommonHUD hud_showNoNetwork];
                failure(nil, nil, YES);
            }
        }
        
        return nil;
        
    }else{
        
#pragma mark - 网络可用，直接下载数据，并根据是否需要缓存来进行缓存操作
        
        AFHTTPRequestOperation *operation =
        [manager POST:Url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                success(operation, responseObject, NO);//有网络的时候,responseObject等就不是来源磁盘(缓存),故为NO
            }
            
            if (useCache) { //本地缓存
                NSString *cacheKey = [[params convertToString] MD5];
                if (nil == cacheKey) {
                    NSLog(@"error: cacheKey == nil, 无法进行缓存");
                }else{
                    if (!responseObject){
                        [[CommonDataCacheManager sharedCacheManager] removeMemoryCacheForKey:cacheKey];
                        
                    }else{
                        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
                        [[CommonDataCacheManager sharedCacheManager] cacheData:[dic convertToData] forCacheKey:cacheKey toDisk:YES];
                    }
                }
            }
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure(operation, error, NO);
            }
            
        }];
        return operation;
    }
}




//POST_Request方式获取数据
+ (AFHTTPRequestOperation *)requestUrl:(NSString *)Url params:(NSDictionary *)params delegate:(id<WebServiceAFNDelegate>)delegate tag:(NSInteger)tag{
    NSMutableURLRequest *request = [CommonAFNUtil URLRequest_Url:Url params:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFHTTPResponseSerializer alloc];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ResponseAFNHandler onSuccess:operation callback:delegate tag:tag];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ResponseAFNHandler onFailure:operation callback:delegate tag:tag];
        
    }];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.operationQueue addOperation:operation];
    
    return operation;
}

#pragma mark - request定义
+ (NSMutableURLRequest *)URLRequest_Url:(NSString *)Url params:(NSDictionary *)params{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:Url]];
    
    NSMutableString *postData = [NSMutableString new];
    for (NSString *key in [params allKeys]) {
        id obj = [params valueForKey:key];
        if ([obj isKindOfClass:[NSString class]]) {
            if (postData.length!=0) {
                [postData appendString:@"&"];
            }
            [postData appendFormat:@"%@=%@",key,obj];
        }
        if ([obj isKindOfClass:[NSArray class]]) {
            for (NSString *value in obj) {
                if (postData.length!=0) {
                    [postData appendString:@"&"];
                }
                [postData appendFormat:@"%@=%@",key,value];
            }
        }
    }
    NSLog(@"postData = %@",postData);
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    //[request setValue:@"" forHTTPHeaderField:@"User-Agent"];
    
    return request;
}



+ (void)checkVersionWithAPPID:(NSString *)appid success:(void(^)(BOOL isLastest, NSString *app_trackViewUrl))success failure:(void(^)(void))failure{
    
    NSString *Url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appid];//你的应用程序的ID,如587767923
    
    BOOL isNetworkEnabled = [AFNetworkReachabilityManager sharedManager].isReachable;
    if (isNetworkEnabled == NO) {
        //NSLog(@"网络不给力");
        [CommonHUD hud_showNoNetwork];
    }else{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:Url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
            NSArray *infoArray = [dic objectForKey:@"results"];
            if ([infoArray count]) {
                NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                NSString *lastVersion = [releaseInfo objectForKey:@"version"];//获取appstore最新的版本号
                
                NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
                NSString *curVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
                //NSString *curVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
                
                NSLog(@"appStore最新版本号为:%@，本地版本号为:%@",lastVersion, curVersion);
                
                if (![lastVersion isEqualToString:curVersion]) {
                    NSString *trackViewUrl = [releaseInfo objectForKey:@"trackViewUrl"];//获取应用程序的地址:即应用程序在appstore中的介绍页面
                    success(NO, trackViewUrl);
                }else{
                    success(YES, nil);
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [CommonHUD hud_showText:@"检查更新请求发生错误"];
            failure();
        }];
    }
}



@end

//
//  CommonAFNInstance.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/10/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CommonAFNInstance.h"

@implementation CommonAFNInstance

+ (CommonAFNInstance *)shareCommonAFNInstance
{
    static CommonAFNInstance *_shareCommonAFNInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareCommonAFNInstance = [[self alloc] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return _shareCommonAFNInstance;
}


//GET
- (AFHTTPRequestOperation *)useManager_d:(AFHTTPRequestOperationManager *)manager
                         getRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                              delegate:(id<WebServiceAFNDelegate>)delegate{
    return [CommonAFNUtil useManager:manager getRequestUrl:Url params:params delegate:delegate tag:0];
}

- (AFHTTPRequestOperation *)useManager_d:(AFHTTPRequestOperationManager *)manager
                         getRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                              delegate:(id<WebServiceAFNDelegate>)delegate
                                   tag:(NSInteger)tag{
    return [CommonAFNUtil useManager:manager getRequestUrl:Url params:params delegate:delegate tag:tag];
}

//POST
- (AFHTTPRequestOperation *)useManager_d:(AFHTTPRequestOperationManager *)manager
                        postRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                              delegate:(id<WebServiceAFNDelegate>)delegate{
    
    return [CommonAFNUtil useManager:manager  postRequestUrl:Url params:params delegate:delegate tag:0];
}

- (AFHTTPRequestOperation *)useManager_d:(AFHTTPRequestOperationManager *)manager
                        postRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                              delegate:(id<WebServiceAFNDelegate>)delegate
                                   tag:(NSInteger)tag{
    return [CommonAFNUtil useManager:manager postRequestUrl:Url params:params delegate:delegate tag:tag];
}

- (AFHTTPRequestOperation *)useManager_b:(AFHTTPRequestOperationManager *)manager
                        postRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    return [CommonAFNUtil useManager:manager postRequestUrl:Url params:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)useManager_b:(AFHTTPRequestOperationManager *)manager
                        postRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                              useCache:(BOOL)useCache
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject, BOOL isCacheData))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error, BOOL isCacheData))failure{
    return [CommonAFNUtil useManager:manager postRequestUrl:Url params:params useCache:useCache success:success failure:failure];
}

//③POST_Request
- (AFHTTPRequestOperation *)requestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                              delegate:(id<WebServiceAFNDelegate>)delegate{
    return [CommonAFNUtil requestUrl:Url params:params delegate:delegate tag:0];
}
- (AFHTTPRequestOperation *)requestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                              delegate:(id<WebServiceAFNDelegate>)delegate
                                   tag:(NSInteger)tag{
    return [CommonAFNUtil requestUrl:Url params:params delegate:delegate tag:tag];
}

@end

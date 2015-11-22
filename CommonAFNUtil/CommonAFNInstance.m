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



- (AFHTTPRequestOperation *)useManager:(AFHTTPRequestOperationManager *)manager
                        postRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSString *failMesg))failure{
    return [AFNUtil useManager:manager postRequestUrl:Url params:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)useManager:(AFHTTPRequestOperationManager *)manager
                        postRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                              useCache:(BOOL)useCache
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject, BOOL isCacheData))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSString *failMesg, BOOL isCacheData))failure{
    return [AFNUtilCache useManager:manager postRequestUrl:Url params:params useCache:useCache success:success failure:failure];
}

@end

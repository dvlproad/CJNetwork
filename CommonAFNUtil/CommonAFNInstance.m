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



- (NSURLSessionDataTask *)useManager:(AFHTTPSessionManager *)manager
                      postRequestUrl:(NSString *)Url
                          parameters:(id)parameters
                            progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                             success:(CJRequestSuccess)success
                             failure:(CJRequestFailure)failure {
    return [AFNUtil useManager:manager
                postRequestUrl:Url
                    parameters:parameters
                      progress:uploadProgress
                       success:success
                       failure:failure];
}

- (NSURLSessionDataTask *)useManager:(AFHTTPSessionManager *)manager
                      postRequestUrl:(NSString *)Url
                          parameters:(NSDictionary *)parameters
                    cacheReuqestData:(BOOL)cacheReuqestData
                            progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                             success:(CJRequestCacheSuccess)success
                             failure:(CJRequestCacheFailure)failure {
    return [AFNUtil useManager:manager
                postRequestUrl:Url
                    parameters:parameters
              cacheReuqestData:cacheReuqestData
                      progress:uploadProgress
                       success:success
                       failure:failure];
}

@end

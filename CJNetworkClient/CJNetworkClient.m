//
//  CJNetworkClient.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "CJNetworkClient.h"

@implementation CJNetworkClient

+ (CJNetworkClient *)sharedInstance {
    static CJNetworkClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
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

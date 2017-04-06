//
//  CheckVersionNetworkClient.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "CheckVersionNetworkClient.h"
#import "CheckVersionNetworkClientHTTPSessionManager.h"

@implementation CheckVersionNetworkClient

+ (CheckVersionNetworkClient *)sharedInstance {
    static CheckVersionNetworkClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (NSURLSessionDataTask *)checkVersionWithAPPID:(NSString *)appid
                                        success:(void(^)(BOOL isLastest, NSString *app_trackViewUrl))success
                                        failure:(void(^)(void))failure {
    CheckVersionNetworkClientHTTPSessionManager *manager = [CheckVersionNetworkClientHTTPSessionManager sharedInstance];
    return [manager checkVersionWithAPPID:appid success:success failure:failure];
}

@end

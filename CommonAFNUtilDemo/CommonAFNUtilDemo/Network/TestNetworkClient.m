//
//  TestNetworkClient.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "TestNetworkClient.h"
#import "TestHTTPSessionManager.h"


@implementation TestNetworkClient

+ (TestNetworkClient *)sharedInstance {
    static TestNetworkClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)requestBaiduHomeSuccess:(AFRequestSuccess)success
                        failure:(AFRequestFailure)failure {
    NSString *Url = @"https://www.baidu.com";
    NSDictionary *parameters = nil;
    
    AFHTTPSessionManager *manager = [TestHTTPSessionManager sharedInstance];
    [manager cj_postRequestUrl:Url parameters:parameters cacheReuqestData:NO progress:nil success:^(NSURLSessionDataTask *task, id responseObject, BOOL isCacheData) {
        if (success) {
            success(task, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error, BOOL isCacheData) {
        if (failure) {
            failure(task, error);
        }
    }];
}

@end

//
//  HealthyNetworkClient.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "HealthyNetworkClient.h"
#import "HealthyHTTPSessionManager.h"


@implementation HealthyNetworkClient

+ (HealthyNetworkClient *)sharedInstance {
    static HealthyNetworkClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)requestLogin_name:(NSString *)name
                     pasd:(NSString*)pasd
                  success:(AFRequestSuccess)success
                  failure:(AFRequestFailure)failure
{
    NSString *Url = API_BASE_Url(@"login");
    NSDictionary *params = @{@"username" : name,
                             @"password" : pasd
                             };
    AFHTTPSessionManager *manager = [HealthyHTTPSessionManager sharedInstance];
    [manager cj_postRequestUrl:Url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取失败");
        failure(task, error);
    }];
    //    [self.indicatorView setAnimatingWithStateOfOperation:operation];
}


@end

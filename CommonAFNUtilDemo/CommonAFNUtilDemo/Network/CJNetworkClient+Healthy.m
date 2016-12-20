//
//  CJNetworkClient+Healthy.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "CJNetworkClient+Healthy.h"

@implementation CJNetworkClient (Healthy)

+ (void)requestLogin_name:(NSString *)name
                     pasd:(NSString*)pasd
                  success:(CJRequestSuccess)success
                  failure:(CJRequestFailure)failure
{
    NSString *Url = API_BASE_Url(@"login");
    NSDictionary *params = @{@"username" : name,
                             @"password" : pasd
                             };
    AFHTTPSessionManager *manager = [HealthyHTTPSessionManager sharedInstance];
    [[CommonAFNInstance sharedInstance] useManager:manager postRequestUrl:Url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSString *errorMessage) {
        NSLog(@"获取失败");
        failure(task, errorMessage);
    }];
    //    [self.indicatorView setAnimatingWithStateOfOperation:operation];
}

@end

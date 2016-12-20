//
//  CJNetworkClient+Test.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "CJNetworkClient+Test.h"

@implementation CJNetworkClient (Test)

+ (void)requestBaiduHomeSuccess:(CJRequestSuccess)success
                        failure:(CJRequestFailure)failure {
    NSString *Url = @"https://www.baidu.com";
    NSDictionary *parameters = nil;
    
    AFHTTPSessionManager *manager = [TestHTTPSessionManager sharedInstance];
    [[CommonAFNInstance sharedInstance] useManager:manager postRequestUrl:Url parameters:parameters cacheReuqestData:NO progress:nil success:^(NSURLSessionDataTask *task, id responseObject, BOOL isCacheData) {
        if (success) {
            success(task, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMessage, BOOL isCacheData) {
        if (failure) {
            failure(task, errorMessage);
        }
    }];
}

@end

//
//  CJNetworkClient+LoginIjinbu.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "CJNetworkClient+LoginIjinbu.h"

#import "IjinbuResponseModel.h"

@implementation CJNetworkClient (LoginIjinbu)

- (void)requestijinbuLogin_name:(NSString *)name
                           pasd:(NSString*)pasd
                        success:(CJRequestSuccess)success
                        failure:(CJRequestFailure)failure
{
    NSString *Url = API_BASE_Url_ijinbu(@"ijinbu/app/teacherLogin/login");
    NSDictionary *params = @{@"userAccount":name, //测试:name:18020721201 pasd:123456
                             @"userPwd":    [pasd MD5],
                             @"loginType":  @(0)
                             //                             @"client_id"     : CLIENT,
                             //                             @"client_secret" : CLIENT_SECRET
                             };
    NSLog(@"Url = %@", Url);
    NSLog(@"params = %@", params);
    
    AFHTTPSessionManager *manager = [IjinbuHTTPSessionManager sharedInstance];
    
    NSString *sign = [self signWithParams:params path:nil];
    NSLog(@"sign = %@", sign);
    [manager.requestSerializer setValue:sign forHTTPHeaderField:@"sign"];
    
    [self useManager:manager postRequestUrl:Url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求ijinbu成功");
        NSLog(@"responseObject = %@", responseObject);
        IjinbuResponseModel *responseModel = [[IjinbuResponseModel alloc] initWithDictionary:responseObject error:nil];
        if ([responseModel.status integerValue] == 1) {
            NSLog(@"登录ijinbu成功");
            if (success) {
                success(task, responseObject);
            }
            
        } else {
            NSLog(@"登录ijinbu失败");
            if (failure) {
                NSString *errorMessage = responseModel.message;
                failure(task, errorMessage);
            }
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSString *errorMessage) {
        NSLog(@"请求ijinbu失败:%@", errorMessage);
        if (failure) {
            failure(task, errorMessage);
        }
    }];
}

- (NSString *)signWithParams:(NSDictionary *)params path:(NSString*)path
{
#if 0
    return [[NSString stringWithFormat:@"%@123456", [HPDevice deviceId]] md5Hash];
#else
    NSURL *url = [NSURL URLWithString:path];
    NSString *q = [url query];
    NSArray *kvs = [q componentsSeparatedByString:@"&"];
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:params];
    for (NSString *item in kvs)
    {
        NSArray *a = [item componentsSeparatedByString:@"="];
        if (a.count > 1)
            [d setValue:a[1] forKey:a[0]];
        else if (a.count == 1)
            [d setValue:@"" forKey:a[0]];
    }
    NSArray *keys = [[d allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0; i < keys.count; i++) {
        NSObject *value = [d valueForKey:keys[i]];
        [string appendFormat:@"%@%@", keys[i], value!=[NSNull null]?value:@""];
    }
    if (string.length > 0)
    {
        //        [string appendString:@"appKey=9a628966c0f3ff45cf3c68a92ea0ec2a"];
    }
    return [string MD5];
#endif
}

@end

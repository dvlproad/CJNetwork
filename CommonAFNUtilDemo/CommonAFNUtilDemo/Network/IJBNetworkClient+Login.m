//
//  IJBNetworkClient+Login.m
//  CommonAFNUtilDemo
//
//  Created by 李超前 on 2017/3/6.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "IJBNetworkClient+Login.h"

@implementation IJBNetworkClient (Login)

- (NSURLSessionDataTask *)requestijinbuLogin_name:(NSString *)name
                                             pasd:(NSString*)pasd
                                          success:(HPSuccess)success
                                          failure:(HPFailure)failure
{
    NSString *Url = API_BASE_Url_ijinbu(@"ijinbu/app/teacherLogin/login");
    NSDictionary *params = @{@"userAccount":name, //测试:name:18020721201 pasd:123456
                             @"userPwd":    [pasd MD5],
                             @"loginType":  @(0)
                             //                             @"client_id"     : CLIENT,
                             //                             @"client_secret" : CLIENT_SECRET
                             };
    
    return [self postWithPath:Url params:params success:success failure:failure];
}

@end

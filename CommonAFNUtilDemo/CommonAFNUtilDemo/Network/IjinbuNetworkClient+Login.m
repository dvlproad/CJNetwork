//
//  IjinbuNetworkClient+Login.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2017/3/6.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "IjinbuNetworkClient+Login.h"
#import "NSString+MD5.h"

@implementation IjinbuNetworkClient (Login)

- (NSURLSessionDataTask *)requestijinbuLogin_name:(NSString *)name
                                             pasd:(NSString*)pasd
                                          success:(HPSuccess)success
                                          failure:(HPFailure)failure
{
    NSString *Url = @"ijinbu/app/teacherLogin/login";
    NSDictionary *params = @{@"userAccount":name, //测试:name:18020721201 pasd:123456
                             @"userPwd":    [pasd MD5],
                             @"loginType":  @(0)
                             };
    
    return [self postWithRelativeUrl:Url params:params success:success failure:failure];
}

@end

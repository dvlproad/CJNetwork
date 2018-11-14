//
//  HealthyNetworkClient+Login.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "HealthyNetworkClient+Login.h"

@implementation HealthyNetworkClient (Login)

- (void)requestLoginWithName:(NSString *)name
                        pasd:(NSString*)pasd
                     success:(void (^)(HealthResponseModel *responseModel))success
                     failure:(void (^)(NSError *error))failure
{
    NSString *apiName = @"login";
    NSDictionary *params = @{@"username" : name,
                             @"password" : pasd
                             };
    [self health_postApi:apiName params:params encrypt:YES success:success failure:failure];
    //[self.indicatorView setAnimatingWithStateOfOperation:operation];
}

@end

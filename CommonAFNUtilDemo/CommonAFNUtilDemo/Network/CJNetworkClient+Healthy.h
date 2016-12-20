//
//  CJNetworkClient+Healthy.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "CJNetworkClient.h"
#import "HealthyHTTPSessionManager.h"

@interface CJNetworkClient (Healthy)

//健康软件中的API
- (void)requestLogin_name:(NSString *)name
                     pasd:(NSString*)pasd
                  success:(CJRequestSuccess)success
                  failure:(CJRequestFailure)failure;

@end

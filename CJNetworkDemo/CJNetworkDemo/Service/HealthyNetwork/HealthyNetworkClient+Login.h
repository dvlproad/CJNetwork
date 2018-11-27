//
//  HealthyNetworkClient+Login.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "HealthyNetworkClient.h"

@interface HealthyNetworkClient (Login)

//健康软件中的API
- (void)requestLoginWithName:(NSString *)name
                        pasd:(NSString*)pasd
                     success:(void (^)(HealthResponseModel *responseModel))success
                     failure:(void (^)(NSString *errorMessage))failure;

@end

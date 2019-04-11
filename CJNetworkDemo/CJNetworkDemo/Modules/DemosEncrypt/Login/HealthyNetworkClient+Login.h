//
//  HealthyNetworkClient+Login.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "HealthyNetworkClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface HealthyNetworkClient (Login)

//健康软件中的API
- (void)requestLoginWithName:(NSString *)name
                        pasd:(NSString*)pasd
                     success:(void (^)(HealthResponseModel *responseModel))success
                     failure:(nullable void (^)(NSString *errorMessage))failure;

@end

NS_ASSUME_NONNULL_END

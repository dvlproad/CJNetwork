//
//  HealthyNetworkClient.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager+CJSerializerEncrypt.h"
#import "AFHTTPSessionManager+CJMethodEncrypt.h"

#import "HealthResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HealthyNetworkClient : NSObject

+ (HealthyNetworkClient *)sharedInstance;

- (NSURLSessionDataTask *)health_postApi:(NSString *)apiSuffix
                                  params:(id)params
                                 encrypt:(BOOL)encrypt
                                 success:(void (^)(HealthResponseModel *responseModel))success
                                 failure:(nullable void (^)(NSString *errorMessage))failure;

@end

NS_ASSUME_NONNULL_END

//
//  HealthyNetworkClient.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager+CJEncrypt.h"
#import "AFHTTPSessionManager+CJCacheRequest.h"

#import "CJResponseModel.h"

@interface HealthyNetworkClient : NSObject

+ (HealthyNetworkClient *)sharedInstance;

//健康软件中的API
- (void)requestLogin_name:(NSString *)name
                     pasd:(NSString*)pasd
            completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock;

@end

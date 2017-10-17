//
//  TestNetworkClient.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager+CJCacheRequest.h"

@interface TestNetworkClient : NSObject

+ (TestNetworkClient *)sharedInstance;

- (void)requestBaiduHomeSuccess:(AFRequestSuccess)success
                        failure:(AFRequestFailure)failure;

@end

//
//  TestNetworkClient.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager+CJCacheRequest.h"

#import "CJResponseModel.h"

@interface TestNetworkClient : NSObject

+ (TestNetworkClient *)sharedInstance;

- (void)requestBaiduHomeCompleteBlock:(void (^)(CJResponseModel *responseModel))completeBlock;

@end

//
//  TestNetworkClient+TestRequest.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TestNetworkClient.h"

@interface TestNetworkClient (TestRequest)

/// 测试请求成功
- (void)testRequestWithSuccess:(void (^)(CJResponseModel *responseModel))success
                       failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

@end

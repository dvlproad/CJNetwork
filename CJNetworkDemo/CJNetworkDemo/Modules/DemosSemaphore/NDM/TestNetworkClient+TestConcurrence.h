//
//  TestNetworkClient+TestConcurrence.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 11/19/18.
//  Copyright © 2018 dvlproad. All rights reserved.
//

#import "TestNetworkClient.h"

@interface TestNetworkClient (TestConcurrence)

/// 测试并发数
- (void)testConcurrenceCountApiIndex:(NSInteger)apiIndex
                             success:(void (^)(CJResponseModel *responseModel))success
                             failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

@end

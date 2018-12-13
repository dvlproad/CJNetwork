//
//  TestNetworkClient+TestCache.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TestNetworkClient.h"

@interface TestNetworkClient (TestCache)


/// 删除缓存
- (BOOL)removeCacheForEndWithCacheIfExistApi;

/// 测试缓存时间
- (void)testEndWithCacheIfExistWithSuccess:(void (^)(CJResponseModel *responseModel))success
                                   failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

/// 测试无缓存
- (void)testNoneCacheWithSuccess:(void (^)(CJResponseModel *responseModel))success
                         failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

@end

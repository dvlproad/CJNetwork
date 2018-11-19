//
//  TestNetworkClient+Test.h
//  CJNetworkDemo
//
//  Created by 李超前 on 11/19/18.
//  Copyright © 2018 dvlproad. All rights reserved.
//

#import "TestNetworkClient.h"

@interface TestNetworkClient (Test)


/// 测试缓存
- (void)testCacheWithShouldRemoveCache:(BOOL)shouldRemoveCache
                         completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock;

- (void)requestBaiduHomeCompleteBlock:(void (^)(CJResponseModel *responseModel))completeBlock;

@end

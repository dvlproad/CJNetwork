//
//  CJNetworkDemoTests.m
//  CJNetworkDemoTests
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestNetworkClient+Test.h"

#define CJ_WAIT_TEST do {\
[self expectationForNotification:@"CJTest" object:nil handler:nil];\
[self waitForExpectationsWithTimeout:30 handler:nil];\
} while (0);

#define CJ_NOTIFY_TEST \
[[NSNotificationCenter defaultCenter]postNotificationName:@"CJTest" object:nil];

@interface CJNetworkDemoTests : XCTestCase

@end

@implementation CJNetworkDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    // 以下方法不完善，请 EncryptHomeViewController 执行的 testCacheTime 方法验证
    [[TestNetworkClient sharedInstance] testCacheWithShouldRemoveCache:YES success:^(CJResponseModel *responseModel) {
        [self startTestCacheTime];
        CJ_NOTIFY_TEST
    } failure:^(BOOL isRequestFailure, NSString *errorMessage) {
        NSAssert(isRequestFailure, @"网络请求失败，无法测试'设置的缓存过期时间是否有效'的问题，请先保证网络请求成功");
        CJ_NOTIFY_TEST
    }];
    
    CJ_WAIT_TEST
}

- (void)startTestCacheTime {
    NSLog(@"第一次请求到的肯定是非缓存的数据，否则错误");
    [[TestNetworkClient sharedInstance] testCacheWithShouldRemoveCache:YES success:^(CJResponseModel *responseModel) {
        NSAssert(responseModel.isCacheData == NO, @"第一次请求到的肯定是非缓存的数据，否则错误");
        CJ_NOTIFY_TEST
    } failure:^(BOOL isRequestFailure, NSString *errorMessage) {
        CJ_NOTIFY_TEST
    }];
    
    NSLog(@"在缓存过期10秒内，请求到的肯定是缓存的数据，否则错误");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[TestNetworkClient sharedInstance] testCacheWithShouldRemoveCache:NO success:^(CJResponseModel *responseModel) {
            NSAssert(responseModel.isCacheData == YES, @"在缓存过期10秒内，请求到的肯定是缓存的数据，否则错误");
            CJ_NOTIFY_TEST
        } failure:^(BOOL isRequestFailure, NSString *errorMessage) {
            CJ_NOTIFY_TEST
        }];
    });
    
    NSLog(@"在缓存过期10秒后，请求到的肯定是非缓存的数据，否则错误");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(11 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[TestNetworkClient sharedInstance] testCacheWithShouldRemoveCache:NO success:^(CJResponseModel *responseModel) {
            NSAssert(responseModel.isCacheData == NO, @"在缓存过期10秒后，请求到的肯定是非缓存的数据，否则错误");
            CJ_NOTIFY_TEST
        } failure:^(BOOL isRequestFailure, NSString *errorMessage) {
            CJ_NOTIFY_TEST
        }];
    });
    
    CJ_WAIT_TEST
    CJ_WAIT_TEST
    CJ_WAIT_TEST
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

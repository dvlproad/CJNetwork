//
//  TestNetworkClient+Test.m
//  CJNetworkDemo
//
//  Created by 李超前 on 11/19/18.
//  Copyright © 2018 dvlproad. All rights reserved.
//

#import "TestNetworkClient+Test.h"

@implementation TestNetworkClient (Test)

/// 测试缓存时间
- (void)testCacheWithShouldRemoveCache:(BOOL)shouldRemoveCache
                               success:(void (^)(CJResponseModel *responseModel))success
                               failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    NSString *apiSuffix = @"/api/testCache";
    NSDictionary *params = @{@"test": @"test"};
    
    CJRequestSettingModel *settingModel = [[CJRequestSettingModel alloc] init];
    settingModel.cacheStrategy = CJRequestCacheStrategyEndWithCacheIfExist;
    settingModel.cacheTimeInterval = 10;
    settingModel.logType = CJRequestLogTypeConsoleLog;
    
    [self testSimulate_postApiSuffix:apiSuffix params:params settingModel:settingModel shouldRemoveCache:shouldRemoveCache success:success failure:failure];
}

- (void)requestBaiduHomeCompleteBlock:(void (^)(CJResponseModel *responseModel))completeBlock {
    NSString *apiSuffix = @"/api/testCache";
    NSDictionary *parameters = nil;
    
    CJRequestCacheStrategy cacheStrategy = CJRequestCacheStrategyNoneCache;
    [self testEncrypt_postApiSuffix:apiSuffix params:parameters cacheStrategy:cacheStrategy completeBlock:completeBlock];
}

@end
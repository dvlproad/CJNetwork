//
//  TestNetworkClient+TestCache.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TestNetworkClient+TestCache.h"
#import "CJNetworkCacheUtil.h"

@implementation TestNetworkClient (TestCache)

/// 删除缓存
- (BOOL)removeCacheForEndWithCacheIfExistApi {
    NSString *apiSuffix = @"/api/testCache";
    NSDictionary *params = @{@"test": @"test"};
    
    NSString *domain = @"http://localhost/CJDemoDataSimulationDemo";
    NSString *Url = [domain stringByAppendingString:apiSuffix];
    
    return [CJNetworkCacheUtil removeCacheForUrl:Url params:params];
}

/// 测试缓存时间
- (void)testEndWithCacheIfExistWithSuccess:(void (^)(CJResponseModel *responseModel))success
                                   failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    NSString *apiSuffix = @"/api/testCache";
    NSDictionary *params = @{@"test": @"test"};
    
    CJRequestSettingModel *settingModel = [[CJRequestSettingModel alloc] init];
    settingModel.cacheStrategy = CJRequestCacheStrategyEndWithCacheIfExist;
    settingModel.cacheTimeInterval = 10;
    settingModel.logType = CJRequestLogTypeConsoleLog;
    
    [self testSimulate_postApi:apiSuffix params:params settingModel:settingModel success:success failure:failure];
}

/// 测试无缓存
- (void)testNoneCacheWithSuccess:(void (^)(CJResponseModel *responseModel))success
                         failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    NSString *apiSuffix = @"/api/testCache";
    NSDictionary *params = nil;
    
    CJRequestSettingModel *settingModel = [[CJRequestSettingModel alloc] init];
    settingModel.cacheStrategy = CJRequestCacheStrategyNoneCache;
    //settingModel.cacheTimeInterval = 10;
    settingModel.logType = CJRequestLogTypeConsoleLog;
    
    [self testSimulate_postApi:apiSuffix params:params settingModel:settingModel success:success failure:failure];
}

@end

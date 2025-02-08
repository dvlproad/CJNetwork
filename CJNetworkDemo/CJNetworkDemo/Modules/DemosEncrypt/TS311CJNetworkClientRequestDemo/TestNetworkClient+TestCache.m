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
    
    NSString *Url = [self.baseUrl stringByAppendingString:apiSuffix];
    
    return [CJNetworkCacheUtil removeCacheForUrl:Url params:params];
}

/// 测试缓存时间
- (void)testEndWithCacheIfExistWithSuccess:(void (^)(CJResponseModel *responseModel))success
                                   failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    CJRequestBaseModel *requestModel = [[CJRequestBaseModel alloc] init];
    requestModel.apiSuffix = @"/api/testCache";
    requestModel.customParams = @{@"test": @"test"};
    requestModel.requestMethod = CJRequestMethodPOST;
    
    CJRequestSettingModel *settingModel = [[CJRequestSettingModel alloc] init];
    CJRequestCacheSettingModel *requestCacheModel = [[CJRequestCacheSettingModel alloc] init];
    requestCacheModel.cacheStrategy = CJRequestCacheStrategyEndWithCacheIfExist;
    requestCacheModel.cacheTimeInterval = 10;
    settingModel.requestCacheModel = requestCacheModel;
    settingModel.logType = CJRequestLogTypeConsoleLog;
    requestModel.settingModel = settingModel;
    
    [self requestModel:requestModel success:success failure:failure];
}

/// 测试无缓存
- (void)testNoneCacheWithSuccess:(void (^)(CJResponseModel *responseModel))success
                         failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    NSString *apiSuffix = @"/api/testCache";
    NSDictionary *params = nil;
    
    CJRequestBaseModel *requestModel = [[CJRequestBaseModel alloc] init];
    requestModel.apiSuffix = apiSuffix;
    requestModel.customParams = params;
    requestModel.requestMethod = CJRequestMethodPOST;
    
    CJRequestSettingModel *settingModel = [[CJRequestSettingModel alloc] init];
    CJRequestCacheSettingModel *requestCacheModel = [[CJRequestCacheSettingModel alloc] init];
    requestCacheModel.cacheStrategy = CJRequestCacheStrategyNoneCache;
//    requestCacheModel.cacheTimeInterval = 10;
    settingModel.requestCacheModel = requestCacheModel;
    settingModel.logType = CJRequestLogTypeConsoleLog;
    requestModel.settingModel = settingModel;
    
    [self requestModel:requestModel success:success failure:failure];
}

@end

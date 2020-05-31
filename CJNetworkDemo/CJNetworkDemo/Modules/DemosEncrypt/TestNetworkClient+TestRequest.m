//
//  TestNetworkClient+TestRequest.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TestNetworkClient+TestRequest.h"

@implementation TestNetworkClient (TestRequest)

/// 测试请求成功
- (void)testRequestWithSuccess2:(void (^)(CJResponseModel *responseModel))success
                       failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    NSString *apiSuffix = @"/api/testCache";
    NSDictionary *params = nil;
    
    CJRequestSettingModel *settingModel = [[CJRequestSettingModel alloc] init];
    settingModel.logType = CJRequestLogTypeConsoleLog;
    
    [self simulate2_postApi:apiSuffix params:params settingModel:settingModel success:success failure:failure];
}


/// 测试请求成功
- (void)testRequestWithSuccess:(void (^)(CJResponseModel *responseModel))success
                       failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    NSString *apiSuffix = @"/getWangYiNews";
    NSDictionary *params = @{
        @"page": @(1),
        @"count": @(5)
    };
    
    CJRequestSettingModel *settingModel = [[CJRequestSettingModel alloc] init];
//    settingModel.ownBaseUrl = @"https://api.apiopen.top";
    settingModel.logType = CJRequestLogTypeConsoleLog;
    
    [self real2_postApi:apiSuffix params:params settingModel:settingModel success:success failure:failure];
}

@end

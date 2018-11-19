//
//  TestNetworkClient+Test.m
//  CJNetworkDemo
//
//  Created by 李超前 on 11/19/18.
//  Copyright © 2018 dvlproad. All rights reserved.
//

#import "TestNetworkClient+Test.h"

@implementation TestNetworkClient (Test)

/// 测试缓存
- (void)testCacheWithShouldRemoveCache:(BOOL)shouldRemoveCache
                         completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock
{
    NSString *apiSuffix = @"/api/testCache";
    NSDictionary *params = @{@"test": @"test"};
    
    CJRequestSettingModel *settingModel = [[CJRequestSettingModel alloc] init];
    settingModel.cacheStrategy = CJNetworkCacheStrategyEndWithCacheIfExist;
    settingModel.cacheTimeInterval = 10;
    settingModel.logType = CJNetworkLogTypeConsoleLog;
    
    [self testSimulate_postApiSuffix:apiSuffix params:params settingModel:settingModel shouldRemoveCache:shouldRemoveCache completeBlock:completeBlock];
}

- (void)requestBaiduHomeCompleteBlock:(void (^)(CJResponseModel *responseModel))completeBlock {
    NSString *apiSuffix = @"/api/testCache";
    NSDictionary *parameters = nil;
    
    CJNetworkCacheStrategy cacheStrategy = CJNetworkCacheStrategyNoneCache;
    [self testEncrypt_postApiSuffix:apiSuffix params:parameters cacheStrategy:cacheStrategy completeBlock:completeBlock];
}

@end

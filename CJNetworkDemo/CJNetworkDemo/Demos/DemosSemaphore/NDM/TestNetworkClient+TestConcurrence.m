//
//  TestNetworkClient+TestConcurrence.m
//  CJNetworkDemo
//
//  Created by 李超前 on 11/19/18.
//  Copyright © 2018 dvlproad. All rights reserved.
//

#import "TestNetworkClient+TestConcurrence.h"
#import "CJNetworkClient+SuccessFailure.h"

@implementation TestNetworkClient (TestConcurrence)

/// 测试并发数
- (void)testConcurrenceCountApiIndex:(NSInteger)apiIndex
                             success:(void (^)(CJResponseModel *responseModel))success
                             failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    NSString *apiSuffix = [NSString stringWithFormat:@"/api/testConcurrence%ld", apiIndex];
    NSDictionary *params = @{@"test": @"test"};
    
    CJRequestSettingModel *settingModel = [[CJRequestSettingModel alloc] init];
    settingModel.cacheStrategy = CJRequestCacheStrategyNoneCache;
    settingModel.logType = CJRequestLogTypeNone;
    
    [self testSimulate_postApi:apiSuffix params:params settingModel:settingModel success:^(CJResponseModel *responseModel) {
        sleep(5);
        if (success) {
            success(responseModel);
        }
    } failure:^(BOOL isRequestFailure, NSString *errorMessage) {
        sleep(5);
        if (failure) {
            failure(isRequestFailure, errorMessage);
        }
    }];
}

@end

//
//  TestNetworkClient+TestConcurrence.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 11/19/18.
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
    
    CJRequestBaseModel *requestModel = [[CJRequestBaseModel alloc] init];
    requestModel.apiSuffix = apiSuffix;
    requestModel.param = params;
    requestModel.requestMethod = CJRequestMethodPOST;
    
    [self requestModel:requestModel success:^(CJResponseModel *responseModel) {
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

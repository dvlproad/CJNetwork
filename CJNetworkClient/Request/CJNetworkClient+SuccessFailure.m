//
//  CJNetworkClient+SuccessFailure.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJNetworkClient+SuccessFailure.h"
#import <CJNetworkClient/CJNetworkClient+Completion.h>

@implementation CJNetworkClient (SuccessFailure)

- (NSURLSessionDataTask *)requestModel:(__kindof NSObject<CJRequestModelProtocol> *)model
                               success:(void (^)(CJResponseModel *responseModel))success
                               failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self requestModel:model completeBlock:^(CJResponeFailureType failureType, CJResponseModel * _Nonnull responseModel) {
        [self __splitCompleteBlockWithFailureType:failureType responseModel:responseModel toSuccess:success failure:failure];
    }];
}

#pragma mark - Private
- (void)__splitCompleteBlockWithFailureType:(CJResponeFailureType)failureType
                            responseModel:(CJResponseModel *)responseModel
                                toSuccess:(void (^)(CJResponseModel *responseModel))success
                                  failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    if (failureType == CJResponeFailureTypeCommonFailure) {
        !failure ?: failure(NO, responseModel.message);
        
    } else if (failureType == CJResponeFailureTypeRequestFailure) {
        !failure ?: failure(YES, responseModel.message);
        
    } else {
        !success ?: success(responseModel);
    }
}

@end

//
//  CJResponseHelper.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/18.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJResponseHelper.h"

@implementation CJResponseHelper

+ (void)__dealSuccessRequestInfo:(CJSuccessRequestInfo *)successNetworkInfo
    getSuccessResponseModelBlock:(CJResponseModel *(^)(CJSuccessRequestInfo  * _Nonnull bSuccessRequestInfo))getSuccessResponseModelBlock
       checkIsCommonFailureBlock:(BOOL(^)(CJResponseModel *responseModel))checkIsCommonFailureBlock
                   completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    CJResponseModel *responseModel = getSuccessResponseModelBlock(successNetworkInfo);
    //方式①
    //CJResponseModel *responseModel = [CJResponseModel mj_objectWithKeyValues:responseDictionary];
    //方式②
    //CJResponseModel *responseModel = [[CJResponseModel alloc] initWithResponseDictionary:responseDictionary isCacheData:successNetworkInfo.isCacheData];
    //方式③
    //CJResponseModel *responseModel = [[CJResponseModel alloc] init];
    //responseModel.statusCode = [responseDictionary[@"status"] integerValue];
    //responseModel.message = responseDictionary[@"message"];
    //responseModel.result = responseDictionary[@"result"];
    //responseModel.isCacheData = isCacheData;
    
    CJResponeFailureType failureType = CJResponeFailureTypeNeedFurtherJudgeFailure;
    if (checkIsCommonFailureBlock) {
        BOOL isCommonFailure = checkIsCommonFailureBlock(responseModel);
        failureType = isCommonFailure ? CJResponeFailureTypeCommonFailure : CJResponeFailureTypeNeedFurtherJudgeFailure;
    }
    
    if (completeBlock) {
        completeBlock(failureType, responseModel);
    }
}


+ (void)__dealFailureNetworkInfo:(CJFailureRequestInfo *)failureNetworkInfo
    getFailureResponseModelBlock:(CJNetworkClientGetFailureResponseModelBlock)getFailureResponseModelBlock
                   completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    CJResponseModel *responseModel = getFailureResponseModelBlock(failureNetworkInfo);
    //responseModel.isCacheData = NO;
    CJResponeFailureType failureType = CJResponeFailureTypeRequestFailure;
    if (completeBlock) {
        completeBlock(failureType, responseModel);
    }
}

@end

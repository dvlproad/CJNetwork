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
    getSuccessResponseModelBlock:(CJResponseModel *(^)(id responseObject, BOOL isCacheData))getSuccessResponseModelBlock
       checkIsCommonFailureBlock:(BOOL(^)(CJResponseModel *responseModel))checkIsCommonFailureBlock
                   completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSDictionary *responseDictionary = successNetworkInfo.responseObject;
    BOOL isCacheData = successNetworkInfo.isCacheData;
    CJResponseModel *responseModel = getSuccessResponseModelBlock(responseDictionary, isCacheData);
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
    NSError *error = failureNetworkInfo.error;
    NSString *errorMessage = failureNetworkInfo.errorMessage;

    CJResponseModel *responseModel = getFailureResponseModelBlock(error, errorMessage);
    //responseModel.isCacheData = NO;
    CJResponeFailureType failureType = CJResponeFailureTypeRequestFailure;
    if (completeBlock) {
        completeBlock(failureType, responseModel);
    }
}

@end

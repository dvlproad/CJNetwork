//
//  CJNetworkClient+ResponseCallback.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJNetworkClient+ResponseCallback.h"
#import "CJNetworkInstance+OriginCallback.h"

@implementation CJNetworkClient (ResponseCallback)


//    [manager cj_requestUrl:Url params:allParams headers:headers method:requestMethod cacheSettingModel:cacheSettingModel logType:logType progress:progressBlock success:^(CJSuccessRequestInfo * _Nullable successNetworkInfo) {
//        [CJResponseHelper __dealSuccessRequestInfo:successNetworkInfo
//                      getSuccessResponseModelBlock:weakSelf.getSuccessResponseModelBlock
//                         checkIsCommonFailureBlock:weakSelf.checkIsCommonFailureBlock
//                                     completeBlock:completeBlock];
//
//    } failure:^(CJFailureRequestInfo * _Nullable failureNetworkInfo) {
//        [CJResponseHelper __dealFailureNetworkInfo:failureNetworkInfo
//                      getFailureResponseModelBlock:weakSelf.getFailureResponseModelBlock
//                                     completeBlock:completeBlock];
//    }];
- (NSURLSessionDataTask *)requestModel:(__kindof NSObject<CJRequestModelProtocol> *)model
                         completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    __weak typeof(self)weakSelf = self;
    return [self requestModel:model originCompleteBlock:^(CJSuccessRequestInfo * _Nullable successRequestInfo, CJFailureRequestInfo * _Nullable failureRequestInfo) {
        if (failureRequestInfo != nil) {
            CJResponseModel *responseModel = weakSelf.getFailureResponseModelBlock(failureRequestInfo);
            //responseModel.isCacheData = NO;
            CJResponeFailureType failureType = CJResponeFailureTypeRequestFailure;
            
            completeBlock(failureType, responseModel);
        } else {
            
            CJResponseModel *responseModel = weakSelf.getSuccessResponseModelBlock(successRequestInfo);
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
            if (weakSelf.checkIsCommonFailureBlock) {
                BOOL isCommonFailure = weakSelf.checkIsCommonFailureBlock(responseModel);
                failureType = isCommonFailure ? CJResponeFailureTypeCommonFailure : CJResponeFailureTypeNeedFurtherJudgeFailure;
            }
            
            if (completeBlock) {
                completeBlock(failureType, responseModel);
            }
        }
    }];
}


- (NSURLSessionDataTask *)requestModel:(__kindof NSObject<CJRequestModelProtocol> *)model
                               success:(void (^)(CJResponseModel *responseModel))success
                               failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self requestModel:model completeBlock:^(CJResponeFailureType failureType, CJResponseModel * _Nonnull responseModel) {
        if (failureType == CJResponeFailureTypeCommonFailure) {
            !failure ?: failure(NO, responseModel.message);
            
        } else if (failureType == CJResponeFailureTypeRequestFailure) {
            !failure ?: failure(YES, responseModel.message);
            
        } else {
            !success ?: success(responseModel);
        }
    }];
}

@end

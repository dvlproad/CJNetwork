//
//  CQNetworkRequestSuccessFailureHelperProtocal.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#ifndef CQNetworkRequestSuccessFailureHelperProtocal_h
#define CQNetworkRequestSuccessFailureHelperProtocal_h

#import "CJRequestModelProtocol.h"
#import "CJRequestNetworkEnum.h"
#import "CJResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CQNetworkRequestSuccessFailureHelperProtocal <NSObject>

/*
 *  请求
 *
 *  @param model        请求相关的信息(包含请求方法、请求地址、请求参数等)real\simulate\local
 *  @param success      请求结束成功的回调(为方便接口的重复利用回调中的responseModel使用id类型)
 *  @param failure      请求结束失败的回调
 *
 *  @return 执行请求的任务
 */
+ (NSURLSessionDataTask *)requestModel:(__kindof NSObject<CJRequestModelProtocol> *)model
                               success:(void (^)(CJResponseModel *responseModel))success
                               failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;
@end


#endif /* CQNetworkRequestSuccessFailureHelperProtocal_h */

NS_ASSUME_NONNULL_END

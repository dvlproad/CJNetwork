//
//  CQNetworkRequestSuccessFailureClientProtocal.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  为了解耦使用的面向协议编程

#ifndef CQNetworkRequestSuccessFailureClientProtocal_h
#define CQNetworkRequestSuccessFailureClientProtocal_h

#import "CJRequestModelProtocol.h"
#import "CJRequestNetworkEnum.h"
#import "CJRequestInfoModel.h"

#import "CJResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CQNetworkRequestSuccessFailureClientProtocal <NSObject>

@required

/*
 *  请求
 *
 *  @param model            请求相关的信息(包含请求方法、请求地址、请求参数等)real\simulate\local
 *  @param success          请求结束成功的回调(为方便接口的重复利用回调中的responseModel使用id类型)
 *  @param failure          请求结束失败的回调
 *
 *  @return 执行请求的任务
 */
- (NSURLSessionDataTask *)requestModel:(__kindof NSObject<CJRequestModelProtocol> *)model
                               success:(void (^)(CJResponseModel *responseModel))success
                               failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

/*
 *  请求
 *
 *  @param model            请求相关的信息(包含请求方法、请求地址、请求参数等)real\simulate\local
 *  @param success          请求结束成功的回调
 *  @param failure          请求结束失败的回调
 *
 *  @return 执行请求的任务
 */
- (NSURLSessionDataTask *)requestModel:(__kindof NSObject<CJRequestModelProtocol> *)model
                         originSuccess:(nullable void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo))success
                         originFailure:(nullable void (^)(CJFailureRequestInfo * _Nullable failureRequestInfo))failure;

@end


#endif /* CQNetworkRequestSuccessFailureClientProtocal_h */

NS_ASSUME_NONNULL_END

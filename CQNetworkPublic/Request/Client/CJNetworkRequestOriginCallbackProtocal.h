//
//  CJNetworkRequestOriginCallbackProtocal.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  为了解耦使用的面向协议编程

#ifndef CJNetworkRequestOriginCallbackProtocal_h
#define CJNetworkRequestOriginCallbackProtocal_h

#import "CJRequestModelProtocol.h"
#import "CJRequestNetworkEnum.h"

#import "CJRequestInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CJNetworkRequestOriginCallbackProtocal <NSObject>

@required
/*
 *  请求
 *
 *  @param model            请求相关的信息(包含请求方法、请求地址、请求参数等)real\simulate\local
 *  @param completeBlock    请求结束的回调(请求成功，则 successRequestInfo 才有值；请求失败，则 failureRequestInfo 才有值)
 *
 *  @return 执行请求的任务
 */
- (NSURLSessionDataTask *)requestModel:(__kindof NSObject<CJRequestModelProtocol> *)model
                   originCompleteBlock:(void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo, CJFailureRequestInfo * _Nullable failureRequestInfo))completeBlock;

@required
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


#endif /* CQNetworkRequestCompletionClientProtocal_h */

NS_ASSUME_NONNULL_END

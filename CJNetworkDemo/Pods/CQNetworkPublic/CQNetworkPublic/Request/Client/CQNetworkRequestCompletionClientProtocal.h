//
//  CQNetworkRequestCompletionClientProtocal.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  为了解耦使用的面向协议编程

#ifndef CQNetworkRequestCompletionClientProtocal_h
#define CQNetworkRequestCompletionClientProtocal_h

#import "CJRequestModelProtocol.h"
#import "CJRequestNetworkEnum.h"
#import "CJResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CQNetworkRequestCompletionClientProtocal <NSObject>

@required
/*
 *  请求
 *
 *  @param model            请求相关的信息(包含请求方法、请求地址、请求参数等)real\simulate\local
 *  @param completeBlock    请求结束的回调(为方便接口的重复利用回调中的responseModel使用id类型)
 *
 *  @return 执行请求的任务
 */
- (NSURLSessionDataTask *)requestModel:(__kindof NSObject<CJRequestModelProtocol> *)model
                         completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;
@end


#endif /* CQNetworkRequestCompletionClientProtocal_h */

NS_ASSUME_NONNULL_END

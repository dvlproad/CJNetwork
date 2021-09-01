//
//  CQNetworkRequestCompletionHelperProtocal.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#ifndef CQNetworkRequestCompletionHelperProtocal_h
#define CQNetworkRequestCompletionHelperProtocal_h

#import "CQNetworkRequestEnum.h"
#import "CJResponseModel.h"

@protocol CQNetworkRequestCompletionHelperProtocal <NSObject>

#pragma mark - Protocal为了解耦需要由分类来实现的方法
@required
#pragma mark - RealApi
+ (NSURLSessionDataTask *)real1_getApi:(NSString *)apiSuffix
                                params:(nullable id)params
                         completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

+ (NSURLSessionDataTask *)real1_postApi:(NSString *)apiSuffix
                                 params:(nullable id)params
                          completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;


@optional
#pragma mark - simulateApi
// 为方便接口的重复利用回调中的responseModel使用id类型
+ (NSURLSessionDataTask *)simulate1_getApi:(NSString *)apiSuffix
                                    params:(nullable id)params
                             completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock;

+ (NSURLSessionDataTask *)simulate1_postApi:(NSString *)apiSuffix
                                     params:(nullable id)params
                              completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock;


@optional
#pragma mark - localApi
// 为方便接口的重复利用回调中的responseModel使用id类型
+ (nullable NSURLSessionDataTask *)local1_getApi:(NSString *)apiSuffix
                                          params:(nullable id)params
                                   completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock;

+ (nullable NSURLSessionDataTask *)local1_postApi:(NSString *)apiSuffix
                                           params:(nullable id)params
                                    completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock;

@end


#endif /* CQNetworkRequestCompletionHelperProtocal_h */

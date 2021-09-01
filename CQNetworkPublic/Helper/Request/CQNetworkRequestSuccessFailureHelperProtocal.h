//
//  CQNetworkRequestSuccessFailureHelperProtocal.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#ifndef CQNetworkRequestSuccessFailureHelperProtocal_h
#define CQNetworkRequestSuccessFailureHelperProtocal_h

#import "CQNetworkRequestEnum.h"
#import "CJResponseModel.h"

@protocol CQNetworkRequestSuccessFailureHelperProtocal <NSObject>

#pragma mark - Protocal为了解耦需要由分类来实现的方法
@required
#pragma mark - RealApi
+ (NSURLSessionDataTask *)real2_getApi:(NSString *)apiSuffix
                                params:(nullable id)params
                               success:(void (^)(CJResponseModel *responseModel))success
                               failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

+ (NSURLSessionDataTask *)real2_postApi:(NSString *)apiSuffix
                                 params:(nullable id)params
                                success:(void (^)(CJResponseModel *responseModel))success
                                failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;


@optional
#pragma mark - simulateApi
// 为方便接口的重复利用回调中的responseModel使用id类型
+ (NSURLSessionDataTask *)simulate2_getApi:(NSString *)apiSuffix
                                    params:(nullable id)params
                                   success:(void (^)(id responseModel))success
                                   failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

+ (NSURLSessionDataTask *)simulate2_postApi:(NSString *)apiSuffix
                                     params:(nullable id)params
                                    success:(void (^)(id responseModel))success
                                    failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

@optional
#pragma mark - localApi
// 为方便接口的重复利用回调中的responseModel使用id类型
+ (nullable NSURLSessionDataTask *)local2_getApi:(NSString *)apiSuffix
                                 params:(nullable id)params
                                success:(void (^)(id responseModel))success
                                failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

+ (nullable NSURLSessionDataTask *)local2_postApi:(NSString *)apiSuffix
                                  params:(nullable id)params
                                 success:(void (^)(id responseModel))success
                                 failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;


@end


#endif /* CQNetworkRequestSuccessFailureHelperProtocal_h */

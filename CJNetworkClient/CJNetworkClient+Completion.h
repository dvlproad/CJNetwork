//
//  CJNetworkClient+Completion.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  有两个回调，分别为 success + failure

#import "CJNetworkClient.h"
#import <CQNetworkPublic/CQNetworkRequestSuccessFailureClientProtocal.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJNetworkClient (Completion) <CQNetworkRequestSuccessFailureClientProtocal>


#pragma mark - RealApi
- (NSURLSessionDataTask *)real1_getApi:(NSString *)apiSuffix
                                params:(NSDictionary *)params
                          settingModel:(nullable CJRequestSettingModel *)settingModel
                         completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (NSURLSessionDataTask *)real1_postApi:(NSString *)apiSuffix
                                 params:(id)params
                           settingModel:(nullable CJRequestSettingModel *)settingModel
                          completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;


#pragma mark - simulateApi
// 为方便接口的重复利用回调中的responseModel使用id类型
- (NSURLSessionDataTask *)simulate1_getApi:(NSString *)apiSuffix
                                    params:(nullable NSDictionary *)params
                              settingModel:(nullable CJRequestSettingModel *)settingModel
                             completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock;

- (NSURLSessionDataTask *)simulate1_postApi:(NSString *)apiSuffix
                                     params:(nullable id)params
                               settingModel:(nullable CJRequestSettingModel *)settingModel
                              completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock;


#pragma mark - localApi
// 为方便接口的重复利用回调中的responseModel使用id类型
- (nullable NSURLSessionDataTask *)local1_getApi:(NSString *)apiSuffix
                                          params:(NSDictionary *)params
                                    settingModel:(nullable CJRequestSettingModel *)settingModel
                                   completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock;

- (nullable NSURLSessionDataTask *)local1_postApi:(NSString *)apiSuffix
                                           params:(id)params
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                    completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock;

#pragma mark - Base
- (NSURLSessionDataTask *)real1_uploadUrl:(NSString *)Url
                                urlParams:(nullable id)urlParams
                               formParams:(nullable id)formParams
                             settingModel:(nullable CJRequestSettingModel *)settingModel
                         uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                 progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                            completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;
- (nullable NSURLSessionDataTask *)__requestUrl:(NSString *)Url
                                         params:(nullable id)customParams
                                         method:(CJRequestMethod)method
                                   settingModel:(nullable CJRequestSettingModel *)settingModel
                                  completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;
- (NSURLSessionDataTask *)__localApi:(NSString *)apiSuffix
                       completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock;

@end

NS_ASSUME_NONNULL_END

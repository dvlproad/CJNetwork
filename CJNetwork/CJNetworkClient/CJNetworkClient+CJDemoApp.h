//
//  CJNetworkClient+CJDemoApp.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  below are the cjdemo app's upload image example, other app can refer to it
//  below are the cjdemo app's upload image example, other app can refer to it
//  below are the cjdemo app's upload image example, other app can refer to it

#import "CJNetworkClient.h"
#import "CJNetworkClient+SuccessFailure.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJNetworkClient (CJDemoApp)

#pragma mark - RealApi
// the cjdemo app's upload image example, other app can refer to it
- (NSURLSessionDataTask *)cjdemoR1_uploadImageApi:(NSString *)apiSuffix
                                           params:(nullable NSDictionary *)customParams
                                       imageDatas:(NSArray<NSData *> *)imageDatas
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                    completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

// the cjdemo app's upload image example, other app can refer to it
- (NSURLSessionDataTask *)cjdemoR2_uploadImageApi:(NSString *)apiSuffix
                                           params:(nullable NSDictionary *)customParams
                                       imageDatas:(NSArray<NSData *> *)imageDatas
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                          success:(void (^)(CJResponseModel *responseModel))success
                                          failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

#pragma mark - simulateApi
// the cjdemo app's upload image example, other app can refer to it
- (NSURLSessionDataTask *)cjdemoS1_uploadImageApi:(NSString *)apiSuffix
                                           params:(nullable NSDictionary *)customParams
                                       imageDatas:(NSArray<NSData *> *)imageDatas
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                    completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

// the cjdemo app's upload image example, other app can refer to it
- (NSURLSessionDataTask *)cjdemoS2_uploadImageApi:(NSString *)apiSuffix
                                           params:(nullable NSDictionary *)customParams
                                       imageDatas:(NSArray<NSData *> *)imageDatas
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                          success:(void (^)(CJResponseModel *responseModel))success
                                          failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

#pragma mark - localApi
// the cjdemo app's upload image example, other app can refer to it
- (nullable NSURLSessionDataTask *)cjdemoL1_uploadImageApi:(NSString *)apiSuffix
                                           params:(nullable NSDictionary *)customParams
                                       imageDatas:(NSArray<NSData *> *)imageDatas
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                    completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

// the cjdemo app's upload image example, other app can refer to it
- (nullable NSURLSessionDataTask *)cjdemoL2_uploadImageApi:(NSString *)apiSuffix
                                           params:(nullable NSDictionary *)customParams
                                       imageDatas:(NSArray<NSData *> *)imageDatas
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                          success:(void (^)(CJResponseModel *responseModel))success
                                          failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

@end

NS_ASSUME_NONNULL_END

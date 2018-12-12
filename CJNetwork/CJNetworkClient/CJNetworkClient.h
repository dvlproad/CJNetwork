//
//  CJNetworkClient.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  网络请求管理类，其他NetworkClient可通过本CJNetworkClient继承，也可自己再实现
//  还需要自己设置EnvironmentManager和CryptSDK

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager+CJSerializerEncrypt.h"
#import "CJResponseModel.h"

typedef NS_ENUM(NSUInteger, CJResponeFailureType) {
    CJResponeFailureTypeUncheck = 0,            /**< 未进行是否等失败判断 */
    CJResponeFailureTypeRequestFailure,         /**< 请求失败 */
    CJResponeFailureTypeCommonFailure,          /**< 通用失败 */
    CJResponeFailureTypeNeedFurtherJudgeFailure,/**< 需要进一步判断是否错误的那些(在未进行归类或者未归类进指定错误的时候，都是这个值) */
};


@interface CJNetworkClient : NSObject {
    
}
// 一定要执行
- (void)setupCleanHTTPSessionManager:(AFHTTPSessionManager *)cleanHTTPSessionManager
             cryptHTTPSessionManager:(AFHTTPSessionManager *)cryptHTTPSessionManager;

- (void)setupCompleteFullUrlBlock:(NSString * (^)(NSString *apiSuffix))completeFullUrlBlock
           completeAllParamsBlock:(NSDictionary * (^)(NSDictionary *customParams))completeAllParamsBlock;

- (void)setupResponseConvertBlock:(CJResponseModel *(^)(id responseObject, BOOL isCacheData))responseConvertBlock
               checkIsCommonBlock:(BOOL(^)(CJResponseModel *responseModel))checkIsCommonBlock
    getRequestFailureMessageBlock:(NSString* (^)(NSError *error))getRequestFailureMessageBlock;

// 可选执行(当你需要执行模拟的时候才需要)
- (void)setupSimulateDomain:(NSString *)simulateDomain;

#pragma mark - Real
- (NSURLSessionDataTask *)real_getApi:(NSString *)apiSuffix
                               params:(NSDictionary *)params
                         settingModel:(CJRequestSettingModel *)settingModel
                        completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (NSURLSessionDataTask *)real_postApi:(NSString *)apiSuffix
                                params:(id)params
                          settingModel:(CJRequestSettingModel *)settingModel
                         completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;


#pragma mark simulate
- (NSURLSessionDataTask *)simulate_getApi:(NSString *)apiSuffix
                                   params:(NSDictionary *)params
                             settingModel:(CJRequestSettingModel *)settingModel
                            completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (NSURLSessionDataTask *)simulate_postApi:(NSString *)apiSuffix
                                    params:(id)params
                              settingModel:(CJRequestSettingModel *)settingModel
                             completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

#pragma mark - localApi
- (NSURLSessionDataTask *)local_getApi:(NSString *)apiSuffix
                                params:(NSDictionary *)params
                          settingModel:(CJRequestSettingModel *)settingModel
                         completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

- (NSURLSessionDataTask *)local_postApi:(NSString *)apiSuffix
                                 params:(id)params
                           settingModel:(CJRequestSettingModel *)settingModel
                          completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

@end

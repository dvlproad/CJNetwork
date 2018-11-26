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

@protocol CJNetworkEnvironmentProtocol <NSObject>

@property (nonatomic, strong) id environmentModel;  /**< 当前网络环境 */
@property (nonatomic, strong) NSMutableDictionary *specificCommonParams;           /**< 设置每个请求都会有的公共参数(项目里已添加了其他一些公共参数) */

- (NSString *)completeUrlWithApiSuffix:(NSString *)apiSuffix;
- (NSDictionary *)completeParamsWithCustomParams:(NSDictionary *)customParams;

@end



@protocol CJNetworkCryptHTTPSessionManagerProtocol <NSObject>

- (void)setupSecretKey:(NSString *)secretKey;

@end



#import "CJResponseModel.h"


@interface CJNetworkClient : NSObject {
    
}
- (void)setupCleanHTTPSessionManager:(AFHTTPSessionManager *)cleanHTTPSessionManager
             cryptHTTPSessionManager:(AFHTTPSessionManager<CJNetworkCryptHTTPSessionManagerProtocol> *)cryptHTTPSessionManager
                  environmentManager:(id<CJNetworkEnvironmentProtocol>)environmentManager;

- (void)setupResponseFirstJudgeLogicSuccessBlock:(BOOL(^)(CJResponseModel *responseModel))firstJudgeLogicSuccessBlock getRequestFailureMessageBlock:(NSString* (^)(NSError *error))getRequestFailureMessageBlock;

- (void)setupSimulateDomain:(NSString *)simulateDomain;

#pragma mark - Environment
- (void)updateEnvironmentModel:(id)environmentModel;
- (void)updateEnvironmentSpecificCommonParams:(NSMutableDictionary *)specificCommonParams;

#pragma mark - Crypt
- (void)setupCryptSecretKey:(NSString *)secretKey;

- (NSURLSessionDataTask *)exampleReal_getUrl:(NSString *)Url
                                      params:(NSDictionary *)params
                                settingModel:(CJRequestSettingModel *)settingModel
                                     success:(void (^)(CJResponseModel *responseModel))success
                                     failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

- (NSURLSessionDataTask *)exampleReal_postUrl:(NSString *)Url
                                       params:(id)params
                                 settingModel:(CJRequestSettingModel *)settingModel
                                      success:(void (^)(CJResponseModel *responseModel))success
                                      failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

#pragma mark simulate
- (NSURLSessionDataTask *)exampleSimulate_getApi:(NSString *)apiSuffix
                                          params:(NSDictionary *)params
                                    settingModel:(CJRequestSettingModel *)settingModel
                                         success:(void (^)(CJResponseModel *responseModel))success
                                         failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

- (NSURLSessionDataTask *)exampleSimulate_postApi:(NSString *)apiSuffix
                                           params:(id)params
                                     settingModel:(CJRequestSettingModel *)settingModel
                                          success:(void (^)(CJResponseModel *responseModel))success
                                          failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

#pragma mark - localApi
- (NSURLSessionDataTask *)exampleLocal_getApi:(NSString *)apiSuffix
                                       params:(NSDictionary *)params
                                 settingModel:(CJRequestSettingModel *)settingModel
                                      success:(void (^)(CJResponseModel *responseModel))success
                                      failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

- (NSURLSessionDataTask *)exampleLocal_postApi:(NSString *)apiSuffix
                                        params:(id)params
                                  settingModel:(CJRequestSettingModel *)settingModel
                                       success:(void (^)(CJResponseModel *responseModel))success
                                       failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

@end

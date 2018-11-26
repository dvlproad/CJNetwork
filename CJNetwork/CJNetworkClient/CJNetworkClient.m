//
//  CJNetworkClient.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJNetworkClient.h"
#import <objc/runtime.h>

#import "CJRequestSimulateUtil.h"

@interface CJNetworkClient () {
    
}
#pragma mark - 整体网络
@property (nonatomic, strong) AFHTTPSessionManager *cleanHTTPSessionManager;
@property (nonatomic, strong) AFHTTPSessionManager<CJNetworkCryptHTTPSessionManagerProtocol> *cryptHTTPSessionManager;
@property (nonatomic, strong) id<CJNetworkEnvironmentProtocol> environmentManager;
//@property (nonatomic, copy) NSString *(^completeUrlBlock)(id environmentManager, NSString *apiSuffix);
//@property (nonatomic, copy) NSDictionary *(^completeParamsBlock)(id environmentManager, NSDictionary *customParams);

#pragma mark - 请求判断
//必须实现：对"请求成功的success回调"做初次判断，设置哪些情况可以继续走success回调(如statusCode==1)，其余转为走failue回调。(有些特殊情况的好处：当只有statusCode==1的才能继续走success回调的时候，就不用每个请求的sucess都写一遍statusCode==1的判断了)
@property (nonatomic, copy) BOOL(^firstJudgeLogicSuccessBlock)(CJResponseModel *responseModel);

//可选实现：获取"请求失败的回调"的错误信息
@property (nonatomic, copy) NSString* (^getRequestFailureMessageBlock)(NSError *error);

#pragma mark - 网络模拟
@property (nonatomic, copy) NSString *simulateDomain;   /**< 模拟接口所在的域名 */

@end



@implementation CJNetworkClient

- (void)setupCleanHTTPSessionManager:(AFHTTPSessionManager *)cleanHTTPSessionManager
             cryptHTTPSessionManager:(AFHTTPSessionManager<CJNetworkCryptHTTPSessionManagerProtocol> *)cryptHTTPSessionManager
                  environmentManager:(id<CJNetworkEnvironmentProtocol>)environmentManager
{
    self.cleanHTTPSessionManager = cleanHTTPSessionManager;
    self.cryptHTTPSessionManager = cryptHTTPSessionManager;
    self.environmentManager = environmentManager;
}

- (void)setupResponseFirstJudgeLogicSuccessBlock:(BOOL(^)(CJResponseModel *responseModel))firstJudgeLogicSuccessBlock getRequestFailureMessageBlock:(NSString* (^)(NSError *error))getRequestFailureMessageBlock
{
    self.firstJudgeLogicSuccessBlock = firstJudgeLogicSuccessBlock;
    self.getRequestFailureMessageBlock = getRequestFailureMessageBlock;
}

- (void)setupSimulateDomain:(NSString *)simulateDomain {
    self.simulateDomain = simulateDomain;
}

/*
#pragma mark - 单例
+ (instancetype)sharedInstance {
    id sharedInstance = objc_getAssociatedObject(self, @"cjNetworkClientSharedInstance");
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL] init];
        objc_setAssociatedObject(self, @"cjNetworkClientSharedInstance", sharedInstance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[self class] sharedInstance];
}
*/

#pragma mark - Base
- (NSURLSessionDataTask *)exampleReal_getUrl:(NSString *)Url
                                      params:(NSDictionary *)params
                                settingModel:(CJRequestSettingModel *)settingModel
                                     success:(void (^)(CJResponseModel *responseModel))success
                                     failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    NSDictionary *allParams = [self.environmentManager completeParamsWithCustomParams:params];
    
    AFHTTPSessionManager *manager = self.cleanHTTPSessionManager;
    
    NSURLSessionDataTask *dataTask =
    [manager cj_getUrl:Url params:allParams settingModel:settingModel success:^(CJSuccessRequestInfo * _Nullable successNetworkInfo) {
        NSDictionary *responseDictionary = successNetworkInfo.responseObject;
        //CJResponseModel *responseModel = [CJResponseModel mj_objectWithKeyValues:responseDictionary];
        CJResponseModel *responseModel = [[CJResponseModel alloc] initWithResponseDictionary:responseDictionary isCacheData:successNetworkInfo.isCacheData];
        
        NSAssert(self.firstJudgeLogicSuccessBlock, @"对请求成功的success回调做初次判断，设置哪些情况可以继续走success回调的方法不能为空");
        BOOL logicSuccess = self.firstJudgeLogicSuccessBlock(responseModel);
        if (logicSuccess) {
            if (success) {
                success(responseModel);
            }
        } else {
            NSString *logicFailureMessage = responseModel.message;
            if (failure) {
                failure(NO, logicFailureMessage);
            }
        }
    } failure:^(CJFailureRequestInfo * _Nullable failureNetworkInfo) {
        NSError *error = failureNetworkInfo.error;
        NSString *errorMessage = failureNetworkInfo.errorMessage;
        if (self.getRequestFailureMessageBlock) {
            errorMessage = self.getRequestFailureMessageBlock(error);
        }
        //CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        //responseModel.status = -1;
        //responseModel.message = NSLocalizedString(@"网络请求失败", nil);
        //responseModel.result = nil;
        
        if (failure) {
            failure(YES, errorMessage);
        }
    }];
    
    return dataTask;
}


- (NSURLSessionDataTask *)exampleReal_postUrl:(NSString *)Url
                                       params:(id)params
                                 settingModel:(CJRequestSettingModel *)settingModel
                                      success:(void (^)(CJResponseModel *responseModel))success
                                      failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    
    NSDictionary *allParams = [self.environmentManager completeParamsWithCustomParams:params];
    
    AFHTTPSessionManager *manager = nil;
    if (encrypt) {
        manager = self.cryptHTTPSessionManager;
    } else {
        manager = self.cleanHTTPSessionManager;
    }
    
    NSURLSessionDataTask *URLSessionDataTask =
    [manager cj_postUrl:Url params:allParams settingModel:settingModel success:^(CJSuccessRequestInfo * _Nullable successNetworkInfo) {
        NSDictionary *responseDictionary = successNetworkInfo.responseObject;
        //CJResponseModel *responseModel = [CJResponseModel mj_objectWithKeyValues:responseDictionary];
        CJResponseModel *responseModel = [[CJResponseModel alloc] initWithResponseDictionary:responseDictionary isCacheData:successNetworkInfo.isCacheData];
        NSAssert(self.firstJudgeLogicSuccessBlock, @"对请求成功的success回调做初次判断，设置哪些情况可以继续走success回调的方法不能为空");
        BOOL logicSuccess = self.firstJudgeLogicSuccessBlock(responseModel);
        if (logicSuccess) {
            if (success) {
                success(responseModel);
            }
        } else {
            NSString *logicFailureMessage = responseModel.message;
            if (failure) {
                failure(NO, logicFailureMessage);
            }
        }
        
    } failure:^(CJFailureRequestInfo * _Nullable failureNetworkInfo) {
        NSError *error = failureNetworkInfo.error;
        NSString *errorMessage = failureNetworkInfo.errorMessage;
        if (self.getRequestFailureMessageBlock) {
            errorMessage = self.getRequestFailureMessageBlock(error);
        }
        //CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        //responseModel.status = -1;
        //responseModel.message = NSLocalizedString(@"网络请求失败", nil);
        //responseModel.result = nil;
        
        if (failure) {
            failure(YES, errorMessage);
        }
    }];
    
    return URLSessionDataTask;
}

#pragma mark simulate
- (NSURLSessionDataTask *)exampleSimulate_getApi:(NSString *)apiSuffix
                                          params:(NSDictionary *)params
                                    settingModel:(CJRequestSettingModel *)settingModel
                                         success:(void (^)(CJResponseModel *responseModel))success
                                         failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    NSString *Url = [CJRequestSimulateUtil remoteSimulateUrlWithDomain:self.simulateDomain apiSuffix:apiSuffix];
    
    return [self exampleReal_getUrl:Url params:params settingModel:settingModel success:success failure:failure];
}


- (NSURLSessionDataTask *)exampleSimulate_postApi:(NSString *)apiSuffix
                                           params:(id)params
                                     settingModel:(CJRequestSettingModel *)settingModel
                                          success:(void (^)(CJResponseModel *responseModel))success
                                          failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    NSString *Url = [CJRequestSimulateUtil remoteSimulateUrlWithDomain:self.simulateDomain apiSuffix:apiSuffix];
    
    return [self exampleReal_getUrl:Url params:params settingModel:settingModel success:success failure:failure];
}

#pragma mark - localApi
- (NSURLSessionDataTask *)exampleLocal_getApi:(NSString *)apiSuffix
                                       params:(NSDictionary *)params
                                 settingModel:(CJRequestSettingModel *)settingModel
                                      success:(void (^)(CJResponseModel *responseModel))success
                                      failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    [CJRequestSimulateUtil localSimulateApi:apiSuffix completeBlock:^(NSDictionary *responseDictionary) {
        //CJResponseModel *responseModel = [CJResponseModel mj_objectWithKeyValues:responseDictionary];
        CJResponseModel *responseModel = [[CJResponseModel alloc] initWithResponseDictionary:responseDictionary isCacheData:NO];
        if (success) {
            success(responseModel);
        }
    }];
    return nil;
}


- (NSURLSessionDataTask *)exampleLocal_postApi:(NSString *)apiSuffix
                                        params:(id)params
                                  settingModel:(CJRequestSettingModel *)settingModel
                                       success:(void (^)(CJResponseModel *responseModel))success
                                       failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    [CJRequestSimulateUtil localSimulateApi:apiSuffix completeBlock:^(NSDictionary *responseDictionary) {
        //CJResponseModel *responseModel = [CJResponseModel mj_objectWithKeyValues:responseDictionary];
        CJResponseModel *responseModel = [[CJResponseModel alloc] initWithResponseDictionary:responseDictionary isCacheData:NO];
        if (success) {
            success(responseModel);
        }
    }];
    return nil;
}


#pragma mark - Environment
- (void)updateEnvironmentModel:(id)environmentModel {
    self.environmentManager.environmentModel = environmentModel;
}

- (void)updateEnvironmentSpecificCommonParams:(NSMutableDictionary *)specificCommonParams {
    self.environmentManager.specificCommonParams = specificCommonParams;
}

#pragma mark - Crypt
- (void)setupCryptSecretKey:(NSString *)secretKey {
    [self.cryptHTTPSessionManager setupSecretKey:secretKey];
}


@end

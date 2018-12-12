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
@property (nonatomic, strong) AFHTTPSessionManager *cryptHTTPSessionManager;
@property (nonatomic, copy) NSString *(^completeFullUrlBlock)(NSString *apiSuffix);
@property (nonatomic, copy) NSDictionary *(^completeAllParamsBlock)(NSDictionary *customParams);

#pragma mark - 请求判断
//必须实现：将responseObject转为CJResponseModel
@property (nonatomic, copy) CJResponseModel *(^responseConvertBlock)(id responseObject, BOOL isCacheData);

//必须实现：检查是否是共同错误并在此对共同错误做处理，如statusCode == -5 为异地登录(可为ni,非nil时一般返回值为NO)
@property (nonatomic, copy) BOOL(^checkIsCommonBlock)(CJResponseModel *responseModel);

//可选实现：获取"请求失败的回调"的错误信息
@property (nonatomic, copy) NSString* (^getRequestFailureMessageBlock)(NSError *error);

#pragma mark - 网络模拟
@property (nonatomic, copy) NSString *simulateDomain;   /**< 模拟接口所在的域名 */

@end



@implementation CJNetworkClient

- (void)setupCleanHTTPSessionManager:(AFHTTPSessionManager *)cleanHTTPSessionManager
             cryptHTTPSessionManager:(AFHTTPSessionManager *)cryptHTTPSessionManager
{
    NSAssert(cleanHTTPSessionManager || cryptHTTPSessionManager, @"不加密和加密的不可以同时都没有");
    self.cleanHTTPSessionManager = cleanHTTPSessionManager;
    self.cryptHTTPSessionManager = cryptHTTPSessionManager;
}

- (void)setupCompleteFullUrlBlock:(NSString * (^)(NSString *apiSuffix))completeFullUrlBlock
           completeAllParamsBlock:(NSDictionary * (^)(NSDictionary *customParams))completeAllParamsBlock
{
    NSAssert(completeFullUrlBlock, @"Url 的获取方法都不能为空");
    _completeFullUrlBlock = completeFullUrlBlock;
    _completeAllParamsBlock = completeAllParamsBlock;
}

- (void)setupResponseConvertBlock:(CJResponseModel *(^)(id responseObject, BOOL isCacheData))responseConvertBlock
               checkIsCommonBlock:(BOOL(^)(CJResponseModel *responseModel))checkIsCommonBlock
    getRequestFailureMessageBlock:(NSString* (^)(NSError *error))getRequestFailureMessageBlock
{
    NSAssert(responseConvertBlock, @"responseConvertBlock不能为空");
    self.responseConvertBlock = responseConvertBlock;
    self.checkIsCommonBlock = checkIsCommonBlock;
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

#pragma mark - Real
- (NSURLSessionDataTask *)real_getApi:(NSString *)apiSuffix
                               params:(NSDictionary *)params
                         settingModel:(CJRequestSettingModel *)settingModel
                        completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSString *Url = self.completeFullUrlBlock(apiSuffix);
    
    return [self requestUrl:Url params:params method:CJRequestMethodGET settingModel:settingModel completeBlock:completeBlock];
}

- (NSURLSessionDataTask *)real_postApi:(NSString *)apiSuffix
                                params:(id)params
                          settingModel:(CJRequestSettingModel *)settingModel
                         completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSString *Url = self.completeFullUrlBlock(apiSuffix);
    
    return [self requestUrl:Url params:params method:CJRequestMethodPOST settingModel:settingModel completeBlock:completeBlock];
}

#pragma mark simulate
- (NSURLSessionDataTask *)simulate_getApi:(NSString *)apiSuffix
                                   params:(NSDictionary *)params
                             settingModel:(CJRequestSettingModel *)settingModel
                            completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSString *Url = [CJRequestSimulateUtil remoteSimulateUrlWithDomain:self.simulateDomain apiSuffix:apiSuffix];
    
    return [self requestUrl:Url params:params method:CJRequestMethodGET settingModel:settingModel completeBlock:completeBlock];
}


- (NSURLSessionDataTask *)simulate_postApi:(NSString *)apiSuffix
                                    params:(id)params
                              settingModel:(CJRequestSettingModel *)settingModel
                             completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSString *Url = [CJRequestSimulateUtil remoteSimulateUrlWithDomain:self.simulateDomain apiSuffix:apiSuffix];
    
    return [self requestUrl:Url params:params method:CJRequestMethodGET settingModel:settingModel completeBlock:completeBlock];
}

#pragma mark - localApi
- (NSURLSessionDataTask *)local_getApi:(NSString *)apiSuffix
                                params:(NSDictionary *)params
                          settingModel:(CJRequestSettingModel *)settingModel
                         completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    [CJRequestSimulateUtil localSimulateApi:apiSuffix completeBlock:^(NSDictionary *responseDictionary) {
        BOOL isCacheData = NO;
        CJResponseModel *responseModel = self.responseConvertBlock(responseDictionary, isCacheData);
        
        if (completeBlock) {
            completeBlock(CJResponeFailureTypeUncheck, responseModel);
        }
    }];
    return nil;
}


- (NSURLSessionDataTask *)local_postApi:(NSString *)apiSuffix
                                 params:(id)params
                           settingModel:(CJRequestSettingModel *)settingModel
                          completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    [CJRequestSimulateUtil localSimulateApi:apiSuffix completeBlock:^(NSDictionary *responseDictionary) {
        BOOL isCacheData = NO;
        CJResponseModel *responseModel = self.responseConvertBlock(responseDictionary, isCacheData);
        
        if (completeBlock) {
            completeBlock(CJResponeFailureTypeUncheck, responseModel);
        }
    }];
    return nil;
}


#pragma mark - Base
- (nullable NSURLSessionDataTask *)requestUrl:(nullable NSString *)Url
                                       params:(nullable id)customParams
                                       method:(CJRequestMethod)method
                                 settingModel:(CJRequestSettingModel *)settingModel
                                completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    AFHTTPSessionManager *manager = nil;
    if (method == CJRequestMethodGET) {
        manager = self.cleanHTTPSessionManager;
        
    } else if (method == CJRequestMethodPOST) {
        manager = settingModel.shouldEncrypt ? self.cryptHTTPSessionManager : self.cleanHTTPSessionManager;
    }
    
    NSDictionary *allParams = customParams;
    if (self.completeAllParamsBlock) {
        allParams = self.completeAllParamsBlock(customParams);
    }
    
    NSURLSessionDataTask *URLSessionDataTask =
    [manager cj_requestUrl:Url params:allParams method:method settingModel:settingModel success:^(CJSuccessRequestInfo * _Nullable successNetworkInfo) {
        NSDictionary *responseDictionary = successNetworkInfo.responseObject;
        BOOL isCacheData = successNetworkInfo.isCacheData;
        CJResponseModel *responseModel = self.responseConvertBlock(responseDictionary, isCacheData);
        //方式①
        //CJResponseModel *responseModel = [CJResponseModel mj_objectWithKeyValues:responseDictionary];
        //方式②
        //CJResponseModel *responseModel = [[CJResponseModel alloc] initWithResponseDictionary:responseDictionary isCacheData:successNetworkInfo.isCacheData];
        //方式③
        //CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        //responseModel.statusCode = [responseDictionary[@"status"] integerValue];
        //responseModel.message = responseDictionary[@"message"];
        //responseModel.result = responseDictionary[@"result"];
        //responseModel.isCacheData = isCacheData;
        
        if (self.checkIsCommonBlock) {
            BOOL isCommonFailure = self.checkIsCommonBlock(responseModel);
            CJResponeFailureType failureType = isCommonFailure ? CJResponeFailureTypeCommonFailure : CJResponeFailureTypeNeedFurtherJudgeFailure;
            if (completeBlock) {
                completeBlock(failureType, responseModel);
            }
            
        } else {
            if (completeBlock) {
                completeBlock(CJResponeFailureTypeNeedFurtherJudgeFailure, responseModel);
            }
        }
        
        
    } failure:^(CJFailureRequestInfo * _Nullable failureNetworkInfo) {
        NSError *error = failureNetworkInfo.error;
        NSString *errorMessage = failureNetworkInfo.errorMessage;
        if (self.getRequestFailureMessageBlock) {
            errorMessage = self.getRequestFailureMessageBlock(error);
        }
        
        CJResponseModel *responseModel = [CJResponseModel responseModelWithRequestFailureMessage:errorMessage];
        CJResponeFailureType failureType = CJResponeFailureTypeRequestFailure;
        if (completeBlock) {
            completeBlock(failureType, responseModel);
        }
    }];
    
    return URLSessionDataTask;
}

@end

//
//  CJNetworkClient+Completion.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJNetworkClient+Completion.h"
#import <CJNetworkSimulate/CJSimulateUtil.h>
#import <CJNetwork/AFHTTPSessionManager+CJSerializerEncrypt.h>

@implementation CJNetworkClient (Completion)

#pragma mark - RealApi
- (NSURLSessionDataTask *)real1_getApi:(NSString *)apiSuffix
                                params:(NSDictionary *)params
                          settingModel:(nullable CJRequestSettingModel *)settingModel
                         completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSString *baseUrl = self.baseUrl;
    //NSString *baseUrl = settingModel.ownBaseUrl ? settingModel.ownBaseUrl : self.baseUrl;
    NSString *Url = self.completeFullUrlBlock(baseUrl, apiSuffix);
    
    return [self __requestUrl:Url params:params method:CJRequestMethodGET settingModel:settingModel completeBlock:completeBlock];
}

- (NSURLSessionDataTask *)real1_postApi:(NSString *)apiSuffix
                                 params:(id)params
                           settingModel:(nullable CJRequestSettingModel *)settingModel
                          completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSString *baseUrl = self.baseUrl;
    //NSString *baseUrl = settingModel.ownBaseUrl ? settingModel.ownBaseUrl : self.baseUrl;
    NSString *Url = self.completeFullUrlBlock(baseUrl, apiSuffix);
    
    return [self __requestUrl:Url params:params method:CJRequestMethodPOST settingModel:settingModel completeBlock:completeBlock];
}

- (nullable NSURLSessionDataTask *)__requestUrl:(NSString *)Url
                                         params:(nullable id)customParams
                                         method:(CJRequestMethod)method
                                   settingModel:(nullable CJRequestSettingModel *)settingModel
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
    
    CJRequestCacheSettingModel *cacheSettingModel = settingModel.requestCacheModel;
    CJRequestLogType logType = settingModel.logType;
    void (^progress)(NSProgress * _Nonnull) = settingModel.uploadProgress;
    
    NSDictionary<NSString *, NSString *> *headers = @{};
    
    NSURLSessionDataTask *URLSessionDataTask =
    [manager cj_requestUrl:Url params:allParams headers:headers method:method cacheSettingModel:cacheSettingModel logType:logType progress:progress success:^(CJSuccessRequestInfo * _Nullable successNetworkInfo) {
        [CJResponseHelper __dealSuccessRequestInfo:successNetworkInfo
                      getSuccessResponseModelBlock:self.getSuccessResponseModelBlock
                         checkIsCommonFailureBlock:self.checkIsCommonFailureBlock
                                     completeBlock:completeBlock];
        
    } failure:^(CJFailureRequestInfo * _Nullable failureNetworkInfo) {
        [CJResponseHelper __dealFailureNetworkInfo:failureNetworkInfo
                      getFailureResponseModelBlock:self.getFailureResponseModelBlock
                                     completeBlock:completeBlock];
    }];
    
    return URLSessionDataTask;
}


#pragma mark - simulateApi
- (NSURLSessionDataTask *)simulate1_getApi:(NSString *)apiSuffix
                                    params:(NSDictionary *)params
                              settingModel:(nullable CJRequestSettingModel *)settingModel
                             completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock
{
    NSString *Url = [self __remoteSimulateUrlWithDomain:self.simulateDomain apiSuffix:apiSuffix];
    
    [CJSimulateUtil getSimulateApi:Url success:^(NSDictionary * _Nonnull responseDictionary) {
        CJResponseModel *responseModel = self.getSuccessResponseModelBlock(responseDictionary, NO);
        if (completeBlock) {
            completeBlock(CJResponeFailureTypeUncheck, responseModel);
        }
        
    } failure:^(NSError * _Nonnull error, NSString * _Nullable errorMessage) {
        CJResponseModel *responseModel = self.getFailureResponseModelBlock(error, errorMessage);
        if (completeBlock) {
            completeBlock(CJResponeFailureTypeRequestFailure, responseModel);
        }
    }];
    return nil;
}


- (NSURLSessionDataTask *)simulate1_postApi:(NSString *)apiSuffix
                                     params:(id)params
                               settingModel:(nullable CJRequestSettingModel *)settingModel
                              completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock
{
    NSString *Url = [self __remoteSimulateUrlWithDomain:self.simulateDomain apiSuffix:apiSuffix];

    [CJSimulateUtil postSimulateApi:Url success:^(NSDictionary * _Nonnull responseDictionary) {
        CJResponseModel *responseModel = self.getSuccessResponseModelBlock(responseDictionary, NO);
        if (completeBlock) {
            completeBlock(CJResponeFailureTypeUncheck, responseModel);
        }
        
    } failure:^(NSError * _Nonnull error, NSString * _Nullable errorMessage) {
        CJResponseModel *responseModel = self.getFailureResponseModelBlock(error, errorMessage);
        if (completeBlock) {
            completeBlock(CJResponeFailureTypeRequestFailure, responseModel);
        }
    }];
    return nil;
}


/**
 *  获取模拟接口的完整模拟Url(如果接口名包含域名了，则直接使用接口名)
 *
 *  @param simulateDomain   设置模拟接口所在的域名(若未设置则将使用http://localhost/+类名作为域名)
 *  @param apiSuffix        接口名(如果接口名包含域名了，则直接使用接口名)
 *
 *  return  模拟接口的完整模拟Url
 */
- (NSString *)__remoteSimulateUrlWithDomain:(NSString *)simulateDomain
                                  apiSuffix:(NSString *)apiSuffix
{
    NSString *Url = nil;
    if ([apiSuffix hasPrefix:@"http"]) {
        Url = apiSuffix;
    } else {
        NSString *urlDomain = nil;
        if (simulateDomain.length > 0) {
            urlDomain = simulateDomain;
        } else {
            urlDomain = @"http://localhost/";
        }
        Url = [urlDomain stringByAppendingString:apiSuffix];
    }
    
    return Url;
}


#pragma mark - localApi
- (nullable NSURLSessionDataTask *)local1_getApi:(NSString *)apiSuffix
                                          params:(NSDictionary *)params
                                    settingModel:(nullable CJRequestSettingModel *)settingModel
                                   completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock
{
    return [self __localApi:apiSuffix completeBlock:completeBlock];
}


- (nullable NSURLSessionDataTask *)local1_postApi:(NSString *)apiSuffix
                                           params:(id)params
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                    completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock
{
    return [self __localApi:apiSuffix completeBlock:completeBlock];
}



- (NSURLSessionDataTask *)__localApi:(NSString *)apiSuffix
                       completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock
{
    [CJSimulateUtil localSimulateApi:apiSuffix completeBlock:^(NSDictionary *responseDictionary) {
        BOOL isCacheData = NO;
        CJResponseModel *responseModel = self.getSuccessResponseModelBlock(responseDictionary, isCacheData);
        
        if (completeBlock) {
            completeBlock(CJResponeFailureTypeUncheck, responseModel);
        }
    }];
    return nil;
}




@end

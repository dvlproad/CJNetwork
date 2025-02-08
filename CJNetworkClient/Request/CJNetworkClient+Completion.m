//
//  CJNetworkClient+Completion.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJNetworkClient+Completion.h"
#import <CJNetworkSimulate/CJSimulateRemoteUtil.h>
#import <CJNetworkSimulate/CJSimulateLocalUtil.h>
#import <CJNetwork/AFHTTPSessionManager+CJSerializerEncrypt.h>

@implementation CJNetworkClient (Completion)

- (NSURLSessionDataTask *)requestModel:(__kindof NSObject<CJRequestModelProtocol> *)model
                         completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    CQRequestType requestType = [model requestType];
    if (requestType == CQRequestTypeReal) {
        return [self real1_requestModel:model completeBlock:completeBlock];
        
    } else if (requestType == CQRequestTypeSimulate) {
        return [self simulate1_requestModel:model completeBlock:completeBlock];
        
    } else if (requestType == CQRequestTypeLocal) {
        return [self local1_requestModel:model completeBlock:completeBlock];
    }
    
    return [self real1_requestModel:model completeBlock:completeBlock];
}

#pragma mark - RealApi
- (NSURLSessionDataTask *)real1_requestModel:(__kindof NSObject<CJRequestModelProtocol> *)model
                               completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSString *baseUrl = [model ownBaseUrl];
    if (baseUrl == nil) {
        baseUrl = self.baseUrl;
    }
    
    NSString *apiSuffix = [model apiSuffix];
    NSString *Url = self.completeFullUrlBlock(baseUrl, apiSuffix);
    
    id customParams = [model customParams];
    
    CJRequestMethod requestMethod = [model requestMethod];
    
    AFHTTPSessionManager *manager = nil;
    if (requestMethod == CJRequestMethodGET) {
        manager = self.cleanHTTPSessionManager;
        
    } else if (requestMethod == CJRequestMethodPOST) {
        BOOL shouldEncrypt = [model requestEncrypt] == CJRequestEncryptYES;
        manager = shouldEncrypt ? self.cryptHTTPSessionManager : self.cleanHTTPSessionManager;
    }
    
    NSDictionary *allParams = customParams;
    if (self.completeAllParamsBlock) {
        allParams = self.completeAllParamsBlock(customParams);
    }
    
    void (^progressBlock)(NSProgress * _Nonnull);
    if ([model respondsToSelector:@selector(uploadProgress)]) {
        progressBlock = model.uploadProgress;
    } else {
        progressBlock = nil;
    }
    
    CJRequestSettingModel *settingModel = [model settingModel];
    CJRequestCacheSettingModel *cacheSettingModel = settingModel.requestCacheModel;
    CJRequestLogType logType = settingModel.logType;
    
    
    NSDictionary<NSString *, NSString *> *headers = @{};
    
    NSURLSessionDataTask *URLSessionDataTask =
    [manager cj_requestUrl:Url params:allParams headers:headers method:requestMethod cacheSettingModel:cacheSettingModel logType:logType progress:progressBlock success:^(CJSuccessRequestInfo * _Nullable successNetworkInfo) {
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
- (NSURLSessionDataTask *)simulate1_requestModel:(__kindof NSObject<CJRequestModelProtocol> *)model
                                   completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock
{
    NSString *apiSuffix = [model apiSuffix];
    NSString *Url = [self __remoteSimulateUrlWithDomain:self.simulateDomain apiSuffix:apiSuffix];
    
    id params = [model params];
    
    CJRequestMethod requestMethod = [model requestMethod];
    if (requestMethod == CJRequestMethodGET) {
        [CJSimulateRemoteUtil getUrl:Url params:params success:^(NSDictionary * _Nonnull responseDictionary) {
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
        
    } else {
        [CJSimulateRemoteUtil postUrl:Url params:params success:^(NSDictionary * _Nonnull responseDictionary) {
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
    
    
}


/*
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
- (nullable NSURLSessionDataTask *)local1_requestModel:(__kindof NSObject<CJRequestModelProtocol> *)model
                                         completeBlock:(void (^)(CJResponeFailureType failureType, id responseModel))completeBlock
{
    NSString *apiSuffix = [model apiSuffix];

    [CJSimulateLocalUtil localSimulateApi:apiSuffix completeBlock:^(NSDictionary *responseDictionary) {
        BOOL isCacheData = NO;
        CJResponseModel *responseModel = self.getSuccessResponseModelBlock(responseDictionary, isCacheData);
        
        if (completeBlock) {
            completeBlock(CJResponeFailureTypeUncheck, responseModel);
        }
    }];
    return nil;
}




@end

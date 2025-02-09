//
//  CJNetworkInstance+OriginCallback.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJNetworkInstance+OriginCallback.h"

#import <CJNetworkSimulate/CJSimulateRemoteUtil.h>
#import <CJNetworkSimulate/CJSimulateLocalUtil.h>
#import <CJNetwork/AFHTTPSessionManager+CJSerializerEncrypt.h>

@implementation CJNetworkInstance (OriginCallback)


- (NSURLSessionDataTask *)requestModel:(__kindof NSObject<CJRequestModelProtocol> *)model
                   originCompleteBlock:(void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo, CJFailureRequestInfo * _Nullable failureRequestInfo))completeBlock
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
                               completeBlock:(void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo, CJFailureRequestInfo * _Nullable failureRequestInfo))completeBlock
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
    [manager cj_requestUrl:Url params:allParams headers:headers method:requestMethod cacheSettingModel:cacheSettingModel logType:logType progress:progressBlock success:^(CJSuccessRequestInfo * _Nullable successRequestInfo) {
        completeBlock(successRequestInfo, nil);
    } failure:^(CJFailureRequestInfo * _Nullable failureRequestInfo) {
        completeBlock(nil, failureRequestInfo);
    }];
    
    return URLSessionDataTask;
}


#pragma mark - simulateApi
- (NSURLSessionDataTask *)simulate1_requestModel:(__kindof NSObject<CJRequestModelProtocol> *)model
                                   completeBlock:(void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo, CJFailureRequestInfo * _Nullable failureRequestInfo))completeBlock
{
    NSString *apiSuffix = [model apiSuffix];
    NSString *Url = [self __remoteSimulateUrlWithDomain:self.simulateDomain apiSuffix:apiSuffix];
    
    id params = [model params];
    
    CJRequestMethod requestMethod = [model requestMethod];
    if (requestMethod == CJRequestMethodGET) {
        CJRequestLogType logType = CJRequestLogTypeConsoleLog;
        [CJSimulateRemoteUtil getUrl:Url params:params success:^(NSDictionary * _Nonnull responseDictionary) {
            CJSuccessRequestInfo *successRequestInfo = [CJSuccessRequestInfo successNetworkLogWithType:logType Url:Url params:params request:nil responseObject:responseDictionary];
            if (completeBlock) {
                completeBlock(successRequestInfo, nil);
            }
            
        } failure:^(NSError * _Nonnull error, NSString * _Nullable errorMessage) {
            CJFailureRequestInfo *failureRequestInfo = [CJFailureRequestInfo errorNetworkLogWithType:logType Url:Url params:params request:nil error:error URLResponse:nil];
            failureRequestInfo.isRequestFailure = YES;
            if (completeBlock) {
                completeBlock(nil, failureRequestInfo);
            }
        }];
        return nil;
        
    } else {
        CJRequestLogType logType = CJRequestLogTypeConsoleLog;
        [CJSimulateRemoteUtil postUrl:Url params:params success:^(NSDictionary * _Nonnull responseDictionary) {
            CJSuccessRequestInfo *successRequestInfo = [CJSuccessRequestInfo successNetworkLogWithType:logType Url:Url params:params request:nil responseObject:responseDictionary];
            if (completeBlock) {
                completeBlock(successRequestInfo, nil);
            }
            
        } failure:^(NSError * _Nonnull error, NSString * _Nullable errorMessage) {
            CJFailureRequestInfo *failureRequestInfo = [CJFailureRequestInfo errorNetworkLogWithType:logType Url:Url params:params request:nil error:error URLResponse:nil];
            failureRequestInfo.isRequestFailure = YES;
            if (completeBlock) {
                completeBlock(nil, failureRequestInfo);
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
                                         completeBlock:(void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo, CJFailureRequestInfo * _Nullable failureRequestInfo))completeBlock
{
    NSString *apiSuffix = [model apiSuffix];

    [CJSimulateLocalUtil localSimulateApi:apiSuffix completeBlock:^(NSDictionary *responseDictionary) {
        CJRequestLogType logType = CJRequestLogTypeConsoleLog;
        CJSuccessRequestInfo *successRequestInfo = [CJSuccessRequestInfo successNetworkLogWithType:logType Url:@"local1_requestModel" params:nil request:nil responseObject:responseDictionary];
        if (completeBlock) {
            completeBlock(successRequestInfo, nil);
        }
    }];
    return nil;
}




@end

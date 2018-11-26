//
//  TestNetworkClient.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TestNetworkClient.h"
#import "TestHTTPSessionManager.h"

#import "CJNetworkCacheUtil.h"
#import "CJRequestSimulateUtil.h"

@implementation TestNetworkClient

+ (TestNetworkClient *)sharedInstance {
    static TestNetworkClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (nullable NSURLSessionDataTask *)testSimulate_postApiSuffix:(NSString *)apiSuffix
                                                       params:(nullable id)params
                                                 settingModel:(CJRequestSettingModel *)settingModel
                                            shouldRemoveCache:(BOOL)shouldRemoveCache
                                                      success:(void (^)(CJResponseModel *responseModel))success
                                                      failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    NSString *domain = @"http://localhost/CJDemoDataSimulationDemo";
    NSString *Url = [domain stringByAppendingString:apiSuffix];
    
    if (shouldRemoveCache) {
        [CJNetworkCacheUtil removeCacheForUrl:Url params:params];
    }
    
    AFHTTPSessionManager *manager = [TestHTTPSessionManager sharedInstance];
    
    NSURLSessionDataTask *URLSessionDataTask =
    [manager cj_getUrl:Url params:params settingModel:settingModel success:^(CJSuccessRequestInfo * _Nullable successRequestInfo) {
        NSDictionary *responseDictionary = successRequestInfo.responseObject;
        CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        responseModel.status = [responseDictionary[@"status"] integerValue];
        responseModel.message = responseDictionary[@"message"];
        responseModel.result = responseDictionary[@"result"];
        responseModel.isCacheData = successRequestInfo.isCacheData;
        if (success) {
            success(responseModel);
        }
        
    } failure:^(CJFailureRequestInfo * _Nullable failureRequestInfo) {
        NSString *errorMessage = failureRequestInfo.errorMessage;
        if (failure) {
            failure(YES, errorMessage);
        }
    }];
    return URLSessionDataTask;
}

- (nullable NSURLSessionDataTask *)testEncrypt_postApiSuffix:(NSString *)apiSuffix
                                                      params:(nullable id)params
                                               cacheStrategy:(CJRequestCacheStrategy)cacheStrategy
                                               completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock
{
    NSString *domain = @"https://localhost/CJDemoDataSimulationDemo";
    NSString *Url = [domain stringByAppendingString:apiSuffix];
    
    CJRequestSettingModel *settingModel = [[CJRequestSettingModel alloc] init];
    settingModel.cacheStrategy = cacheStrategy;
    settingModel.logType = CJRequestLogTypeConsoleLog;
    
    AFHTTPSessionManager *manager = [TestHTTPSessionManager sharedInstance];
    
    NSURLSessionDataTask *URLSessionDataTask =
    [manager cjMethodEncrypt_postUrl:Url params:params settingModel:settingModel encrypt:NO encryptBlock:nil decryptBlock:nil success:^(CJSuccessRequestInfo * _Nullable successRequestInfo) {
        NSDictionary *responseDictionary = successRequestInfo.responseObject;
        CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        responseModel.status = [responseDictionary[@"status"] integerValue];
        responseModel.message = responseDictionary[@"message"];
        responseModel.result = responseDictionary[@"result"];
        responseModel.isCacheData = successRequestInfo.isCacheData;
        if (completeBlock) {
            completeBlock(responseModel);
        }
        
    } failure:^(CJFailureRequestInfo * _Nullable failureRequestInfo) {
        CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        responseModel.status = -1;
        responseModel.message = NSLocalizedString(@"网络请求失败", nil);
        responseModel.result = nil;
        responseModel.isCacheData = NO;
        if (completeBlock) {
            completeBlock(responseModel);
        }
    }];
    return URLSessionDataTask;
}

- (NSURLSessionDataTask *)exampleLocal_postApi:(NSString *)apiSuffix
                                 params:(id)params
                                encrypt:(BOOL)encrypt
                                success:(void (^)(CJResponseModel *responseModel))success
                                failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    [CJRequestSimulateUtil localSimulateApi:apiSuffix completeBlock:^(NSDictionary *responseDictionary) {
        CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        responseModel.status = [responseDictionary[@"status"] integerValue];
        responseModel.message = responseDictionary[@"message"];
        responseModel.result = responseDictionary[@"result"];
        responseModel.isCacheData = NO;
        if (success) {
            success(responseModel);
        }
    }];
    
    return nil;
}

@end

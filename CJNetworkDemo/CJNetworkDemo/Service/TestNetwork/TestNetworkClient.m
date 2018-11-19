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

@implementation TestNetworkClient

- (nullable NSURLSessionDataTask *)testSimulate_postApiSuffix:(NSString *)apiSuffix
                                                       params:(nullable id)params
                                                 settingModel:(CJRequestSettingModel *)settingModel
                                            shouldRemoveCache:(BOOL)shouldRemoveCache
                                                completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock
{
    NSString *domain = @"http://localhost/CJDemoDataSimulationDemo";
    NSString *Url = [domain stringByAppendingString:apiSuffix];
    
    if (shouldRemoveCache) {
        [CJNetworkCacheUtil removeCacheForUrl:Url params:params];
    }
    
    AFHTTPSessionManager *manager = [TestHTTPSessionManager sharedInstance];
    
    NSURLSessionDataTask *URLSessionDataTask =
    [manager cj_getUrl:Url params:params settingModel:settingModel success:^(CJSuccessNetworkInfo * _Nullable successNetworkInfo) {
        NSDictionary *responseDictionary = successNetworkInfo.responseObject;
        CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        responseModel.status = [responseDictionary[@"status"] integerValue];
        responseModel.message = responseDictionary[@"message"];
        responseModel.result = responseDictionary[@"result"];
        responseModel.isCacheData = successNetworkInfo.isCacheData;
        if (completeBlock) {
            completeBlock(responseModel);
        }
        
    } failure:^(CJFailureNetworkInfo * _Nullable failureNetworkInfo) {
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

- (nullable NSURLSessionDataTask *)testEncrypt_postApiSuffix:(NSString *)apiSuffix
                                                      params:(nullable id)params
                                               cacheStrategy:(CJNetworkCacheStrategy)cacheStrategy
                                               completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock
{
    NSString *domain = @"https://localhost/CJDemoDataSimulationDemo";
    NSString *Url = [domain stringByAppendingString:apiSuffix];
    
    CJRequestSettingModel *settingModel = [[CJRequestSettingModel alloc] init];
    settingModel.cacheStrategy = cacheStrategy;
    settingModel.logType = CJNetworkLogTypeConsoleLog;
    
    AFHTTPSessionManager *manager = [TestHTTPSessionManager sharedInstance];
    
    NSURLSessionDataTask *URLSessionDataTask =
    [manager cjMethodEncrypt_postUrl:Url params:params settingModel:settingModel encrypt:NO encryptBlock:nil decryptBlock:nil success:^(CJSuccessNetworkInfo * _Nullable successNetworkInfo) {
        NSDictionary *responseDictionary = successNetworkInfo.responseObject;
        CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        responseModel.status = [responseDictionary[@"status"] integerValue];
        responseModel.message = responseDictionary[@"message"];
        responseModel.result = responseDictionary[@"result"];
        responseModel.isCacheData = successNetworkInfo.isCacheData;
        if (completeBlock) {
            completeBlock(responseModel);
        }
        
    } failure:^(CJFailureNetworkInfo * _Nullable failureNetworkInfo) {
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

- (NSURLSessionDataTask *)local_postApi:(NSString *)apiSuffix
                                 params:(id)params
                                encrypt:(BOOL)encrypt
                                success:(void (^)(CJResponseModel *responseModel))success
                                failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    [self cjLocalSimulateApi:apiSuffix completeBlock:^(NSDictionary *responseDictionary) {
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
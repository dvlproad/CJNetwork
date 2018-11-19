//
//  TestNetworkClient.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TestNetworkClient.h"
#import "TestHTTPSessionManager.h"


@implementation TestNetworkClient

+ (TestNetworkClient *)sharedInstance {
    static TestNetworkClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (nullable NSURLSessionDataTask *)test_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                                cacheStrategy:(CJNetworkCacheStrategy)cacheStrategy
                                completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock
{
    CJRequestSettingModel *settingModel = [[CJRequestSettingModel alloc] init];
    settingModel.cacheStrategy = cacheStrategy;
    settingModel.logType = CJNetworkLogTypeConsoleLog;
    
    AFHTTPSessionManager *manager = [TestHTTPSessionManager sharedInstance];
    
    NSURLSessionDataTask *URLSessionDataTask =
    [manager cjEncrypt_postUrl:Url params:params settingModel:nil encrypt:NO encryptBlock:nil decryptBlock:nil success:^(CJSuccessNetworkInfo * _Nullable successNetworkInfo) {
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

- (void)requestBaiduHomeCompleteBlock:(void (^)(CJResponseModel *responseModel))completeBlock {
    NSString *Url = @"https://www.baidu.com";
    NSDictionary *parameters = nil;
    
    CJNetworkCacheStrategy cacheStrategy = CJNetworkCacheStrategyNoneCache;
    [self test_postUrl:Url params:parameters cacheStrategy:cacheStrategy completeBlock:completeBlock];
}

@end

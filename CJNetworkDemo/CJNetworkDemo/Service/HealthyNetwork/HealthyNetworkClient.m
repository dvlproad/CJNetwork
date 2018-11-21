//
//  HealthyNetworkClient.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "HealthyNetworkClient.h"
#import "HealthyHTTPSessionManager.h"

//API路径--health
#define API_BASE_Url_Health(_Url_) [[@"http://121.40.82.169/drupal/api/" stringByAppendingString:_Url_] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]

@implementation HealthyNetworkClient

+ (HealthyNetworkClient *)sharedInstance {
    static HealthyNetworkClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (NSURLSessionDataTask *)health_postApi:(NSString *)apiSuffix
                                  params:(id)params
                                 encrypt:(BOOL)encrypt
                                 success:(void (^)(HealthResponseModel *responseModel))success
                                 failure:(void (^)(NSError *error))failure
{
    //NSString *Url = [[LuckinNetworkEnvironment sharedInstance] completeUrlWithApiSuffix:apiSuffix];
    NSString *Url = API_BASE_Url_Health(@"login");
    return [self health_postUrl:Url params:params encrypt:encrypt success:success failure:failure];
}

- (NSURLSessionDataTask *)health_postUrl:(NSString *)Url
                                  params:(id)params
                                 encrypt:(BOOL)encrypt
                                 success:(void (^)(HealthResponseModel *responseModel))success
                                 failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [HealthyHTTPSessionManager sharedInstance];
    
    CJRequestSettingModel *settingModel = [[CJRequestSettingModel alloc] init];
    settingModel.logType = CJRequestLogTypeConsoleLog;
    
    NSURLSessionDataTask *URLSessionDataTask =
    [manager cj_postUrl:Url params:params settingModel:settingModel success:^(CJSuccessRequestInfo * _Nullable successRequestInfo) {
        NSDictionary *responseDictionary = successRequestInfo.responseObject;
        HealthResponseModel *responseModel = [[HealthResponseModel alloc] initWithResponseDictionary:responseDictionary];
        if (success) {
            success(responseModel);
        }
    
    } failure:^(CJFailureRequestInfo * _Nullable failureRequestInfo) {
        NSError *error = failureRequestInfo.error;
        //HealthResponseModel *responseModel = [[CJResponseModel alloc] init];
        //responseModel.status = -1;
        //responseModel.message = NSLocalizedString(@"网络请求失败", nil);
        //responseModel.result = nil;
        //responseModel.cjNetworkLog = error.userInfo[@"cjNetworkLog"];
        
        if (failure) {
            failure(error);
        }
    }];
    return URLSessionDataTask;
}


@end

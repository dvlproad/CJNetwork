//
//  HealthyNetworkClient.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "HealthyNetworkClient.h"
#import "HealthyHTTPSessionManager.h"

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
                                 failure:(nullable void (^)(NSString *errorMessage))failure
{
    //NSString *Url = [[TestNetworkEnvironmentManager sharedInstance] completeUrlWithApiSuffix:apiSuffix];
    NSString *Url = [[@"https://api.apiopen.top" stringByAppendingPathComponent:apiSuffix] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [self health_postUrl:Url params:params encrypt:encrypt success:success failure:failure];
}

- (NSURLSessionDataTask *)health_postUrl:(NSString *)Url
                                  params:(id)params
                                 encrypt:(BOOL)encrypt
                                 success:(void (^)(HealthResponseModel *responseModel))success
                                 failure:(nullable void (^)(NSString *errorMessage))failure
{
    AFHTTPSessionManager *manager = [HealthyHTTPSessionManager sharedInstance];
    
    CJRequestCacheSettingModel *cacheSettingModel = [[CJRequestCacheSettingModel alloc] init];
    CJRequestLogType logType = CJRequestLogTypeSuppendWindow;
    
    return [manager cj_postUrl:Url params:params cacheSettingModel:cacheSettingModel logType:logType progress:nil success:^(id  _Nullable responseObject) {
        NSDictionary *responseDictionary = responseObject;
        HealthResponseModel *responseModel = [[HealthResponseModel alloc] initWithResponseDictionary:responseDictionary];
        if (success) {
            success(responseModel);
        }
    
    } failure:^(NSString *errorMessage) {
        //HealthResponseModel *responseModel = [[CJResponseModel alloc] init];
        //responseModel.statusCode = -1;
        //responseModel.message = NSLocalizedString(@"网络请求失败", nil);
        //responseModel.result = nil;
        //responseModel.cjNetworkLog = error.userInfo[@"cjNetworkLog"];
        
        if (failure) {
            failure(errorMessage);
        }
    }];
}


@end

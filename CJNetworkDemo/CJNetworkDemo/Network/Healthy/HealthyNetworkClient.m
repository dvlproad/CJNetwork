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

- (nullable NSURLSessionDataTask *)health_postUrl:(nullable NSString *)Url
                                           params:(nullable id)params
                                    completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock
{
    AFHTTPSessionManager *manager = [HealthyHTTPSessionManager sharedInstance];
    
    NSURLSessionDataTask *URLSessionDataTask =
    [manager cj_postUrl:Url params:params shouldCache:NO progress:nil success:^(NSDictionary * _Nullable responseObject, BOOL isCacheData) {
        CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        responseModel.status = [responseObject[@"status"] integerValue];
        responseModel.message = responseObject[@"msg"];
        responseModel.result = responseObject[@"result"];
        if (completeBlock) {
            completeBlock(responseModel);
        }
        
    } failure:^(NSError * _Nullable error) {
        CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        responseModel.status = -1;
        responseModel.message = NSLocalizedString(@"网络请求失败", nil);
        responseModel.result = nil;
        if (completeBlock) {
            completeBlock(responseModel);
        }
    }];
    return URLSessionDataTask;
}

- (void)requestLogin_name:(NSString *)name
                     pasd:(NSString*)pasd
            completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock
{
    NSString *Url = API_BASE_Url_Health(@"login");
    NSDictionary *params = @{@"username" : name,
                             @"password" : pasd
                             };
    [self health_postUrl:Url params:params completeBlock:completeBlock];
    //    [self.indicatorView setAnimatingWithStateOfOperation:operation];
}


@end

//
//  TestNetworkClient+MethodEncrypt.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TestNetworkClient+MethodEncrypt.h"
#import "TestHTTPSessionManager.h"

@implementation TestNetworkClient (MethodEncrypt)

- (NSURLSessionDataTask *)testMethodEncrypt_postApi:(NSString *)apiSuffix
                                             params:(id)params
                                       settingModel:(CJRequestSettingModel *)settingModel
                                      completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock
{
    NSString *domain = @"https://localhost/simulateApi/CJDemoDataSimulationDemo";
    NSString *Url = [domain stringByAppendingString:apiSuffix];
    
    AFHTTPSessionManager *manager = [TestHTTPSessionManager sharedInstance];
    
    NSURLSessionDataTask *URLSessionDataTask =
    [manager cjMethodEncrypt_postUrl:Url params:params settingModel:settingModel encrypt:NO encryptBlock:nil decryptBlock:nil success:^(CJSuccessRequestInfo * _Nullable successRequestInfo) {
        NSDictionary *responseDictionary = successRequestInfo.responseObject;
        CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        responseModel.statusCode = [responseDictionary[@"status"] integerValue];
        responseModel.message = responseDictionary[@"message"];
        responseModel.result = responseDictionary[@"result"];
        responseModel.isCacheData = successRequestInfo.isCacheData;
        if (completeBlock) {
            completeBlock(responseModel);
        }
        
    } failure:^(CJFailureRequestInfo * _Nullable failureRequestInfo) {
        CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        responseModel.statusCode = -1;
        responseModel.message = NSLocalizedString(@"网络请求失败", nil);
        responseModel.result = nil;
        responseModel.isCacheData = NO;
        if (completeBlock) {
            completeBlock(responseModel);
        }
    }];
    return URLSessionDataTask;
}


@end

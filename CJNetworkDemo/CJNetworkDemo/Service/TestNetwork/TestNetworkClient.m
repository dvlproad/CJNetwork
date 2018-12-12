//
//  TestNetworkClient.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TestNetworkClient.h"
#import "TestHTTPSessionManager.h"
#import "TestEnvironmentManager.h"

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

- (instancetype)init {
    self = [super init];
    if (self) {
        AFHTTPSessionManager *cleanHTTPSessionManager = [TestHTTPSessionManager sharedInstance];
        TestHTTPSessionManager *cryptHTTPSessionManager = [TestHTTPSessionManager sharedInstance];
        [self setupCleanHTTPSessionManager:cleanHTTPSessionManager cryptHTTPSessionManager:cryptHTTPSessionManager];
        
        //TestEnvironmentManager *environmentManager = [TestEnvironmentManager sharedInstance];
        [self setupCompleteFullUrlBlock:^NSString *(NSString *apiSuffix) {
            NSString *baseUrl = @"http://xxx.xxx.xxx";
            NSString *mainUrl = [[baseUrl stringByAppendingString:apiSuffix] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            return mainUrl;
            //return [environmentManager completeUrlWithApiSuffix:apiSuffix];
        } completeAllParamsBlock:^NSDictionary *(NSDictionary *customParams) {
            NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:customParams];
            NSDictionary *commonParams = @{@"phone": @"iPhone6"};
            [allParams addEntriesFromDictionary:commonParams];
            return allParams;
            //return [environmentManager completeParamsWithCustomParams:customParams];
        }];
        
        [self setupResponseConvertBlock:^CJResponseModel *(id responseObject, BOOL isCacheData) {
            NSDictionary *responseDictionary = responseObject;
            //CJResponseModel *responseModel = [CJResponseModel mj_objectWithKeyValues:responseDictionary];
            //CJResponseModel *responseModel = [[CJResponseModel alloc] initWithResponseDictionary:responseDictionary isCacheData:isCacheData];
            CJResponseModel *responseModel = [[CJResponseModel alloc] init];
            responseModel.statusCode = [responseDictionary[@"status"] integerValue];
            responseModel.message = responseDictionary[@"message"];
            responseModel.result = responseDictionary[@"result"];
            responseModel.isCacheData = isCacheData;

            return responseModel;
            
        } checkIsCommonBlock:^BOOL(CJResponseModel *responseModel) {
            return NO;
            
        } getRequestFailureMessageBlock:^NSString *(NSError *error) {
            return @"网络错误";
        }];
        
        NSString *simulateDomain = @"http://localhost/CJDemoDataSimulationDemo";
        [self setupSimulateDomain:simulateDomain];
    }
    return self;
}

- (NSURLSessionDataTask *)testSimulate_postApi:(NSString *)apiSuffix
                                        params:(nullable id)params
                                  settingModel:(CJRequestSettingModel *)settingModel
                                       success:(void (^)(CJResponseModel *responseModel))success
                                       failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self simulate2_postApi:apiSuffix params:params settingModel:settingModel success:success failure:failure];
}

- (NSURLSessionDataTask *)testLocal_postApi:(NSString *)apiSuffix
                                     params:(id)params
                               settingModel:(CJRequestSettingModel *)settingModel
                                    success:(void (^)(CJResponseModel *responseModel))success
                                    failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    return [self local2_postApi:apiSuffix params:params settingModel:settingModel success:success failure:failure];
}

@end

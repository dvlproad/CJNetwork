//
//  TestNetworkClient.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TestNetworkClient.h"
#import "TestHTTPSessionManager.h"
//#import "TestNetworkEnvironmentManager.h"

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
        AFHTTPSessionManager *cryptHTTPSessionManager = [TestHTTPSessionManager sharedInstance];
        [self setupCleanHTTPSessionManager:cleanHTTPSessionManager cryptHTTPSessionManager:cryptHTTPSessionManager];
        
        //TestNetworkEnvironmentManager *environmentManager = [TestNetworkEnvironmentManager sharedInstance];
        [self setupCompleteFullUrlBlock:^NSString *(NSString *apiSuffix) {
            NSMutableString *fullUrl = [NSMutableString string];
            [fullUrl appendFormat:@"%@", self.baseUrl];
            if (![self.baseUrl hasSuffix:@"/"]) {
                [fullUrl appendFormat:@"/"];
            }
            [fullUrl appendFormat:@"%@", apiSuffix];
            return [fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //return [environmentManager completeUrlWithApiSuffix:apiSuffix];
        } completeAllParamsBlock:^NSDictionary *(NSDictionary *customParams) {
            NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:customParams];
            [allParams addEntriesFromDictionary:self.commonParams];
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

@end

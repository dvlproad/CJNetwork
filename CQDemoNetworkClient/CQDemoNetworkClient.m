//
//  CQDemoNetworkClient.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/8/1.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CQDemoNetworkClient.h"
#import "CQDemoCleanHTTPSessionManager.h"

@implementation CQDemoNetworkClient

+ (CQDemoNetworkClient *)sharedInstance {
    static CQDemoNetworkClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        AFHTTPSessionManager *cleanHTTPSessionManager = [CQDemoCleanHTTPSessionManager sharedInstance];
        AFHTTPSessionManager *cryptHTTPSessionManager = nil;
        [self setupCleanHTTPSessionManager:cleanHTTPSessionManager cryptHTTPSessionManager:cryptHTTPSessionManager];
        
        [self setupGetSuccessResponseModelBlock:^CJResponseModel * _Nullable(CJSuccessRequestInfo * _Nonnull successRequestInfo) {
            id responseObject = successRequestInfo.responseObject;
            BOOL isCacheData = successRequestInfo.isCacheData;
                
            NSDictionary *responseDictionary = responseObject;
            //CJResponseModel *responseModel = [CJResponseModel mj_objectWithKeyValues:responseDictionary];
            //CJResponseModel *responseModel = [[CJResponseModel alloc] initWithResponseDictionary:responseDictionary isCacheData:isCacheData];
            CJResponseModel *responseModel = [[CJResponseModel alloc] init];
            responseModel.statusCode = [responseDictionary[@"status"] integerValue];
            responseModel.message = responseDictionary[@"message"];
            responseModel.result = responseDictionary[@"result"];
            responseModel.isCacheData = isCacheData;
            
            return responseModel;
            
        } checkIsCommonFailureBlock:^BOOL(CJResponseModel *responseModel) {
           // 检查是否是共同错误并在此对共同错误做处理，如statusCode == -5 为异地登录(可为ni,非nil时一般返回值为NO)
            if (responseModel.statusCode == 5) { //执行退出登录
                //[CJToast shortShowMessage:@"账号异地登录"];
                //[[CJDemoUserManager sharedInstance] logout:YES completed:nil];
                return YES;
            } else {
                return NO;
            }
            
        } getFailureResponseModelBlock:^CJResponseModel * _Nullable(CJFailureRequestInfo * _Nonnull failureRequestInfo) {
            NSError *error = failureRequestInfo.error;
            NSString *errorMessage = failureRequestInfo.errorMessage;
            
            if (errorMessage == nil || errorMessage.length == 0) {
                errorMessage = NSLocalizedString(@"网络链接失败，请检查您的网络链接", nil);
            }
            CJResponseModel *responseModel = [[CJResponseModel alloc] init];
            responseModel.statusCode = -1;
            responseModel.message = errorMessage;
            responseModel.result = nil;
            
            return responseModel;
        }];
        
        self.baseUrl = @"";
        self.commonParams = [NSMutableDictionary dictionaryWithDictionary:@{}];
        self.simulateDomain = @"http://localhost/CJDemoDataSimulationDemo";
    }
    return self;
}


@end

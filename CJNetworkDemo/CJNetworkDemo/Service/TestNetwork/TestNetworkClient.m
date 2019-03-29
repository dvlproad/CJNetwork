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

- (instancetype)init {
    self = [super init];
    if (self) {
        AFHTTPSessionManager *cleanHTTPSessionManager = [TestHTTPSessionManager sharedInstance];
        AFHTTPSessionManager *cryptHTTPSessionManager = [TestHTTPSessionManager sharedInstance];
        [self setupCleanHTTPSessionManager:cleanHTTPSessionManager cryptHTTPSessionManager:cryptHTTPSessionManager];
        
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
            
        } checkIsCommonFailureBlock:^BOOL(CJResponseModel *responseModel) {
            // 检查是否是共同错误并在此对共同错误做处理，如statusCode == -5 为异地登录(可为ni,非nil时一般返回值为NO)
            if (responseModel.statusCode == 5) { //执行退出登录
                //[CJToast shortShowMessage:@"账号异地登录"];
                //[[CJDemoUserManager sharedInstance] logout:YES completed:nil];
                return YES;
            } else {
                return NO;
            }
            
        } getRequestFailureMessageBlock:^NSString *(NSError *error) {
            //可选实现：获取"请求失败的回调"的错误信息
            return NSLocalizedString(@"网络链接失败，请检查您的网络链接", nil);
        }];
        
        self.simulateDomain = @"http://localhost/CJDemoDataSimulationDemo";
    }
    return self;
}

@end

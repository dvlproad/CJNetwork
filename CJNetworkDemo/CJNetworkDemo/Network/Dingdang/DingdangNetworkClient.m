//
//  DingdangNetworkClient.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.//

#import "DingdangNetworkClient.h"
#import "DingdangHTTPSessionManager.h"


#define CLIENT @"app"
#define PLATCODE @"IOS"
#define CLIENT_SECRET @"f50aa247a3e56eb5ee744a983e2ff9d5"

@implementation DingdangNetworkClient

+ (DingdangNetworkClient *)sharedInstance {
    static DingdangNetworkClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (nullable NSURLSessionDataTask *)dd_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                                        cache:(BOOL)cache
                                      completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock
{
    AFHTTPSessionManager *manager = [DingdangHTTPSessionManager sharedInstance];
    
    //注：如果网络一直判断失败，请检查之前是否从不曾调用过[[CJNetworkMonitor sharedInstance] startNetworkMonitoring];如是，请提前调用至少一次即可
    BOOL isNetworkEnabled = [CJNetworkMonitor sharedInstance].networkSuccess;
    
    NSURLSessionDataTask *URLSessionDataTask =
    [manager cj_postUrl:Url params:params currentNetworkStatus:isNetworkEnabled cache:cache success:^(NSDictionary * _Nullable responseObject, BOOL isCacheData) {
        CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        responseModel.status = [responseObject[@"status"] integerValue];
        responseModel.message = responseObject[@"message"];
        responseModel.result = responseObject[@"result"];
        responseModel.isCacheData = isCacheData;
        if (completeBlock) {
            completeBlock(responseModel);
        }
        
    } failure:^(NSError * _Nullable error) {
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

#pragma mark AUTH:认证接口
/****************
 *   第三方登录时:
 *   用户名：第三方的openid
 *   password：md5(yyMMdd+用户名倒序+26%trUst#9527)
 *       其中：yyMMdd从服务端接口【/api/systime】获取
 ****************/
- (void)requestDDLogin_name:(NSString *)name
                       pasd:(NSString*)pasd
              completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock
{
    //当前API参考：http://dingdang.baseoa.com:8080/api.html#access-token
    NSString *Url = API_BASE_Url_dingdang(@"oauth/token");
    NSDictionary *params = @{@"username" : name, //测试:name:13055284289 pasd:123456
                             @"password" : pasd,
                             @"grant_type"    : @"password",
                             @"client_id"     : CLIENT,
                             @"client_secret" : CLIENT_SECRET
                             };
    [self dd_postUrl:Url params:params cache:NO completeBlock:^(CJResponseModel *responseModel) {
        if (responseModel.status == 0) {
            NSDictionary *responseResult = responseModel.result;
            
            LoginShareInfo *shareInfo = [LoginShareInfo shared];
            shareInfo.access_token = [responseResult objectForKey:@"access_token"];
            shareInfo.expires_in = [responseResult objectForKey:@"expires_in"];
            shareInfo.refresh_token = [responseResult objectForKey:@"refresh_token"];
            shareInfo.scope = [responseResult objectForKey:@"scope"];
            shareInfo.token_type = [responseResult objectForKey:@"token_type"];
        }
        
        if (completeBlock) {
            completeBlock(responseModel);
        }
    }];
}

- (void)requestDDLogout_completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock
{
    NSString *Url = API_BASE_Url_dingdang(@"api/logout");
    NSDictionary *params = @{
                             @"access_token": [LoginShareInfo shared].access_token
                             };
    
    [self dd_postUrl:Url params:params cache:NO completeBlock:completeBlock];
}

- (void)requestDDUser_GetInfo_completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock
{
    NSString *Url = API_BASE_Url_dingdang(@"api/user/me");
    NSDictionary *params = @{@"access_token": [LoginShareInfo shared].access_token};
    
    [self dd_postUrl:Url params:params cache:NO completeBlock:completeBlock];
}


//获取我的科目列表
- (void)requestDDCourse_Get_completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock
{
    NSString *Url = API_BASE_Url_dingdang(@"api/course/list");
    if ([LoginShareInfo shared].access_token == nil) {
        NSLog(@"access_token = nil");
        return;
    }
    
    NSDictionary *params = @{@"access_token": [LoginShareInfo shared].access_token,
                             @"type"        : @(0)};    //发布类型，0-大家帮 1-加密题
    
    
    [self dd_postUrl:Url params:params cache:YES completeBlock:completeBlock];
}


@end

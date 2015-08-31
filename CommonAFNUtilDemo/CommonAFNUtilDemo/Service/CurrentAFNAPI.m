//
//  CurrentAFNAPI.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/1/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CurrentAFNAPI.h"

#define CLIENT @"app"
#define PLATCODE @"IOS"
#define CLIENT_SECRET @"f50aa247a3e56eb5ee744a983e2ff9d5"

@implementation CurrentAFNAPI



#pragma mark AUTH:认证接口
/****************
 *   第三方登录时:
 *   用户名：第三方的openid
 *   password：md5(yyMMdd+用户名倒序+26%trUst#9527)
 *       其中：yyMMdd从服务端接口【/api/systime】获取
 ****************/
+ (void)requestLogin_name:(NSString *)name
                     pasd:(NSString*)pasd
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    //当前API参考：http://dingdang.baseoa.com:8080/api.html#access-token
    NSString *Url = API_BASE_Url_dingdang(@"oauth/token");
    NSDictionary *params = @{@"username" : name, //测试:name:13055284289 pasd:123456
                             @"password" : pasd,
                             @"grant_type"    : @"password",
                             @"client_id"     : CLIENT,
                             @"client_secret" : CLIENT_SECRET
                             };
    AFHTTPRequestOperationManager *manager = [CurrentAFNManager manager_dingdang];
    [[CommonAFNInstance shareCommonAFNInstance] useManager_b:manager postRequestUrl:Url params:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        LoginShareInfo *shareInfo = [LoginShareInfo shared];
        shareInfo.access_token = [responseObject objectForKey:@"access_token"];
        shareInfo.expires_in = [responseObject objectForKey:@"expires_in"];
        shareInfo.refresh_token = [responseObject objectForKey:@"refresh_token"];
        shareInfo.scope = [responseObject objectForKey:@"scope"];
        shareInfo.token_type = [responseObject objectForKey:@"token_type"];
        
        success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取失败");
        failure(operation, error);
    }];
}

+ (void)requestLogout_success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *Url = API_BASE_Url_dingdang(@"api/logout");
    NSDictionary *params = @{@"access_token": [LoginShareInfo shared].access_token};
    
    AFHTTPRequestOperationManager *manager = [CurrentAFNManager manager_dingdang];
    [[CommonAFNInstance shareCommonAFNInstance] useManager_b:manager postRequestUrl:Url params:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
}

+ (void)requestUser_GetInfo_success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *Url = API_BASE_Url_dingdang(@"api/user/me");
    NSDictionary *params = @{@"access_token": [LoginShareInfo shared].access_token};
    /*
    [[CommonAFNAPI shareCommonAFNAPI] postRequestUrl:Url params:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    */
    
    AFHTTPRequestOperationManager *manager = [CurrentAFNManager manager_dingdang];
    [[CommonAFNInstance shareCommonAFNInstance] useManager_b:manager postRequestUrl:Url params:params useCache:NO success:^(AFHTTPRequestOperation *operation, id responseObject, BOOL isCacheData) {
        if (isCacheData) {
            success(nil, responseObject);
        }else{
            success(operation, responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL isCacheData) {
        if (isCacheData) {
            failure(nil, nil);
        }else{
            failure(operation, error);
        }
    }];
}


//获取我的科目列表
+ (void)requestCourse_Get_success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *Url = API_BASE_Url_dingdang(@"api/course/list");
    NSDictionary *params = @{@"access_token": [LoginShareInfo shared].access_token,
                             @"type"        : @(0)};    //发布类型，0-大家帮 1-加密题
    
    
    AFHTTPRequestOperationManager *manager = [CurrentAFNManager manager_dingdang];
    [[CommonAFNInstance shareCommonAFNInstance] useManager_b:manager postRequestUrl:Url params:params useCache:YES success:^(AFHTTPRequestOperation *operation, id responseObject, BOOL isCacheData) {
        if (isCacheData) {
            success(nil, responseObject);
        }else{
            success(operation, responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL isCacheData) {
        if (isCacheData) {
            failure(nil, nil);
        }else{
            failure(operation, error);
        }
        
    }];
}


@end

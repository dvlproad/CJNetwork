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


+ (void)requestLogin_name:(NSString *)name
                     pasd:(NSString*)pasd
                  success:(CJRequestSuccess)success
                  failure:(CJRequestFailure)failure
{
    NSString *Url = API_BASE_Url(@"login");
    NSDictionary *params = @{@"username" : name,
                             @"password" : pasd
                             };
    AFHTTPSessionManager *manager = [CurrentAFNManager manager_health];
    [[CommonAFNInstance shareCommonAFNInstance] useManager:manager postRequestUrl:Url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取失败");
        failure(task, error);
    }];
//    [self.indicatorView setAnimatingWithStateOfOperation:operation];
}

#pragma mark AUTH:认证接口
/****************
 *   第三方登录时:
 *   用户名：第三方的openid
 *   password：md5(yyMMdd+用户名倒序+26%trUst#9527)
 *       其中：yyMMdd从服务端接口【/api/systime】获取
 ****************/
+ (void)requestDDLogin_name:(NSString *)name
                     pasd:(NSString*)pasd
                  success:(CJRequestSuccess)success
                    failure:(CJRequestFailure)failure
{
    //当前API参考：http://dingdang.baseoa.com:8080/api.html#access-token
    NSString *Url = API_BASE_Url_dingdang(@"oauth/token");
    NSDictionary *params = @{@"username" : name, //测试:name:13055284289 pasd:123456
                             @"password" : pasd,
                             @"grant_type"    : @"password",
                             @"client_id"     : CLIENT,
                             @"client_secret" : CLIENT_SECRET
                             };
    AFHTTPSessionManager *manager = [CurrentAFNManager manager_dingdang];
    [[CommonAFNInstance shareCommonAFNInstance] useManager:manager postRequestUrl:Url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        LoginShareInfo *shareInfo = [LoginShareInfo shared];
        shareInfo.access_token = [responseObject objectForKey:@"access_token"];
        shareInfo.expires_in = [responseObject objectForKey:@"expires_in"];
        shareInfo.refresh_token = [responseObject objectForKey:@"refresh_token"];
        shareInfo.scope = [responseObject objectForKey:@"scope"];
        shareInfo.token_type = [responseObject objectForKey:@"token_type"];
        
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取失败");
        failure(task, error);
    }];
}

+ (void)requestDDLogout_success:(CJRequestSuccess)success failure:(CJRequestFailure)failure
{
    NSString *Url = API_BASE_Url_dingdang(@"api/logout");
    NSDictionary *params = @{@"access_token": [LoginShareInfo shared].access_token};
    
    AFHTTPSessionManager *manager = [CurrentAFNManager manager_dingdang];
    [[CommonAFNInstance shareCommonAFNInstance] useManager:manager postRequestUrl:Url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取失败");
        failure(task, error);
    }];
    
}

+ (void)requestDDUser_GetInfo_success:(CJRequestSuccess)success failure:(CJRequestFailure)failure
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
    
    AFHTTPSessionManager *manager = [CurrentAFNManager manager_dingdang];
    [[CommonAFNInstance shareCommonAFNInstance] useManager:manager postRequestUrl:Url parameters:params cacheReuqestData:NO progress:nil success:^(NSURLSessionDataTask *task, id responseObject, BOOL isCacheData) {
        
        if (isCacheData) {
            if (success) {
                success(nil, responseObject);
            }
            
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error, BOOL isCacheData) {
        if (isCacheData) {
            if (failure) {
                failure(nil, nil);
            }
            
        } else {
            if (failure) {
                failure(task, error);
            }
        }
    }];
}


//获取我的科目列表
+ (void)requestDDCourse_Get_success:(CJRequestSuccess)success failure:(CJRequestFailure)failure
{
    NSString *Url = API_BASE_Url_dingdang(@"api/course/list");
    if ([LoginShareInfo shared].access_token == nil) {
        NSLog(@"access_token = nil");
        return;
    }
    
    NSDictionary *params = @{@"access_token": [LoginShareInfo shared].access_token,
                             @"type"        : @(0)};    //发布类型，0-大家帮 1-加密题
    
    
    AFHTTPSessionManager *manager = [CurrentAFNManager manager_dingdang];
    [[CommonAFNInstance shareCommonAFNInstance] useManager:manager postRequestUrl:Url parameters:params cacheReuqestData:YES progress:nil success:^(NSURLSessionDataTask *task, id responseObject, BOOL isCacheData) {
        
        if (isCacheData) {
            if (success) {
                success(nil, responseObject);
            }
            
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error, BOOL isCacheData) {
        if (isCacheData) {
            if (failure) {
                failure(nil, nil);
            }
            
        } else {
            if (failure) {
                failure(task, error);
            }
        }
    }];
}


@end

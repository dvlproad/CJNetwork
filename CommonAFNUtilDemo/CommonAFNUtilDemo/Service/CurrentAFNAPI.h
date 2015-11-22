//
//  CurrentAFNAPI.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/1/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonAFNInstance.h"
#import "CurrentAFNManager.h"
#import "LoginHelper.h"
#import "LoginShareInfo.h"

@class AFHTTPRequestOperation;
@interface CurrentAFNAPI : NSObject

//健康软件中的API
+ (void)requestLogin_name:(NSString *)name
                     pasd:(NSString*)pasd
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSString *failMesg))failure;

//叮当中的API
+ (void)requestDDLogin_name:(NSString *)name
                     pasd:(NSString*)pasd
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSString *failMesg))failure;

+ (void)requestDDLogout_success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSString *failMesg))failure;

+ (void)requestDDUser_GetInfo_success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSString *failMesg))failure;

//叮当中的API_获取我的科目列表
+ (void)requestDDCourse_Get_success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSString *failMesg))failure;

@end

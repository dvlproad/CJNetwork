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

+ (void)requestLogin_name:(NSString *)name
                     pasd:(NSString*)pasd
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)requestLogout_success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)requestUser_GetInfo_success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//获取我的科目列表
+ (void)requestCourse_Get_success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end

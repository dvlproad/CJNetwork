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
                  success:(CJRequestSuccess)success
                  failure:(CJRequestFailure)failure;

//叮当中的API
+ (void)requestDDLogin_name:(NSString *)name
                       pasd:(NSString*)pasd
                    success:(CJRequestSuccess)success
                    failure:(CJRequestFailure)failure;

+ (void)requestDDLogout_success:(CJRequestSuccess)success
                        failure:(CJRequestFailure)failure;

+ (void)requestDDUser_GetInfo_success:(CJRequestSuccess)success
                              failure:(CJRequestFailure)failure;

//叮当中的API_获取我的科目列表
+ (void)requestDDCourse_Get_success:(CJRequestSuccess)success
                            failure:(CJRequestFailure)failure;

//ijinbu
+ (void)requestijinbuLogin_name:(NSString *)name
                           pasd:(NSString*)pasd
                        success:(CJRequestSuccess)success
                        failure:(CJRequestFailure)failure;

@end

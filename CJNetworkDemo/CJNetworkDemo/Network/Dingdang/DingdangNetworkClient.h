//
//  DingdangNetworkClient.h
//  CJNetworkDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager+CJCacheRequest.h"

#import "LoginHelper.h"
#import "LoginShareInfo.h"

@interface DingdangNetworkClient : NSObject

+ (DingdangNetworkClient *)sharedInstance;

//叮当中的API
- (void)requestDDLogin_name:(NSString *)name
                       pasd:(NSString*)pasd
                    success:(AFRequestSuccess)success
                    failure:(AFRequestFailure)failure;

- (void)requestDDLogout_success:(AFRequestSuccess)success
                        failure:(AFRequestFailure)failure;

- (void)requestDDUser_GetInfo_success:(AFRequestSuccess)success
                              failure:(AFRequestFailure)failure;

//叮当中的API_获取我的科目列表
- (void)requestDDCourse_Get_success:(AFRequestSuccess)success
                            failure:(AFRequestFailure)failure;

@end

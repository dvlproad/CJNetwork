//
//  CJNetworkClient+Dingdang.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "CJNetworkClient.h"
#import "DingdangHTTPSessionManager.h"

#import "LoginHelper.h"
#import "LoginShareInfo.h"

@interface CJNetworkClient (Dingdang)

//叮当中的API
- (void)requestDDLogin_name:(NSString *)name
                       pasd:(NSString*)pasd
                    success:(CJRequestSuccess)success
                    failure:(CJRequestFailure)failure;

- (void)requestDDLogout_success:(CJRequestSuccess)success
                        failure:(CJRequestFailure)failure;

- (void)requestDDUser_GetInfo_success:(CJRequestSuccess)success
                              failure:(CJRequestFailure)failure;

//叮当中的API_获取我的科目列表
- (void)requestDDCourse_Get_success:(CJRequestSuccess)success
                            failure:(CJRequestFailure)failure;

@end

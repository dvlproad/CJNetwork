//
//  DingdangNetworkClient.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager+CJCacheRequest.h"

#import "LoginHelper.h"
#import "LoginShareInfo.h"

#import "CJResponseModel.h"

#import "CJNetworkMonitor.h"

@interface DingdangNetworkClient : NSObject

+ (DingdangNetworkClient *)sharedInstance;

//叮当中的API
- (void)requestDDLogin_name:(NSString *)name
                       pasd:(NSString*)pasd
              completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock;

- (void)requestDDLogout_completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock;

- (void)requestDDUser_GetInfo_completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock;

//叮当中的API_获取我的科目列表
- (void)requestDDCourse_Get_completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock;

@end

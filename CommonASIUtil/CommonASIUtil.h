//
//  CommonASIUtil.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceASIDelegate.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <ASIHTTPRequest.h>

typedef enum _ASIRequestType{
    ASIRequestType_GET = 0,
    ASIRequestType_POST,
    ASIRequestType_PUT
}ASIRequestType;

@interface CommonASIUtil : NSObject


#pragma mark - CommonUtil
+ (void)request:(ASIHTTPRequest *)request delegate:(id<WebServiceASIDelegate>)delegate userInfo:(NSDictionary *)userInfo;

+ (ASIHTTPRequest *)request_URL:(NSURL *)URL params:(NSDictionary *)params method:(ASIRequestType)requestType;

+ (void)checkVersionWithAPPID:(NSString *)appid success:(void(^)(BOOL isLastest, NSString *app_trackViewUrl))success failure:(void(^)(void))failure;

@end

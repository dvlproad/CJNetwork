//
//  AFNUtilCheck.h
//  CommonAFNUtilDemo
//
//  Created by 李超前 on 15/11/22.
//  Copyright © 2015年 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface AFNUtilCheck : NSObject

+ (void)checkVersionWithAPPID:(NSString *)appid success:(void(^)(BOOL isLastest, NSString *app_trackViewUrl))success failure:(void(^)(void))failure;

@end

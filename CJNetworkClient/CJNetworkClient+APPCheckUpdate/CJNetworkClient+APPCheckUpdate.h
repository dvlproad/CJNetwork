//
//  CJNetworkClient+APPCheckUpdate.h
//  CommonAFNUtilDemo
//
//  Created by 李超前 on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "CJNetworkClient.h"

//typedef void(^CJRequestAppCheckUpdateSuccess)(NSURLSessionDataTask *task, id responseObject);
//typedef void(^CJRequestAppCheckUpdateFailure)(NSURLSessionDataTask *task, NSString *errorMessage);

@interface CJNetworkClient (APPCheckUpdate)

- (NSURLSessionDataTask *)checkVersionWithAPPID:(NSString *)appid
                                        success:(void(^)(BOOL isLastest, NSString *app_trackViewUrl))success
                                        failure:(void(^)(void))failure;


@end

//
//  CJNetworkClient.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager+CJCategory.h"

@interface CJNetworkClient : NSObject

+ (CJNetworkClient *)sharedInstance;

- (NSURLSessionDataTask *)checkVersionWithAPPID:(NSString *)appid
                                        success:(void(^)(BOOL isLastest, NSString *app_trackViewUrl))success
                                        failure:(void(^)(void))failure;

@end

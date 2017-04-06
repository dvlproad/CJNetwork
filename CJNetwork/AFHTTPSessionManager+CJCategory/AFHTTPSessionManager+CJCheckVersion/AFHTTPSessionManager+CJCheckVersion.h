//
//  AFHTTPSessionManager+CJCheckVersion.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFHTTPSessionManager (CJCheckVersion)

- (NSURLSessionDataTask *)checkVersionWithAPPID:(NSString *)appid
                                        success:(void(^)(BOOL isLastest, NSString *app_trackViewUrl))success
                                        failure:(void(^)(void))failure;

@end

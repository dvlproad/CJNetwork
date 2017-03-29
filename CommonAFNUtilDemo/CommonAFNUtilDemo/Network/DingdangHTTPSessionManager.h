//
//  DingdangHTTPSessionManager.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

//API路径--dingdang
#define API_BASE_Url_dingdang(_Url_) [[@"http://dingdang.baseoa.com:8080/" stringByAppendingString:_Url_] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]

@interface DingdangHTTPSessionManager : AFHTTPSessionManager

+ (AFHTTPSessionManager *)sharedInstance;

@end

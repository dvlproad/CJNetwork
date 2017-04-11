//
//  HealthyHTTPSessionManager.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

//API路径--health
#define API_BASE_Url_Health(_Url_) [[@"http://121.40.82.169/drupal/api/" stringByAppendingString:_Url_] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]

@interface HealthyHTTPSessionManager : AFHTTPSessionManager

+ (AFHTTPSessionManager *)sharedInstance;

@end

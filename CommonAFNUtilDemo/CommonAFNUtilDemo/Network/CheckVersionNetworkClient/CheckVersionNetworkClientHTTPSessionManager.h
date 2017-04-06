//
//  CheckVersionNetworkClientHTTPSessionManager.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AFHTTPSessionManager+CJCheckVersion.h"

@interface CheckVersionNetworkClientHTTPSessionManager : AFHTTPSessionManager

+ (AFHTTPSessionManager *)sharedInstance;

@end

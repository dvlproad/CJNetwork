//
//  CQDemoCleanHTTPSessionManager.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface CQDemoCleanHTTPSessionManager : AFHTTPSessionManager

+ (AFHTTPSessionManager *)sharedInstance;

@end

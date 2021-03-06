//
//  TSCleanHTTPSessionManager.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TSCleanHTTPSessionManager.h"

@implementation TSCleanHTTPSessionManager

+ (TSCleanHTTPSessionManager *)sharedInstance {
    static TSCleanHTTPSessionManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self createSessionManager];
    });
    return _sharedInstance;
}

+ (TSCleanHTTPSessionManager *)createSessionManager
{
    TSCleanHTTPSessionManager *manager = [TSCleanHTTPSessionManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer  = requestSerializer;
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                 @"text/plain",
                                                 @"text/html",
                                                 @"application/json",
                                                 @"application/json;charset=utf-8", nil];
    manager.responseSerializer = responseSerializer;
    
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    return manager;
}

@end

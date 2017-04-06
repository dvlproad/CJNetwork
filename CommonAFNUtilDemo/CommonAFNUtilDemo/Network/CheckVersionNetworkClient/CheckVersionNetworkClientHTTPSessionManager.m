//
//  CheckVersionNetworkClientHTTPSessionManager.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "CheckVersionNetworkClientHTTPSessionManager.h"

@implementation CheckVersionNetworkClientHTTPSessionManager

+ (AFHTTPSessionManager *)sharedInstance {
    static AFHTTPSessionManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self createSessionManager];
    });
    return _sharedInstance;
}

+ (AFHTTPSessionManager *)createSessionManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    return manager;
}

@end

//
//  CQDemoHTTPSessionManager.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CQDemoHTTPSessionManager.h"
#import "AFHTTPSessionManager+CQDemo.h"

@implementation CQDemoHTTPSessionManager

+ (CQDemoHTTPSessionManager *)sharedInstance {
    static CQDemoHTTPSessionManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self cqdemoManager];
    });
    return _sharedInstance;
}

@end

//
//  DingdangHTTPSessionManager.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "DingdangHTTPSessionManager.h"

@implementation DingdangHTTPSessionManager

+ (AFHTTPSessionManager *)sharedInstance {
    static AFHTTPSessionManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self createSessionManager];
    });
    return _sharedInstance;
}

+ (AFHTTPSessionManager *)createSessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //-->叮当
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableSet * muSet = [[NSMutableSet alloc]initWithSet:manager.responseSerializer.acceptableContentTypes];
    [muSet addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = muSet;
    //<--叮当
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    return manager;
}

@end

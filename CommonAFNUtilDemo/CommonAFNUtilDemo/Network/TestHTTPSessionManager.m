//
//  TestHTTPSessionManager.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "TestHTTPSessionManager.h"

@implementation TestHTTPSessionManager

+ (AFHTTPSessionManager *)sharedInstance {
    static AFHTTPSessionManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self createSessionManager];
    });
    return _sharedInstance;
}

//CJNetworkManager
+ (AFHTTPSessionManager *)createSessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //-->看房
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSMutableSet * muSet = [[NSMutableSet alloc]initWithSet:manager.responseSerializer.acceptableContentTypes];
    [muSet addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = muSet;
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;//charset=utf-8
    //<--看房
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    return manager;
}

@end

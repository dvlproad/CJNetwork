//
//  CurrentAFNManager.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/6/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CurrentAFNManager.h"

@implementation CurrentAFNManager

#pragma mark - magager定义
+ (AFHTTPSessionManager *)manager_health
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //-->晚餐
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //<--晚餐
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    return manager;
}

+ (AFHTTPSessionManager *)manager_dingdang
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

//CJNetworkManager
+ (AFHTTPSessionManager *)manager_lookhouse
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

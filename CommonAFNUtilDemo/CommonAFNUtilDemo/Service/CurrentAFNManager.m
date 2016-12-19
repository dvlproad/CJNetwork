//
//  CurrentAFNManager.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/6/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CurrentAFNManager.h"
#import <OpenUDID/OpenUDID.h>
#import "CJJSONResponseSerializer.h"

static NSString *const HPServerAPIVer = @"2.5.1207";
NSString * ijinbuBaseUrl = @"http://www.ijinbu.com";

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
    
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.app.net/"]];
//    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
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

+ (AFHTTPSessionManager *)manager_ijinbu {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //-->ijinbu
    NSString *deviceId = [OpenUDID value];
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:deviceId forHTTPHeaderField:@"imei"];
    [requestSerializer setValue:@"1" forHTTPHeaderField:@"clientType"];
    [requestSerializer setValue:@"2" forHTTPHeaderField:@"appType"];
    //NSString *ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey];
    [requestSerializer setValue:HPServerAPIVer forHTTPHeaderField:@"ver"];
    [requestSerializer setValue:[[NSString stringWithFormat:@"%@123456", deviceId] MD5] forHTTPHeaderField:@"sign"];
    [requestSerializer setValue:[NSBundle mainBundle].bundleIdentifier forHTTPHeaderField:@"bundleId"];
    manager.requestSerializer  = requestSerializer;
    
    CJJSONResponseSerializer *responseSerializer = [CJJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         @"application/json",
                                                         @"application/json;charset=utf-8", nil];
    manager.responseSerializer = responseSerializer;
    
    return manager;
}


@end

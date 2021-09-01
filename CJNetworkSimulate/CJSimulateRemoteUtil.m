//
//  CJSimulateRemoteUtil.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 15/11/22.
//  Copyright © 2015年 dvlproad. All rights reserved.
//

#import "CJSimulateRemoteUtil.h"

@implementation CJSimulateRemoteUtil

#pragma mark - GET请求
/*
 *  发起GET请求
 *
 *  @param Url          Url
 *  @param params       params
 *  @param success      请求成功的回调failure
 *  @param failure      请求失败的回调failure(error已判断为非空)
 */
+ (NSURLSessionDataTask *)getUrl:(NSString *)Url
                          params:(nullable id)params
                         success:(nullable void (^)(NSDictionary *responseDictionary))success
                         failure:(nullable void (^)(NSError * _Nonnull error, NSString * _Nullable errorMessage))failure
{
    NSString *fullUrlForGet = [self connectRequestUrl:Url params:params];
    NSURL *URL = [NSURL URLWithString:fullUrlForGet];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"]; //此行可省略，因为默认就是GET方法，附Get方法没有body
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSError *jsonError = nil;
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            !success ?: success(responseObject);
            
        } else {
            NSString *message = [self getErrorMessageFromURLResponse:response];
            !failure ?: failure(error, message);
        }
    }];
    [task resume];
    
    return task;
}


#pragma mark - POST请求
/*
 *  发起POST请求
 *
 *  @param Url          Url
 *  @param params       params
 *  @param success      请求成功的回调failure
 *  @param failure      请求失败的回调failure(error已判断为非空)
 *
 *  @return 请求的task
 */
+ (NSURLSessionDataTask *)postUrl:(NSString *)Url
                           params:(nullable id)params
                          success:(nullable void (^)(NSDictionary *responseDictionary))success
                          failure:(nullable void (^)(NSError * _Nonnull error, NSString * _Nullable errorMessage))failure
{
    /* 利用Url和params，通过加密的方法创建请求 */
    NSData *bodyData = nil;
    bodyData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    
    NSURL *URL = [NSURL URLWithString:Url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPBody:bodyData];
    [request setHTTPMethod:@"POST"];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *URLSessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSError *jsonError = nil;
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            !success ?: success(responseObject);
            
        } else {
            NSString *message = [self getErrorMessageFromURLResponse:response];
            !failure ?: failure(error, message);
        }
    }];
    [URLSessionDataTask resume];
    
    return URLSessionDataTask;
}



/**
 *  连接请求的地址与参数，返回连接后所形成的字符串
 *
 *  @param requestUrl       请求的地址
 *  @param requestParams    请求的参数
 *
 *  @return 连接后所形成的字符串
 */
+ (NSString *)connectRequestUrl:(NSString *)requestUrl params:(NSDictionary *)requestParams {
    if (requestParams == nil) {
        return requestUrl;
    }
    
    //获取GET方法的参数组成的字符串requestParmasString
    NSMutableString *requestParmasString = [NSMutableString new];
    for (NSString *key in [requestParams allKeys]) {
        id obj = [requestParams valueForKey:key];
        if ([obj isKindOfClass:[NSString class]]) { //NSString
            if (requestParmasString.length != 0) {
                [requestParmasString appendString:@"&"];
            } else {
                [requestParmasString appendString:@"?"];
            }
            
            NSString *keyValueString = obj;
            [requestParmasString appendFormat:@"%@=%@", key, keyValueString];
            
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            if (requestParmasString.length != 0) {
                [requestParmasString appendString:@"&"];
            } else {
                [requestParmasString appendString:@"?"];
            }
            
            NSString *keyValueString = [obj stringValue];
            [requestParmasString appendFormat:@"%@=%@", key, keyValueString];
            
        } else if ([obj isKindOfClass:[NSArray class]]) { //NSArray
            for (NSString *value in obj) {
                if (requestParmasString.length != 0) {
                    [requestParmasString appendString:@"&"];
                } else {
                    [requestParmasString appendString:@"?"];
                }
                
                NSString *keyValueString = value;
                [requestParmasString appendFormat:@"%@=%@", key, keyValueString];
            }
        } else {
            
        }
    }
    
    NSString *fullUrlForGet = [NSString stringWithFormat:@"%@%@", requestUrl, requestParmasString];
    return fullUrlForGet;
}



#pragma mark - Private Method
+ (NSString *)getErrorMessageFromURLResponse:(NSURLResponse *)URLResponse {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)URLResponse;
    return [self getErrorMessageFromHTTPURLResponse:response];
}

/**
 *  从Response中获取错误信息
 *  400 (语法错误)　　401 (未通过验证)　　403 (拒绝请求)　　404 (找不到请求的页面)　　500 (服务器内部错误)
 *
 */
+ (NSString *)getErrorMessageFromHTTPURLResponse:(NSHTTPURLResponse *)response {
    NSString *errorMessage = @"";
    if (response == nil) {
        errorMessage = NSLocalizedString(@"无法连接服务器", nil);
        return errorMessage;
    }
    
    NSInteger statusCode = response.statusCode;//参照服务器状态码大全
    switch (statusCode) {
        case 400:{
            errorMessage = NSLocalizedString(@"语法错误", nil);
            break;
        }
        case 401:{
            errorMessage = NSLocalizedString(@"未通过验证", nil);
            break;
        }
        case 403:{
            errorMessage = NSLocalizedString(@"拒绝请求", nil);
            break;
        }
        case 404:{
            errorMessage = NSLocalizedString(@"找不到请求的页面", nil);
            break;
        }
        case 500:{
            errorMessage = NSLocalizedString(@"服务不可用(500 Internal Server Error)，服务器内部错误", nil);
            break;
        }
        case 501:{
            errorMessage = NSLocalizedString(@"服务不可用(501)，服务器不具有请求功能", nil);
            break;
        }
        case 502:{
            errorMessage = NSLocalizedString(@"服务不可用(502 Bad Gateway)，错误忘关", nil);
            break;
        }
        case 503:{
            errorMessage = NSLocalizedString(@"服务不可用(503 Service Unavailable)，可能是服务器正在维护或者暂停", nil);
            break;
        }
        case 504:{
            errorMessage = NSLocalizedString(@"服务不可用(504 Gateway Time-out)，网关超时", nil);
            break;
        }
        default:{
            //errorMessage = task.responseString;
            errorMessage = @"未知网络错误";
            break;
        }
    }
    
    return errorMessage;
}




@end

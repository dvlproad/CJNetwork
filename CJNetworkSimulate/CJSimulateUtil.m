//
//  CJSimulateUtil.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/4/8.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJSimulateUtil.h"
#import "CJSimulateLocalUtil.h"
#import "CJSimulateRemoteUtil.h"

@implementation CJSimulateUtil

#pragma mark - Local请求
/*
 *  开始本地模拟接口请求
 *
 *  @param apiSuffix        api文件的本地路径(可以不带.json，也可以带)
 *  @param completeBlock    获取到数据的回调
 */
+ (void)localSimulateApi:(NSString *)apiSuffix completeBlock:(void (^)(NSDictionary *responseDictionary))completeBlock
{
    [CJSimulateLocalUtil localSimulateApi:apiSuffix completeBlock:completeBlock];
}

#pragma mark - POST请求
/*
 *  发起POST请求
 *
 *  @param Url          Url
 *  @param params       params
 *  @param success      请求成功的回调failure
 *  @param failure      请求失败的回调failure
 *
 *  @return 请求的task
 */
+ (void)postSimulateApi:(NSString *)apiSuffix
                success:(nullable void (^)(NSDictionary *responseDictionary))success
                failure:(nullable void (^)(NSString * _Nullable message))failure
{
    NSString *Url = nil;
    if ([apiSuffix hasPrefix:@"http"]) {
        Url = apiSuffix;
    } else {
        Url = [@"http://localhost/" stringByAppendingString:apiSuffix];
    }
    
    [CJSimulateRemoteUtil postUrl:Url params:nil success:success failure:failure];
}


#pragma mark - GET请求
/*
 *  发起GET请求
 *
 *  @param Url          Url
 *  @param params       params
 *  @param success      请求成功的回调failure
 *  @param failure      请求失败的回调failure
 */
+ (void)getSimulateApi:(NSString *)apiSuffix
               success:(nullable void (^)(NSDictionary *responseDictionary))success
               failure:(nullable void (^)(NSString * _Nullable message))failure
{
    NSString *Url = nil;
    if ([apiSuffix hasPrefix:@"http"]) {
        Url = apiSuffix;
    } else {
        Url = [@"http://localhost/" stringByAppendingString:apiSuffix];
    }
    
    [CJSimulateRemoteUtil getUrl:Url params:nil success:success failure:failure];
}

@end

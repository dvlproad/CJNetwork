//
//  CJSimulateRemoteUtil.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 15/11/22.
//  Copyright © 2015年 dvlproad. All rights reserved.
//
//  利用系统方法进行简单的网络请求模拟

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJSimulateRemoteUtil : NSObject

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
+ (NSURLSessionDataTask *)postUrl:(NSString *)Url
                           params:(nullable id)params
                          success:(nullable void (^)(NSDictionary *responseDictionary))success
                          failure:(nullable void (^)(NSString * _Nullable message))failure;

#pragma mark - GET请求
/*
 *  发起GET请求
 *
 *  @param Url          Url
 *  @param params       params
 *  @param success      请求成功的回调failure
 *  @param failure      请求失败的回调failure
 */
+ (NSURLSessionDataTask *)getUrl:(NSString *)Url
                          params:(nullable id)params
                         success:(nullable void (^)(NSDictionary *responseDictionary))success
                         failure:(nullable void (^)(NSString * _Nullable message))failure;
NS_ASSUME_NONNULL_END

@end

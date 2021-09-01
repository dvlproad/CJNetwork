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
                         failure:(nullable void (^)(NSError * _Nonnull error, NSString * _Nullable errorMessage))failure;

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
                          failure:(nullable void (^)(NSError * _Nonnull error, NSString * _Nullable errorMessage))failure;

@end

NS_ASSUME_NONNULL_END

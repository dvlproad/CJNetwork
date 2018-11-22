//
//  AFHTTPSessionManager+CJConcurrenceControl.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/11/20.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFHTTPSessionManager (CJConcurrenceControl)

#pragma mark - 并发数控制

/// 设置并发数(TODO:多个请求因为失败，同时调用此方法怎么办)
- (void)setupConcurrenceCount:(NSInteger)concurrenceCount;


#pragma mark - 拦截操作(一般只会用于需要获取dns的网络中)

/// 设置拦截的操作
- (void)setupKeeperUrl:(NSString *)Url withTimeout:(NSTimeInterval)timeout;

/// 网络请求开始前，对信号量做等待(减法)操作
- (void)didConcurrenceControlWithStartRequestUrl:(NSString *)Url;

/// 网络请求结束后，对信号量做增加操作
- (void)didConcurrenceControlWithEndRequestUrl:(NSString *)Url;

@end

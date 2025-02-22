//
//  AFHTTPSessionManager+CQDemo.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//
//  通过传进去的方法，单独处理加密问题，如果不想单独设置而是全局设置，请使用AFHTTPSessionManager+CJSerializerEncrypt.h

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  AFN的请求方法(包含缓存和加密方法)
 */
@interface AFHTTPSessionManager (CQDemo) {
    
}

#pragma mark - CJEncrypt
/*
 *  创建一个 manager 示例
 *
 *  @param Url                  Url
 *
 *  return 一个 manager 示例
 */
+ (AFHTTPSessionManager *)cqdemoManager;


NS_ASSUME_NONNULL_END

@end

//
//  AFHTTPSessionManager+CJRequestConcurrence.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/11/20.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "AFHTTPSessionManager+CJRequestConcurrence.h"
#import <objc/runtime.h>

@interface AFURLSessionManager () {
    
}
#pragma mark - 拦截操作(一般只会用于需要获取dns的网络中)
@property (nonatomic, copy) NSString *cjKeeperUrl;  /**< 需要拦截的Url，其他请求需要等到该Url请求结束后才能继续 */
@property (nonatomic, assign) NSTimeInterval cjKeeperTimeout;   /**< 需要拦截的Url的超时时间 */
@property (nonatomic, assign) NSTimeInterval cjOriginTimeout;   /**< 原始请求的超时时间 */

@end


@implementation AFHTTPSessionManager (CJRequestConcurrence)

#pragma mark - 拦截操作(一般只会用于需要获取dns的网络中)
// cjKeeperUrl
- (NSString *)cjKeeperUrl {
    return objc_getAssociatedObject(self, @selector(cjKeeperUrl));
}

- (void)setCjKeeperUrl:(NSString *)cjKeeperUrl {
    objc_setAssociatedObject(self, @selector(cjKeeperUrl), cjKeeperUrl, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//cjKeeperTimeout
- (NSTimeInterval)cjKeeperTimeout {
    return [objc_getAssociatedObject(self, @selector(cjKeeperTimeout)) doubleValue];
}

- (void)setCjKeeperTimeout:(NSTimeInterval)cjKeeperTimeout {
    objc_setAssociatedObject(self, @selector(cjKeeperTimeout), @(cjKeeperTimeout), OBJC_ASSOCIATION_ASSIGN);
}

//cjOriginTimeout
- (NSTimeInterval)cjOriginTimeout {
    return [objc_getAssociatedObject(self, @selector(cjOriginTimeout)) doubleValue];
}

- (void)setCjOriginTimeout:(NSTimeInterval)cjOriginTimeout {
    objc_setAssociatedObject(self, @selector(cjOriginTimeout), @(cjOriginTimeout), OBJC_ASSOCIATION_ASSIGN);
}

/// 设置拦截的操作
- (void)setupKeeperUrl:(NSString *)Url withTimeout:(NSTimeInterval)timeout {
    self.cjKeeperUrl = Url;
    self.cjKeeperTimeout = timeout;
    
    self.cjOriginTimeout = self.requestSerializer.timeoutInterval;
    self.requestSerializer.timeoutInterval = timeout;
}

/// 网络请求开始前，对信号量做等待(减法)操作
- (void)__didConcurrenceControlWithStartRequestUrl:(NSString *)Url {
    if ([Url isEqualToString:self.cjKeeperUrl]) {
        [self __changeConcurrenceCount:1];
    } else {
        [self __minusOneConcurrenceCount];
    }
}

/// 网络请求结束后，对信号量做增加操作
- (void)__didConcurrenceControlWithEndRequestUrl:(NSString *)Url {
    if ([Url isEqualToString:self.cjKeeperUrl]) {
        [self __recoverConcurrenceCount];
    } else {
        [self __addOneConcurrenceCount];
    }
}

@end

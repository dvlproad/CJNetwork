//
//  AFHTTPSessionManager+CJConcurrenceControl.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/11/20.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "AFHTTPSessionManager+CJConcurrenceControl.h"
#import <objc/runtime.h>

@interface AFURLSessionManager () {
    
}
#pragma mark - 并发数控制
@property (nonatomic, strong) dispatch_semaphore_t cjKeeperSignal;
@property (nonatomic, strong) dispatch_semaphore_t cjConcurrenceCountSignal;/**< 管理计算信号量通道值变化的信号量 */
@property (nonatomic, assign) long cjKeeperSignalCount;         /**< 记录并发数个数的值 */
@property (nonatomic, assign) BOOL shouldControlConcurrence;    /**< 是否应该控制并发数(默认NO) */
@property (nonatomic, assign) NSInteger concurrenceCount;       /**< 有控制并发数时候的请求并发数 */

#pragma mark - 拦截操作(一般只会用于需要获取dns的网络中)
@property (nonatomic, copy) NSString *cjKeeperUrl;  /**< 需要拦截的Url，其他请求需要等到该Url请求结束后才能继续 */
@property (nonatomic, assign) NSTimeInterval cjKeeperTimeout;   /**< 需要拦截的Url的超时时间 */
@property (nonatomic, assign) NSTimeInterval cjOriginTimeout;   /**< 原始请求的超时时间 */

@end


@implementation AFHTTPSessionManager (CJConcurrenceControl)

#pragma mark - 并发数控制
// cjKeeperSignal
- (dispatch_semaphore_t)cjKeeperSignal {
    return objc_getAssociatedObject(self, @selector(cjKeeperSignal));
}

- (void)setCjKeeperSignal:(dispatch_semaphore_t)cjKeeperSignal {
    objc_setAssociatedObject(self, @selector(cjKeeperSignal), cjKeeperSignal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//cjConcurrenceCountSignal
- (dispatch_semaphore_t)cjConcurrenceCountSignal {
    return objc_getAssociatedObject(self, @selector(cjConcurrenceCountSignal));
}

- (void)setCjConcurrenceCountSignal:(dispatch_semaphore_t)cjConcurrenceCountSignal {
    objc_setAssociatedObject(self, @selector(cjConcurrenceCountSignal), cjConcurrenceCountSignal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// cjKeeperSignalCount
- (long)cjKeeperSignalCount {
    return [objc_getAssociatedObject(self, @selector(cjKeeperSignalCount)) longValue];
}

- (void)setCjKeeperSignalCount:(long)cjKeeperSignalCount {
    objc_setAssociatedObject(self, @selector(cjKeeperSignalCount), @(cjKeeperSignalCount), OBJC_ASSOCIATION_ASSIGN);
}

// shouldControlConcurrence
- (BOOL)shouldControlConcurrence {
    return [objc_getAssociatedObject(self, @selector(shouldControlConcurrence)) boolValue];
}

- (void)setShouldControlConcurrence:(BOOL)shouldControlConcurrence {
    objc_setAssociatedObject(self, @selector(shouldControlConcurrence), @(shouldControlConcurrence), OBJC_ASSOCIATION_ASSIGN);
}

// concurrenceCount
- (NSInteger)concurrenceCount {
    return [objc_getAssociatedObject(self, @selector(concurrenceCount)) integerValue];
}

- (void)setConcurrenceCount:(NSInteger)concurrenceCount {
    objc_setAssociatedObject(self, @selector(concurrenceCount), @(concurrenceCount), OBJC_ASSOCIATION_ASSIGN);
}

/// 设置并发数
- (void)setupConcurrenceCount:(NSInteger)concurrenceCount {
    NSAssert(concurrenceCount > 0, @"并发数必须大于0");
    
    self.shouldControlConcurrence = YES;
    self.concurrenceCount = concurrenceCount;
    
    if (self.cjKeeperSignal == nil) {
        self.cjKeeperSignal = dispatch_semaphore_create(concurrenceCount);
        self.cjConcurrenceCountSignal = dispatch_semaphore_create(1);
        self.cjKeeperSignalCount = concurrenceCount;
        
    } else {
        [self recoverConcurrenceCount];
    }
}

/// 恢复并发数(如果有些操作会更改到并发数，那么在该操作结束时候，需要调用此方法来恢复并发数)
- (void)recoverConcurrenceCount {
    if (!self.shouldControlConcurrence) {
        return;
    }
    
    if (self.cjKeeperSignalCount == self.concurrenceCount) {
        return;
    }
    
    if (self.cjKeeperSignalCount > self.concurrenceCount) { //并发数超过指定值，应该减少额外的信号量
        NSInteger shouldExtarReleaseSignalCount = self.cjKeeperSignalCount-self.concurrenceCount;
        for (NSInteger i = 0; i < shouldExtarReleaseSignalCount; i++) {
            [self __minusOneConcurrenceCount];
        }
        
    } else if (self.cjKeeperSignalCount < self.concurrenceCount) {//并发数小于指定值，应该增加额外的信号量
        NSInteger shouldExtarAddSignalCount = self.concurrenceCount-self.cjKeeperSignalCount;
        for (NSInteger i = 0; i < shouldExtarAddSignalCount; i++) {
            [self __addOneConcurrenceCount];
        }
    }
}

/// 网络请求开始前，对信号量做等待(减法)操作
- (void)__normalStartRequest {
    if (!self.shouldControlConcurrence) {
        return;
    }
    
    if (self.cjKeeperSignal) {
        [self __minusOneConcurrenceCount];
    }
}

/// 网络请求结束后，对信号量做增加操作
- (void)__normalEndRequest {
    if (!self.shouldControlConcurrence) {
        return;
    }
    
    if (self.cjKeeperSignal) {
        [self __addOneConcurrenceCount];
    }
}

- (void)__specialStartRequestWithKeeper {
    if (!self.shouldControlConcurrence) {
        return;
    }
    
    [self setupConcurrenceCount:1];
}

- (void)__specialEndRequestWithKeeper {
    if (!self.shouldControlConcurrence) {
        return;
    }
    
    [self recoverConcurrenceCount];
}

/// 并发数 +1
- (void)__addOneConcurrenceCount {
    dispatch_semaphore_signal(self.cjKeeperSignal);
    [self __updateConcurrenceCountWithChange:1];
}

/// 并发数 -1
- (void)__minusOneConcurrenceCount {
    dispatch_semaphore_wait(self.cjKeeperSignal, DISPATCH_TIME_FOREVER);
    [self __updateConcurrenceCountWithChange:-1];
}

/// 修改记录并发数个数的值
- (void)__updateConcurrenceCountWithChange:(NSInteger)changeCount {
    dispatch_semaphore_wait(self.cjConcurrenceCountSignal, DISPATCH_TIME_FOREVER);
    self.cjKeeperSignalCount = self.cjKeeperSignalCount + changeCount;
    dispatch_semaphore_signal(self.cjConcurrenceCountSignal);
}



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
- (void)didConcurrenceControlWithStartRequestUrl:(NSString *)Url {
    if ([Url isEqualToString:self.cjKeeperUrl]) {
        [self __specialStartRequestWithKeeper];
    } else {
        [self __normalStartRequest];
    }
}

/// 网络请求结束后，对信号量做增加操作
- (void)didConcurrenceControlWithEndRequestUrl:(NSString *)Url {
    if ([Url isEqualToString:self.cjKeeperUrl]) {
        [self __specialEndRequestWithKeeper];
    } else {
        [self __normalEndRequest];
    }
}

@end

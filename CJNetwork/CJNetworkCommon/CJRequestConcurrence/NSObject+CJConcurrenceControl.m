//
//  NSObject+CJConcurrenceControl.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/11/20.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "NSObject+CJConcurrenceControl.h"
#import <objc/runtime.h>

@interface NSObject () {
    
}
#pragma mark - 并发数控制
@property (nonatomic, strong) dispatch_semaphore_t cjKeeperSignal;
@property (nonatomic, strong) dispatch_semaphore_t cjConcurrenceCountSignal;/**< 管理计算信号量通道值变化的信号量 */
@property (nonatomic, assign) long cjKeeperSignalCount;         /**< 记录并发数个数的值 */
@property (nonatomic, assign) NSInteger concurrenceCount;       /**< 有控制并发数时候的请求并发数 */

@end


@implementation NSObject (CJConcurrenceControl)

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


/// 设置允许控制并发数并指定并发数
- (void)allowConcurrenceCount:(NSInteger)concurrenceCount {
    self.shouldControlConcurrence = YES;
    [self __setupConcurrenceCount:concurrenceCount];
}

/// 改变并发数为指定数目
- (void)__changeConcurrenceCount:(NSInteger)concurrenceCount {
    if (!self.shouldControlConcurrence) {
        return;
    }
    
    [self __setupConcurrenceCount:concurrenceCount];
}

/// 设置并发数为指定数目
- (void)__setupConcurrenceCount:(NSInteger)concurrenceCount {
    NSAssert(concurrenceCount > 0, @"并发数必须大于0");
    
    self.concurrenceCount = concurrenceCount;
    
    if (self.cjKeeperSignal == nil) {
        self.cjKeeperSignal = dispatch_semaphore_create(concurrenceCount);
        self.cjConcurrenceCountSignal = dispatch_semaphore_create(1);
        self.cjKeeperSignalCount = concurrenceCount;
        
    } else {
        [self __recoverConcurrenceCount];
    }
}

/// 恢复并发数(如果有些操作会更改到并发数，那么在该操作结束时候，需要调用此方法来恢复并发数)
- (void)__recoverConcurrenceCount {
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

/// 并发数 +1
- (void)__addOneConcurrenceCount {
    if (!self.shouldControlConcurrence) {
        return;
    }
    
    if (self.cjKeeperSignal) {
        dispatch_semaphore_signal(self.cjKeeperSignal);
        [self __updateConcurrenceCountWithChange:1];
    }
}

/// 并发数 -1
- (void)__minusOneConcurrenceCount {
    if (!self.shouldControlConcurrence) {
        return;
    }
    
    if (self.cjKeeperSignal) {
        dispatch_semaphore_wait(self.cjKeeperSignal, DISPATCH_TIME_FOREVER);
        [self __updateConcurrenceCountWithChange:-1];
    }
    
}

/// 修改记录并发数个数的值
- (void)__updateConcurrenceCountWithChange:(NSInteger)changeCount {
    dispatch_semaphore_wait(self.cjConcurrenceCountSignal, DISPATCH_TIME_FOREVER);
    self.cjKeeperSignalCount = self.cjKeeperSignalCount + changeCount;
    dispatch_semaphore_signal(self.cjConcurrenceCountSignal);
}


@end

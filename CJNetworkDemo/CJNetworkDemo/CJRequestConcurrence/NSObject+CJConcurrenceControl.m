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
//@property (nonatomic, strong) dispatch_semaphore_t cjConcurrenceCountSignal;/**< 管理计算信号量通道值变化的信号量 */

@property (nonatomic, strong) dispatch_semaphore_t cjConcurrenceCountUpdateSignal;/**< 管理计算信号量通道值变化的信号量(更新值) */
@property (nonatomic, strong) dispatch_semaphore_t cjConcurrenceCountChangeSignal;/**< 管理计算信号量通道值变化的信号量(改变值) */

@property (nonatomic, assign) long cjKeeperSignalCount;             /**< 记录并发数个数的值 */
@property (nonatomic, assign) NSInteger cjAllowMaxConcurrenceCount; /**< 有控制并发数时候的请求并发数 */

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

////cjConcurrenceCountSignal
//- (dispatch_semaphore_t)cjConcurrenceCountSignal {
//    return objc_getAssociatedObject(self, @selector(cjConcurrenceCountSignal));
//}
//
//- (void)setCjConcurrenceCountSignal:(dispatch_semaphore_t)cjConcurrenceCountSignal {
//    objc_setAssociatedObject(self, @selector(cjConcurrenceCountSignal), cjConcurrenceCountSignal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

//cjConcurrenceCountUpdateSignal
- (dispatch_semaphore_t)cjConcurrenceCountUpdateSignal {
    return objc_getAssociatedObject(self, @selector(cjConcurrenceCountUpdateSignal));
}

- (void)setCjConcurrenceCountUpdateSignal:(dispatch_semaphore_t)cjConcurrenceCountUpdateSignal {
    objc_setAssociatedObject(self, @selector(cjConcurrenceCountUpdateSignal), cjConcurrenceCountUpdateSignal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//cjConcurrenceCountChangeSignal
- (dispatch_semaphore_t)cjConcurrenceCountChangeSignal {
    return objc_getAssociatedObject(self, @selector(cjConcurrenceCountChangeSignal));
}

- (void)setCjConcurrenceCountChangeSignal:(dispatch_semaphore_t)cjConcurrenceCountChangeSignal {
    objc_setAssociatedObject(self, @selector(cjConcurrenceCountChangeSignal), cjConcurrenceCountChangeSignal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

// cjAllowMaxConcurrenceCount
- (NSInteger)cjAllowMaxConcurrenceCount {
    return [objc_getAssociatedObject(self, @selector(cjAllowMaxConcurrenceCount)) integerValue];
}

- (void)setCjAllowMaxConcurrenceCount:(NSInteger)cjAllowMaxConcurrenceCount {
    objc_setAssociatedObject(self, @selector(cjAllowMaxConcurrenceCount), @(cjAllowMaxConcurrenceCount), OBJC_ASSOCIATION_ASSIGN);
}


/// 设置允许控制并发数并指定并发数
- (void)allowMaxConcurrenceCount:(NSInteger)allowMaxConcurrenceCount {
    self.shouldControlConcurrence = YES;
    self.cjAllowMaxConcurrenceCount = allowMaxConcurrenceCount;
    [self __changeConcurrenceCountTo:allowMaxConcurrenceCount];
}

/// 恢复并发数(如果有些操作会更改到并发数，那么在该操作结束时候，需要调用此方法来恢复并发数)
- (void)__recoverMaxAllowConcurrenceCount {
    NSLog(@"当前通道数:%zd，要恢复为原本指定的最大通道数%zd", self.cjKeeperSignalCount, self.cjAllowMaxConcurrenceCount);
    [self __changeConcurrenceCountTo:self.cjAllowMaxConcurrenceCount];
}

/// 改变并发数为指定数目
- (void)__changeConcurrenceCountTo:(NSInteger)concurrenceCount {
    NSAssert(concurrenceCount > 0, @"并发数必须大于0");
    
    if (!self.shouldControlConcurrence) {
        return;
    }
    
    if (self.cjKeeperSignal == nil) {
        self.cjKeeperSignal = dispatch_semaphore_create(concurrenceCount);
        self.cjKeeperSignalCount = concurrenceCount;
        
        return;
    }
    
//    NSLog(@"当前通道数:%zd，希望改变通道数为%zd", self.cjKeeperSignalCount, concurrenceCount);
//    NSInteger shouldChangeSignalCount = concurrenceCount-self.cjKeeperSignalCount; //比较改变到新通道，旧通道要变化的值
    NSLog(@"当前最大通道数:%zd，希望改变通道数为%zd", self.cjAllowMaxConcurrenceCount, concurrenceCount);
    NSInteger shouldChangeSignalCount = concurrenceCount-self.cjAllowMaxConcurrenceCount; //比较改变到新通道，旧通道要变化的值
    [self __changeConcurrenceCountWith:shouldChangeSignalCount];
}


/// 将要改变并发记录数
- (BOOL)__willUpdateConcurrenceCount {
    if (!self.shouldControlConcurrence) {
        return NO;
    }
    
    if (!self.cjKeeperSignal) {
        return NO;
    }
    

    if (self.cjConcurrenceCountUpdateSignal == nil) {
        self.cjConcurrenceCountUpdateSignal = dispatch_semaphore_create(1);
    } else {
        dispatch_semaphore_wait(self.cjConcurrenceCountUpdateSignal, DISPATCH_TIME_FOREVER);
    }
    return YES;
}


/// 正式改变并发数 +1
- (void)__didAddOneConcurrenceCount {
    dispatch_semaphore_signal(self.cjKeeperSignal);
    self.cjKeeperSignalCount = self.cjKeeperSignalCount+1;
    
    dispatch_semaphore_signal(self.cjConcurrenceCountUpdateSignal);
    
}

/// 正式改变并发数 -1
- (void)__didMinusOneConcurrenceCount {
    dispatch_semaphore_wait(self.cjKeeperSignal, DISPATCH_TIME_FOREVER);
    self.cjKeeperSignalCount = self.cjKeeperSignalCount-1;
    
    dispatch_semaphore_signal(self.cjConcurrenceCountUpdateSignal);
}


/// 改变并发数(加减changeCount个数)
- (void)__changeConcurrenceCountWith:(NSInteger)changeCount {
    if (!self.shouldControlConcurrence) {
        return;
    }
    
    if (!self.cjKeeperSignal) {
        return;
    }
    
    if (changeCount == 0) {
        return;
    }
    
    //NSLog(@"准备改变");
//    if (self.cjConcurrenceCountSignal == nil) {
//        self.cjConcurrenceCountSignal = dispatch_semaphore_create(1);
//    } else {
//        dispatch_semaphore_wait(self.cjConcurrenceCountSignal, DISPATCH_TIME_FOREVER);
//    }
    if (self.cjConcurrenceCountChangeSignal == nil) {
        self.cjConcurrenceCountChangeSignal = dispatch_semaphore_create(1);
    } else {
        dispatch_semaphore_wait(self.cjConcurrenceCountChangeSignal, DISPATCH_TIME_FOREVER);
    }
    
    if (changeCount > 0) { //减少额外的信号量
        NSUInteger addCount = changeCount;
        for (NSInteger i = 0; i < addCount; i++) {
            dispatch_semaphore_signal(self.cjKeeperSignal);
        }
        self.cjKeeperSignalCount = self.cjKeeperSignalCount+addCount;
        
    } else if (changeCount < 0) { //增加额外的信号量
        NSUInteger minusCount = -changeCount;
        for (NSInteger i = 0; i < minusCount; i++) {
            dispatch_semaphore_wait(self.cjKeeperSignal, DISPATCH_TIME_FOREVER);
        }
        self.cjKeeperSignalCount = self.cjKeeperSignalCount-minusCount;
    }
    NSLog(@"更改后现在通道数为%zd", self.cjKeeperSignalCount); //不要将此句放在这里的dispatch_semaphore_signal后
    
    //dispatch_semaphore_signal(self.cjConcurrenceCountSignal);
    dispatch_semaphore_signal(self.cjConcurrenceCountChangeSignal);
    //NSLog(@"结束改变");
}


@end

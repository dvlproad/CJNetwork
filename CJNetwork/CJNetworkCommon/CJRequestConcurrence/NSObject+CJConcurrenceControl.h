//
//  NSObject+CJConcurrenceControl.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/11/20.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CJConcurrenceControl) {
    
}
@property (nonatomic, assign) BOOL shouldControlConcurrence;    /**< 是否应该控制并发数(默认NO) */

#pragma mark - 并发数控制

/// 设置允许控制并发数并指定并发数
- (void)allowConcurrenceCount:(NSInteger)concurrenceCount;

/// 改变并发数为指定数目(TODO:多个请求因为失败，同时调用此方法怎么办)
- (void)__changeConcurrenceCount:(NSInteger)concurrenceCount;

/// 恢复并发数(如果有些操作会更改到并发数，那么在该操作结束时候，需要调用此方法来恢复并发数)
- (void)__recoverConcurrenceCount;

/// 并发数 +1
- (void)__addOneConcurrenceCount;

/// 并发数 -1
- (void)__minusOneConcurrenceCount;

@end

//
//  TestConcurrenceModel.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/11/20.
//  Copyright © 2018 dvlproad. All rights reserved.
//
//  一个独立测试并发数的TestConcurrenceModel，用于在测试网络前，测试所添加的并发数控制方法是否正确的问题

#import <Foundation/Foundation.h>
#import "NSObject+CJConcurrenceControl.h"

@interface TestConcurrenceModel : NSObject {
    
}
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

- (void)runModelWithIndex:(NSInteger)index;

- (void)runModelWithKeeper;

@end

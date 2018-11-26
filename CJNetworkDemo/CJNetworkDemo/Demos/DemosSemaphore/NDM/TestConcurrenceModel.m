//
//  TestConcurrenceModel.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/11/20.
//  Copyright © 2018 dvlproad. All rights reserved.
//

#import "TestConcurrenceModel.h"

@implementation TestConcurrenceModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_queue_t concurrentQueue = dispatch_queue_create("model.classConcurrenceCount.queue", DISPATCH_QUEUE_CONCURRENT); //创建并发队列
        self.concurrentQueue = concurrentQueue;
    }
    return self;
}

- (void)runModelWithIndex:(NSInteger)index {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("model.testConcurrenceCount.queue", DISPATCH_QUEUE_CONCURRENT); //创建并发队列
    [self __willUpdateConcurrenceCount];
    dispatch_async(concurrentQueue, ^{
        NSLog(@"%ld:开始", index);
        sleep(2);
        [self __didAddOneConcurrenceCount];
        NSLog(@"%ld:模拟的网络请求结束", index);
    });
    [self __willUpdateConcurrenceCount];
    [self __didMinusOneConcurrenceCount];
}

- (void)runModelWithKeeper {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("model.testConcurrenceCount.queue2", DISPATCH_QUEUE_CONCURRENT); //创建并发队列
    dispatch_async(concurrentQueue, ^{
        //耗时的操作
        sleep(10);
        
        NSLog(@"模拟网络请求dns时候的拦截的操作结束");
        [self __recoverMaxAllowConcurrenceCount];  // 网络请求结束后，并发量操作
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新界面
        });
    });
    
    dispatch_queue_t concurrentKeepQueue = dispatch_queue_create("model.testConcurrenceCount.keepQueue", DISPATCH_QUEUE_CONCURRENT); //创建并发队列
    dispatch_async(concurrentKeepQueue, ^{
        [self __changeConcurrenceCountTo:1];    // 网络请求开始后，并发量操作
    });
//    [self __changeConcurrenceCountTo:1];    // 网络请求开始后，并发量操作
}

@end

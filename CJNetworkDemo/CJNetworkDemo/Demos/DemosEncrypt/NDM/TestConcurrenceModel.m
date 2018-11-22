//
//  TestConcurrenceModel.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/11/20.
//  Copyright © 2018 dvlproad. All rights reserved.
//

#import "TestConcurrenceModel.h"

@implementation TestConcurrenceModel

- (void)runModelWithIndex:(NSInteger)index {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //耗时的操作
        sleep(5);
        
        NSLog(@"%ld:模拟的网络请求结束", index);
        [self __addOneConcurrenceCount];  // 网络请求结束后，并发量操作
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新界面
        });
    });
    [self __minusOneConcurrenceCount];    // 网络请求开始后，并发量操作
}

@end

//
//  TestConcurrenceManager.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/11/20.
//  Copyright © 2018 dvlproad. All rights reserved.
//
//  一个独立测试并发数的TestConcurrenceManager，用于在测试网络前，测试所添加的并发数控制方法是否正确的问题

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager+CJRequestConcurrence.h"

@interface TestConcurrenceManager : AFHTTPSessionManager

- (void)runModelWithIndex:(NSInteger)index;

@end

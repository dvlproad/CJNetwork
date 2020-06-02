//
//  TS113CacheResponseModel.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/18.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TS113CacheResponseModel.h"

@implementation TS113CacheResponseModel

- (BOOL)isNoNullForObject:(id)object {
    if ([object isKindOfClass:[NSNull class]]) {
        return NO;
    } else {
        return YES;
    }
}

@end

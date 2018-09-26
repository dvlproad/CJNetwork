//
//  HealthResponseModel.m
//  CJNetworkDemo
//
//  Created by 李超前 on 2018/9/26.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "HealthResponseModel.h"

@implementation HealthResponseModel

- (instancetype)initWithResponseDictionary:(NSDictionary *)responseDictionary {
    self = [super init];
    if (self) {
        NSInteger statusCode = [[responseDictionary objectForKey:@"status"] integerValue];
        self.status = statusCode;
        
        NSString *message = responseDictionary[@"msg"];
        if ([self isNoNullForObject:message]) {
            self.message = message;
        }
        
        id result = responseDictionary[@"result"];
        if ([self isNoNullForObject:result]) {
            self.result = result;
        }
        
    }
    return self;
}

- (BOOL)isNoNullForObject:(id)object {
    if ([object isKindOfClass:[NSNull class]]) {
        return NO;
    } else {
        return YES;
    }
}

@end

//
//  CJResponseModel.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/18.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJResponseModel.h"

@implementation CJResponseModel

- (instancetype)initWithResponseDictionary:(NSDictionary *)responseDictionary isCacheData:(BOOL)isCacheData {
    self = [super init];
    if (self) {
        NSInteger statusCode = [[responseDictionary objectForKey:@"status"] integerValue];
        self.status = statusCode;
        
        NSString *message = responseDictionary[@"message"];
        if ([self isNoNullForObject:message]) {
            self.message = message;
        }
        
        id result = responseDictionary[@"result"];
        if ([self isNoNullForObject:result]) {
            self.result = result;
        }
        
        self.isCacheData = isCacheData;
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

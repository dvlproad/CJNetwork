//
//  NSString+CJNetworkUrl.m
//  CJNetwork
//
//  Created by ciyouzen on 15/11/22.
//  Copyright © 2015年 dvlproad. All rights reserved.
//

#import "NSString+CJNetworkUrl.h"

@implementation NSString (CJNetworkUrl)

- (nullable NSString *)cjnetworkUrl_ValueForKey:(NSString *)key {
    // 创建正则表达式模式
    NSString *pattern = [NSString stringWithFormat:@"/%@/(\\d+)", key];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    
    // 匹配字符串
    NSTextCheckingResult *matchResult = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    
    if (matchResult) {
        NSRange valueRange = [matchResult rangeAtIndex:1];
        if (valueRange.location != NSNotFound) {
            return [self substringWithRange:valueRange];
        }
    }
    
    return nil;
}

@end

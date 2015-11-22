//
//  URLRequestUtil.m
//  CommonAFNUtilDemo
//
//  Created by 李超前 on 15/11/22.
//  Copyright © 2015年 ciyouzen. All rights reserved.
//

#import "URLRequestUtil.h"

@implementation URLRequestUtil

#pragma mark - request定义
+ (NSMutableURLRequest *)URLRequest_Url:(NSString *)Url params:(NSDictionary *)params{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:Url]];
    
    NSMutableString *postData = [NSMutableString new];
    for (NSString *key in [params allKeys]) {
        id obj = [params valueForKey:key];
        if ([obj isKindOfClass:[NSString class]]) {
            if (postData.length!=0) {
                [postData appendString:@"&"];
            }
            [postData appendFormat:@"%@=%@",key,obj];
        }
        if ([obj isKindOfClass:[NSArray class]]) {
            for (NSString *value in obj) {
                if (postData.length!=0) {
                    [postData appendString:@"&"];
                }
                [postData appendFormat:@"%@=%@",key,value];
            }
        }
    }

    NSLog(@"postData = %@",postData);
    
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    //[request setValue:@"" forHTTPHeaderField:@"User-Agent"];
    
    return request;
}

@end

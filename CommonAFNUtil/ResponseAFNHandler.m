//
//  ResponseAFNHandler.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "ResponseAFNHandler.h"

@implementation ResponseAFNHandler

+ (void)onSuccess:(AFHTTPRequestOperation *)operation callback:(id<WebServiceAFNDelegate>)delegate tag:(NSInteger)tag{
    //id responseObject = operation.responseObject;
    NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
    //NSLog(@"responseObject = %@", responseObject);
    
    /* 
    //NSJSONReadingMutableContainers的作用: http://blog.csdn.net/chenyong05314/article/details/45691041
    NSJSONReadingMutableContainers：返回可变容器，NSMutableDictionary或NSMutableArray。
    NSJSONReadingMutableLeaves：返回的JSON对象中字符串的值为NSMutableString
    NSJSONReadingAllowFragments：允许JSON字符串最外层既不是NSArray也不是NSDictionary，但必须是有效的JSON Fragment。例如使用这个选项可以解析 @“123” 这样的字符串。
    */
    [delegate onRequestSuccess:operation tag:tag responseObject:responseObject];
}

+ (void)onFailure:(AFHTTPRequestOperation *)operation callback:(id<WebServiceAFNDelegate>)delegate tag:(NSInteger)tag{
    //if (DEBUG) {
    if (1) {
        NSInteger statusCode = operation.response.statusCode;
        NSError *error = operation.error;
        NSLog(@"statusCode = %zd, errMesg = %@", statusCode, error); //[error description]、[error localizedDescription]、[error userInfo]
    }
    
    if (delegate && [delegate respondsToSelector:@selector(onRequestFailure:tag:)]) {
        [delegate onRequestFailure:operation tag:tag];
    }
}

@end

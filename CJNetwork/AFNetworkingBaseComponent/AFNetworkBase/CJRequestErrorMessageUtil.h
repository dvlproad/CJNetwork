//
//  CJRequestErrorMessageUtil.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJRequestErrorMessageUtil : NSObject

+ (NSString *)getErrorMessageFromURLSessionTask:(NSURLSessionTask *)task;

+ (NSString *)getErrorMessageFromURLResponse:(NSURLResponse *)URLResponse;

+ (NSString *)getErrorMessageFromHTTPURLResponse:(NSHTTPURLResponse *)response;

@end

//
//  ResponseAFNHandler.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPRequestOperation.h>
#import "WebServiceAFNDelegate.h"

@interface ResponseAFNHandler : NSObject

+ (void)onSuccess:(AFHTTPRequestOperation *)operation callback:(id<WebServiceAFNDelegate>)delegate tag:(NSInteger)tag;
+ (void)onFailure:(AFHTTPRequestOperation *)operation callback:(id<WebServiceAFNDelegate>)delegate tag:(NSInteger)tag;

@end

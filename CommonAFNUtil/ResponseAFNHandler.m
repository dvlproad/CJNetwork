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
    //NSLog(@"responseObject = %@", responseObject);
    [delegate onRequestSuccess:operation tag:tag];
}

+ (void)onFailure:(AFHTTPRequestOperation *)operation callback:(id<WebServiceAFNDelegate>)delegate tag:(NSInteger)tag{
    //if (DEBUG) {
    if (1) {
        NSInteger statusCode = operation.response.statusCode;
        NSError *error = operation.error;
        NSLog(@"statusCode = %zd, errMesg = %@", statusCode, [error localizedDescription]);
    }
    
    [delegate onRequestFailure:operation tag:tag];
}

@end

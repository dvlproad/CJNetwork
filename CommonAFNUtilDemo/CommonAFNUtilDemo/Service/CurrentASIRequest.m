//
//  CurrentASIRequest.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/10/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CurrentASIRequest.h"

#define kToken @"token"

@implementation CurrentASIRequest


+ (ASIHTTPRequest *)request_URL:(NSURL *)URL params:(NSDictionary *)params method:(ASIRequestType)requestType isNeedToken:(BOOL)isNeed{
    
    ASIHTTPRequest *request = [CommonASIUtil request_URL:URL params:params method:requestType];
    if (request) {
        if (isNeed) {
            NSString *token = [self getRequestHeaderToken];
            if (token) {
                [request addRequestHeader:@"X-CSRF-Token" value:token];
            }else{
                NSLog(@"error:token = nil");
                return nil;
            }
        }
    }
    
    return request;
}


+ (void)saveRequestHeaderToken:(NSString *)token{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kToken];
}

+ (NSString *)getRequestHeaderToken{
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:kToken];
    return token;
}


@end

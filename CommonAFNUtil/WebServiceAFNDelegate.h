//
//  WebServiceAFNDelegate.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

@class AFHTTPRequestOperation;

@protocol WebServiceAFNDelegate <NSObject>

@required
- (void)onRequestSuccess:(AFHTTPRequestOperation *)operation tag:(NSInteger)tag responseObject:(id)responseObject;
@optional
- (void)onRequestFailure:(AFHTTPRequestOperation *)operation tag:(NSInteger)tag failMesg:(NSString *)failMesg;

@end

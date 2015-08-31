//
//  WebServiceASIDelegate.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

@class ASIHTTPRequest;

@protocol WebServiceASIDelegate <NSObject>

//@required
//- (void)onRequestSuccess:(ASIHTTPRequest *)request responseObject:(id)responseObject;
- (void)onRequestSuccess:(ASIHTTPRequest *)request;
- (void)onRequestFailure:(ASIHTTPRequest *)request;

@end

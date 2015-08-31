//
//  ResponseASIHandler.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceASIDelegate.h"
#import <ASIHTTPRequest.h>
@interface ResponseASIHandler : NSObject

+ (void)onSuccess:(ASIHTTPRequest *)request callback:(id<WebServiceASIDelegate>)delegate;
+ (void)onFailure:(ASIHTTPRequest *)request callback:(id<WebServiceASIDelegate>)delegate;

@end

//
//  CurrentASIRequest.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/10/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ASIHTTPRequest.h>
#import "CommonASIUtil.h"

@interface CurrentASIRequest : NSObject

+ (ASIHTTPRequest *)request_URL:(NSURL *)URL params:(NSDictionary *)params method:(ASIRequestType)requestType isNeedToken:(BOOL)isNeed;

@end

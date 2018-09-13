//
//  CJNetworkLogUtil.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJNetworkLogUtil : NSObject

#pragma mark - Log
///successNetworkLog
+ (id)printSuccessNetworkLogWithUrl:(NSString *)Url params:(id)params request:(NSURLRequest *)request responseObject:(id)responseObject;

///errorNetworkLog
+ (NSError *)printErrorNetworkLogWithUrl:(NSString *)Url params:(id)params request:(NSURLRequest *)request error:(NSError *)error URLResponse:(NSURLResponse *)URLResponse;


@end

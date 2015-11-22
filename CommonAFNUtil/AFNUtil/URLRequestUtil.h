//
//  URLRequestUtil.h
//  CommonAFNUtilDemo
//
//  Created by 李超前 on 15/11/22.
//  Copyright © 2015年 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLRequestUtil : NSObject

+ (NSMutableURLRequest *)URLRequest_Url:(NSString *)Url params:(NSDictionary *)params;

@end

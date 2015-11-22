//
//  CommonAFNInstance.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/10/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNUtil.h"
#import "AFNUtilCache.h"

@interface CommonAFNInstance : NSObject

+ (CommonAFNInstance *)shareCommonAFNInstance;


- (AFHTTPRequestOperation *)useManager:(AFHTTPRequestOperationManager *)manager
                        postRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSString *failMesg))failure;

- (AFHTTPRequestOperation *)useManager:(AFHTTPRequestOperationManager *)manager
                        postRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                              useCache:(BOOL)useCache
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject, BOOL isCacheData))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSString *failMesg, BOOL isCacheData))failure;



@end

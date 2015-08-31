//
//  CommonAFNInstance.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/10/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonAFNUtil.h"

@interface CommonAFNInstance : NSObject

+ (CommonAFNInstance *)shareCommonAFNInstance;

//GET
- (AFHTTPRequestOperation *)useManager_d:(AFHTTPRequestOperationManager *)manager getRequestUrl:(NSString *)Url params:(NSDictionary *)params delegate:(id<WebServiceAFNDelegate>)delegate;
- (AFHTTPRequestOperation *)useManager_d:(AFHTTPRequestOperationManager *)manager getRequestUrl:(NSString *)Url params:(NSDictionary *)params delegate:(id<WebServiceAFNDelegate>)delegate tag:(NSInteger)tag;

//POST
- (AFHTTPRequestOperation *)useManager_d:(AFHTTPRequestOperationManager *)manager postRequestUrl:(NSString *)Url params:(NSDictionary *)params delegate:(id<WebServiceAFNDelegate>)delegate;
- (AFHTTPRequestOperation *)useManager_d:(AFHTTPRequestOperationManager *)manager postRequestUrl:(NSString *)Url params:(NSDictionary *)params delegate:(id<WebServiceAFNDelegate>)delegate tag:(NSInteger)tag;

- (AFHTTPRequestOperation *)useManager_b:(AFHTTPRequestOperationManager *)manager
                        postRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)useManager_b:(AFHTTPRequestOperationManager *)manager
                        postRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                              useCache:(BOOL)useCache
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject, BOOL isCacheData))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error, BOOL isCacheData))failure;

//③POST_Request
- (AFHTTPRequestOperation *)requestUrl:(NSString *)Url params:(NSDictionary *)params delegate:(id<WebServiceAFNDelegate>)delegate;
- (AFHTTPRequestOperation *)requestUrl:(NSString *)Url params:(NSDictionary *)params delegate:(id<WebServiceAFNDelegate>)delegate tag:(NSInteger)tag;



@end

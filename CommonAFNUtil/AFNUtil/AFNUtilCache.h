//
//  AFNUtilCache.h
//  CommonAFNUtilDemo
//
//  Created by 李超前 on 15/11/22.
//  Copyright © 2015年 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface AFNUtilCache : NSObject

+ (AFHTTPRequestOperation *)useManager:(AFHTTPRequestOperationManager *)manager
                        postRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                              useCache:(BOOL)useCache
                               success:(void(^)(AFHTTPRequestOperation *operation, id responseObject, BOOL isCacheData))success
                               failure:(void(^)(AFHTTPRequestOperation *operation, NSString *failMesg, BOOL isCacheData))failure;

@end

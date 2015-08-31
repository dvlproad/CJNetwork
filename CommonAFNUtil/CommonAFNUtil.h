//
//  CommonAFNUtil.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceAFNDelegate.h"
/*
#import "NetworkManager.h"
由于AFN已有AFNetworkReachabilityManager，所以
①网络监听   [[NetworkManager sharedInstance] startNetworkeWatch:nil];
直接使用 --> [[AFNetworkReachabilityManager sharedManager] startMonitoring];
②网络可连   BOOL isNetworkEnabled = [NetworkManager sharedInstance].isNetworkEnabled;
直接使用 --> BOOL isNetworkEnabled = [AFNetworkReachabilityManager sharedManager].isReachable;
*/

#import <MBProgressHUD/MBProgressHUD.h>

#import <AFNetworking.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <AFNetworking/UIActivityIndicatorView+AFNetworking.h>   //UIActivityIndicatorView
#import <AFNetworking/UIImageView+AFNetworking.h>               //UIImage





@interface CommonAFNUtil : NSObject

//GET
+ (AFHTTPRequestOperation *)useManager:(AFHTTPRequestOperationManager *)manager
                         getRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                              delegate:(id<WebServiceAFNDelegate>)delegate
                                   tag:(NSInteger)tag;

//POST
+ (AFHTTPRequestOperation *)useManager:(AFHTTPRequestOperationManager *)manager
                        postRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                              delegate:(id<WebServiceAFNDelegate>)delegate
                                   tag:(NSInteger)tag;

+ (AFHTTPRequestOperation *)useManager:(AFHTTPRequestOperationManager *)manager
                        postRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (AFHTTPRequestOperation *)useManager:(AFHTTPRequestOperationManager *)manager
                        postRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                              useCache:(BOOL)useCache
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject, BOOL isCacheData))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error, BOOL isCacheData))failure;

//③POST_Request
+ (AFHTTPRequestOperation *)requestUrl:(NSString *)Url params:(NSDictionary *)params delegate:(id<WebServiceAFNDelegate>)delegate tag:(NSInteger)tag;
+ (NSMutableURLRequest *)URLRequest_Url:(NSString *)Url params:(NSDictionary *)params;

+ (void)checkVersionWithAPPID:(NSString *)appid success:(void(^)(BOOL isLastest, NSString *app_trackViewUrl))success failure:(void(^)(void))failure;

@end

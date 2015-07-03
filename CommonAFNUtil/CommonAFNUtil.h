//
//  CommonAFNUtil.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceAFNDelegate.h"

#import <AFNetworking/AFNetworking.h> //使用CocoaPod的时候得用尖括号引用头文件
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <AFNetworking/UIActivityIndicatorView+AFNetworking.h>   //UIActivityIndicatorView
#import <AFNetworking/UIImageView+AFNetworking.h>               //UIImage

#import <MBProgressHUD/MBProgressHUD.h>

@interface CommonAFNUtil : NSObject

+ (AFHTTPRequestOperationManager *)manager;
/*
+ (AFHTTPRequestOperation *)getRequestUrl:(NSString *)Url params:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
*/


//delegate方式
+ (AFHTTPRequestOperation *)getRequestUrl:(NSString *)Url params:(NSDictionary *)params delegate:(id<WebServiceAFNDelegate>)delegate;
+ (AFHTTPRequestOperation *)postRequestUrl:(NSString *)Url params:(NSDictionary *)params delegate:(id<WebServiceAFNDelegate>)delegate;
+ (AFHTTPRequestOperation *)getRequestUrl:(NSString *)Url params:(NSDictionary *)params delegate:(id<WebServiceAFNDelegate>)delegate tag:(NSInteger)tag;
+ (AFHTTPRequestOperation *)postRequestUrl:(NSString *)Url params:(NSDictionary *)params delegate:(id<WebServiceAFNDelegate>)delegate tag:(NSInteger)tag;

@end

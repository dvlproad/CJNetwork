//
//  CJRequestUtil.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 15/11/22.
//  Copyright © 2015年 dvlproad. All rights reserved.
//

#import "CJRequestUtil.h"
#import <CQNetworkPublic/CJRequestURLHelper.h>

@implementation CJRequestUtil

#pragma mark - POST请求
/* //详细的app中增加实现的通用方法的例子如下
+ (void)xx_postUrl:(NSString *)Url
            params:(id)params
           encrypt:(BOOL)encrypt
           success:(nullable void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo))success
           failure:(nullable void (^)(CJFailureRequestInfo * _Nullable failureRequestInfo))failure {
    
    NSData * (^encryptBlock)(NSDictionary *requestParmas) = ^NSData *(NSDictionary *requestParmas) {
        NSData *bodyData = [CJEncryptAndDecryptTool encryptParmas:params];//在详细的app中需要实现的方法
        return bodyData;
    };
    
    NSDictionary * (^decryptBlock)(NSString *responseString) = ^NSDictionary *(NSString *responseString) {
        NSDictionary *responseObject = [CJEncryptAndDecryptTool decryptJsonString:responseString];//在详细的app中需要实现的方法
        return responseObject;
    };
    
    [self cj_postUrl:Url params:params encrypt:encrypt encryptBlock:encryptBlock decryptBlock:decryptBlock logType:CJRequestLogTypeConsoleLog success:success failure:failure];
}
//*/


/* 完整的描述请参见文件头部 */
+ (NSURLSessionDataTask *)cj_postUrl:(NSString *)Url
                              params:(id)params
                             encrypt:(BOOL)encrypt
                        encryptBlock:(NSData * (^)(NSDictionary *requestParmas))encryptBlock
                        decryptBlock:(NSDictionary * (^)(NSString *responseString))decryptBlock
                             logType:(CJRequestLogType)logType
                             success:(nullable void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo))success
                             failure:(nullable void (^)(CJFailureRequestInfo * _Nullable failureRequestInfo))failure
{
    /* 利用Url和params，通过加密的方法创建请求 */
    NSData *bodyData = nil;
    if (encrypt && encryptBlock) {
        //bodyData = [CJEncryptAndDecryptTool encryptParmas:params];
        bodyData = encryptBlock(params);
    } else {
        bodyData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    }
    
    NSURL *URL = [NSURL URLWithString:Url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPBody:bodyData];
    [request setHTTPMethod:@"POST"];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *URLSessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            NSDictionary *recognizableResponseObject = nil; //可识别的responseObject,如果是加密的还要解密
            if (encrypt && decryptBlock) {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                //recognizableResponseObject = [CJEncryptAndDecryptTool decryptJsonString:responseString];
                recognizableResponseObject = decryptBlock(responseString);
                
            } else {
                NSError *jsonError = nil;
                recognizableResponseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            }
            
            //successNetworkLog
            CJSuccessRequestInfo *successRequestInfo = [CJSuccessRequestInfo successNetworkLogWithType:logType Url:Url params:params request:request responseObject:recognizableResponseObject];
            if (success) {
                success(successRequestInfo);
            }
            
        }
        else
        {
            //errorNetworkLog
            CJFailureRequestInfo *failureRequestInfo = [CJFailureRequestInfo errorNetworkLogWithType:logType Url:Url params:params request:request error:error URLResponse:response];
            if (failure) {
                failure(failureRequestInfo);
            }
        }
    }];
    [URLSessionDataTask resume];
    
    return URLSessionDataTask;
}



#pragma mark - GET请求
/* 完整的描述请参见文件头部 */
+ (void)cj_getUrl:(NSString *)Url
           params:(id)params
          logType:(CJRequestLogType)logType
          success:(nullable void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo))success
          failure:(nullable void (^)(CJFailureRequestInfo * _Nullable failureRequestInfo))failure
{
    NSString *fullUrlForGet = [CJRequestURLHelper connectRequestUrl:Url params:params];
    NSURL *URL = [NSURL URLWithString:fullUrlForGet];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"]; //此行可省略，因为默认就是GET方法，附Get方法没有body
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            NSError *jsonError = nil;
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            
            CJSuccessRequestInfo *successRequestInfo = [CJSuccessRequestInfo successNetworkLogWithType:logType Url:Url params:params request:request responseObject:responseObject];
            if (success) {
                success(successRequestInfo);
            }
        }
        else
        {
            //NSDictionary *responseObject = @{@"status":@(-1), @"message":@"网络异常"};
            CJFailureRequestInfo *failureRequestInfo = [CJFailureRequestInfo errorNetworkLogWithType:logType Url:Url params:params request:request error:error URLResponse:response];
            if (failure) {
                failure(failureRequestInfo);
            }
        }
    }];
    [task resume];
}



#pragma mark - 短链
/* 完整的描述请参见文件头部 */
+ (void)expandShortenedUrl:(NSString *)shortenedUrl
                   success:(void (^)(NSString *expandedUrl))success
                   failure:(void (^)(NSString *errorMessage))failure {
    NSURL *url = [NSURL URLWithString:shortenedUrl];
    if (!url) {
        return;
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            failure([NSString stringWithFormat:@"短链重定向/扩展失败: %@", error.localizedDescription]);
        } else if (response.URL) {
            // 获取扩展后的 URL
            NSString *expandedUrl = response.URL.absoluteString;
            success(expandedUrl);
        }
    }];
    
    [dataTask resume];
}

@end

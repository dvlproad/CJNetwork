//
//  AFHTTPSessionManager+CJEncrypt.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/6/13.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "AFHTTPSessionManager+CJEncrypt.h"
#import "CJNetworkErrorUtil.h"
#import "CJNetworkLogUtil.h"

@implementation AFHTTPSessionManager (CJEncrypt)

/* 完整的描述请参见文件头部 */
- (nullable NSURLSessionDataTask *)cj_getUrl:(nullable NSString *)Url
                                      params:(nullable NSDictionary *)params
                                    progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                     success:(nullable void (^)(NSDictionary *_Nullable responseObject))success
                                     failure:(nullable void (^)(NSError * _Nullable error))failure
{
    NSLog(@"Url = %@", Url);
    NSLog(@"params = %@", params);
    
    NSURLSessionDataTask *dataTask =
    [self GET:Url parameters:params progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        //successNetworkLog
        id newResponseObject =
        [CJNetworkLogUtil printSuccessNetworkLogWithUrl:Url params:params responseObject:responseDict];
        
        if (success) {
            success(newResponseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //errorNetworkLog
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSError *newError = [CJNetworkLogUtil printErrorNetworkLogWithUrl:Url params:params error:error URLResponse:response];
        
        if (failure) {
            failure(newError);
        }
    }];
    
    return dataTask;
}



/** 完整的描述请参见文件头部 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                                      encrypt:(BOOL)encrypt
                                 encryptBlock:(nullable NSData * _Nullable (^)(NSDictionary * _Nullable requestParmas))encryptBlock
                                 decryptBlock:(nullable NSDictionary * _Nullable (^)(NSString * _Nullable responseString))decryptBlock
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                      success:(nullable void (^)(NSDictionary *_Nullable responseObject))success
                                      failure:(nullable void (^)(NSError * _Nullable error))failure
{
    NSURLSessionDataTask *URLSessionDataTask =
    [self POST:Url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *recognizableResponseObject = nil; //可识别的responseObject,如果是加密的还要解密
        if (encrypt && decryptBlock) {
            NSString *responseString = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
            
            //recognizableResponseObject = [CJEncryptAndDecryptTool decryptJsonString:responseString];
            recognizableResponseObject = decryptBlock(responseString);
            
        } else {
            if ([NSJSONSerialization isValidJSONObject:responseObject]) {
                recognizableResponseObject = responseObject;
            } else {
                recognizableResponseObject = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:nil];
            }
        }
        
        //successNetworkLog
        id newResponseObject =
        [CJNetworkLogUtil printSuccessNetworkLogWithUrl:Url params:params responseObject:recognizableResponseObject];
        
        if (success) {
            success(newResponseObject);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSURLResponse *response = task.response;
        //errorNetworkLog
        NSError *newError = [CJNetworkLogUtil printErrorNetworkLogWithUrl:Url params:params error:error URLResponse:response];
        
        if (failure) {
            failure(newError);
        }
    }];
    
    return URLSessionDataTask;
}



@end

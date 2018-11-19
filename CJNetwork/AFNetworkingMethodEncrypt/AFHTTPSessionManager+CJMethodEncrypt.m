//
//  AFHTTPSessionManager+CJMethodEncrypt.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "AFHTTPSessionManager+CJMethodEncrypt.h"

//typedef NS_OPTIONS(NSUInteger, CJNeedGetCacheOption) {
//    CJNeedGetCacheOptionNone = 1 << 0,             /**< 不缓存 */
//    CJNeedGetCacheOptionNetworkUnable = 1 << 1,    /**< 无网 */
//    CJNeedGetCacheOptionRequestFailure = 1 << 2,   /**< 有网，但是请求地址或者服务器错误等 */
//};


@implementation AFHTTPSessionManager (CJMethodEncrypt)

#pragma mark - CJCacheEncrypt
/** 完整的描述请参见文件头部 */
- (nullable NSURLSessionDataTask *)cjMethodEncrypt_postUrl:(nullable NSString *)Url
                                            params:(nullable id)params
                                      settingModel:(CJRequestSettingModel *)settingModel
                                           encrypt:(BOOL)encrypt
                                      encryptBlock:(nullable NSData * _Nullable (^)(NSDictionary * _Nullable requestParmas))encryptBlock
                                      decryptBlock:(nullable NSDictionary * _Nullable (^)(NSString * _Nullable responseString))decryptBlock
                                           success:(nullable void (^)(CJSuccessNetworkInfo * _Nullable successNetworkInfo))success
                                           failure:(nullable void (^)(CJFailureNetworkInfo * _Nullable failureNetworkInfo))failure
{
    /* 利用Url和params，通过加密的方法创建请求 */
    NSData *bodyData = nil;
    if (params) {
        if (encrypt && encryptBlock) {
            //bodyData = [CJEncryptAndDecryptTool encryptParmas:params];
            bodyData = encryptBlock(params);
        } else {
            bodyData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        }
    }
    
    //正确的方法：
    NSURL *URL = [NSURL URLWithString:Url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPBody:bodyData];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *URLSessionDataTask =
    [self dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error == nil) {
            NSDictionary *recognizableResponseObject = nil; //可识别的responseObject,如果是加密的还要解密
            if (encrypt && decryptBlock) {
                NSString *responseString = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
                
                //recognizableResponseObject = [CJEncryptAndDecryptTool decryptJsonString:responseString];
                recognizableResponseObject = decryptBlock(responseString);
            } else {
                recognizableResponseObject = responseObject;
            }
            
            [self __didRequestSuccessForTask:URLSessionDataTask withResponseObject:recognizableResponseObject isCacheData:YES forUrl:Url params:params settingModel:settingModel success:success];
            
        }
        else
        {
            [self __didRequestFailureForTask:URLSessionDataTask withResponseError:error forUrl:Url params:params settingModel:settingModel failure:failure];
        }
    }];
    [URLSessionDataTask resume];
    
    return URLSessionDataTask;
    
//    //可自己尝试下以下方面是否OK
//    NSURLSessionDataTask *URLSessionDataTask =
//    [self POST:Url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
//    return URLSessionDataTask;
    
    /*
    //不知为什么无效的方法：
    NSURLSessionDataTask *URLSessionDataTask =
    [self POST:Url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:bodyData name:@"json"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *recognizableResponseObject = nil; //可识别的responseObject,如果是加密的还要解密
        if (encrypt && decryptBlock) {
            NSString *responseString = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
            
            //recognizableResponseObject = [CJEncryptAndDecryptTool decryptJsonString:responseString];
            recognizableResponseObject = decryptBlock(responseString);
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
    //*/
}

@end

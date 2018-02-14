//
//  AFHTTPSessionManager+CJEncrypt.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/6/13.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "AFHTTPSessionManager+CJEncrypt.h"
#import "CJRequestErrorMessageUtil.h"

@implementation AFHTTPSessionManager (CJEncrypt)

/** 完整的描述请参见文件头部 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(NSString *)Url
                                       params:(id)params
                                      encrypt:(BOOL)encrypt
                                 encryptBlock:(NSData * (^)(NSDictionary *requestParmas))encryptBlock
                                 decryptBlock:(NSDictionary * (^)(NSString *responseString))decryptBlock
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                      success:(void (^)(NSDictionary *responseObject))success
                                      failure:(void (^)(NSError *error))failure
{
    //将传给服务器的参数用字符串打印出来
    NSString *allParamsJsonString = nil;
    if ([NSJSONSerialization isValidJSONObject:params]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
        allParamsJsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    //NSLog(@"传给服务器的json参数:%@", allParamsJsonString);
    
    /* 利用Url和params，通过加密的方法创建请求 */
    NSData *bodyData = nil;
    if (encrypt && encryptBlock) {
        //bodyData = [CJEncryptAndDecryptTool encryptParmas:params];
        bodyData = encryptBlock(params);
    } else {
        bodyData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    }
    
    //正确的方法：
    NSURL *URL = [NSURL URLWithString:Url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPBody:bodyData];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *task =
    [self dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error == nil) {
            NSData *data = responseObject;
            NSDictionary *recognizableResponseObject = nil; //可识别的responseObject,如果是加密的还要解密
            if (encrypt && decryptBlock) {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                //recognizableResponseObject = [CJEncryptAndDecryptTool decryptJsonString:responseString];
                recognizableResponseObject = decryptBlock(responseString);
                
            } else {
                recognizableResponseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            }
            
            NSLog(@"\n\n  >>>>>>>>>>>>  网络请求Start  >>>>>>>>>>>>  \n地址：%@ \n参数：%@ \n结果：%@ \n\n传给服务器的json参数:%@ \n  <<<<<<<<<<<<<  网络请求End  <<<<<<<<<<<<<  \n\n\n", Url, params, recognizableResponseObject, allParamsJsonString);
            
            if (success) {
                success(recognizableResponseObject);
            }
        }
        else
        {
            if (failure) {
                failure(error);
            }
            
            NSString *errorMessage = [CJRequestErrorMessageUtil getErrorMessageFromHTTPURLResponse:response];
            NSLog(@"\n\n  >>>>>>>>>>>>  网络请求Start  >>>>>>>>>>>>  \n地址：%@ \n参数：%@ \n结果：%@ \n\n传给服务器的json参数:%@ \n  <<<<<<<<<<<<<  网络请求End  <<<<<<<<<<<<<  \n\n\n", Url, params, errorMessage, allParamsJsonString);
        }
    }];
    [task resume];
    
    return task;

    /*
    //不知为什么无效的方法：
    NSURLSessionDataTask *URLSessionDataTask =
    [self POST:Url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:bodyData name:@"json"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *recognizableResponseObject = nil; //可识别的responseObject,如果是加密的还要解密
        if (encrypt && decryptBlock) {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            //responseDictionary = [CJEncryptAndDecryptTool decryptJsonString:responseString];
            recognizableResponseObject = decryptBlock(responseString);
            
        } else {
            recognizableResponseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        }
        
        NSLog(@"\n\n  >>>>>>>>>>>>  网络请求Start  >>>>>>>>>>>>  \n地址：%@ \n参数：%@ \n结果：%@ \n\n传给服务器的json参数:%@ \n  <<<<<<<<<<<<<  网络请求End  <<<<<<<<<<<<<  \n\n\n", Url, params, recognizableResponseObject, allParamsJsonString);
        
        if (success) {
            success(recognizableResponseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSDictionary *responseDictionary = @{@"status":@(-1), @"message":@"网络异常"};
        if (failure) {
            failure(error);
        }
        
        NSString *errorMessage = error.localizedDescription;
        NSLog(@"\n\n  >>>>>>>>>>>>  网络请求Start  >>>>>>>>>>>>  \n地址：%@ \n参数：%@ \n结果：%@ \n\n传给服务器的json参数:%@ \n  <<<<<<<<<<<<<  网络请求End  <<<<<<<<<<<<<  \n\n\n", Url, params, errorMessage, allParamsJsonString);
        
    }];
    return URLSessionDataTask;
    //*/
}


@end

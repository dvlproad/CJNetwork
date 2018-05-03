//
//  AFHTTPSessionManager+CJCacheRequest.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "AFHTTPSessionManager+CJCacheRequest.h"

#import "CJRequestErrorMessageUtil.h"

@implementation AFHTTPSessionManager (CJCacheRequest)

#pragma mark - CJCache
/** 完整的描述请参见文件头部 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                         currentNetworkStatus:(BOOL)isNetworkEnabled
                                        cache:(BOOL)cache
                                      success:(nullable void (^)(NSDictionary *_Nullable responseObject, BOOL isCacheData))success
                                      failure:(nullable void (^)(NSError * _Nullable error))failure
{
    CJNeedGetCacheOption cacheOption = CJNeedGetCacheOptionNetworkUnable | CJNeedGetCacheOptionRequestFailure;
    NSURLSessionDataTask *URLSessionDataTask = [self cj_postUrl:Url
                                                         params:params
                                           currentNetworkStatus:isNetworkEnabled
                                                    cacheOption:cacheOption
                                                       progress:nil
                                                        success:success
                                                        failure:failure];
    return URLSessionDataTask;
    
}


/**
 *  发起请求
 *
 *  @param Url              Url
 *  @param params           params
 *  @param isNetworkEnabled 当前的网络状态是否可用
 *  @param cacheOption      需要缓存网络数据的情况(如果有缓存，则即代表可以从缓存中获取数据)
 *  @param uploadProgress   uploadProgress
 *  @param success          请求成功的回调success
 *  @param failure          请求失败的回调failure
 *
 *  return NSURLSessionDataTask
 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                         currentNetworkStatus:(BOOL)isNetworkEnabled
                                  cacheOption:(CJNeedGetCacheOption)cacheOption
                                 //encacheBlock:(nullable NSData * _Nullable (^)(NSDictionary * _Nullable requestParmas))encacheBlock
                                 //decacheBlock:(nullable NSDictionary * _Nullable (^)(NSString * _Nullable responseString))decacheBlock
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                      success:(nullable void (^)(NSDictionary *_Nullable responseObject, BOOL isCacheData))success
                                      failure:(nullable void (^)(NSError * _Nullable error))failure
{
    //将传给服务器的参数用字符串打印出来
    NSString *allParamsJsonString = nil;
    if ([NSJSONSerialization isValidJSONObject:params]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
        allParamsJsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    //NSLog(@"传给服务器的json参数:%@", allParamsJsonString);
    
    if (isNetworkEnabled == NO) {
        /* 网络不可用，读取本地缓存数据 */
        NSString *cjErrorMeesage = NSLocalizedString(@"网络不给力", nil);
        NSError *error = nil;
        BOOL shouldGetCache = cacheOption | CJNeedGetCacheOptionNetworkUnable; //无网，网络不可用的情况下有用到缓存
        [self didRequestFailureWithResponseError:error
                                  cjErrorMeesage:cjErrorMeesage
                                          forUrl:Url
                                          params:params
                                  shouldGetCache:shouldGetCache
                                         encrypt:NO
                                    encryptBlock:nil
                                    decryptBlock:nil
                                         success:success
                                         failure:failure];
        
        return nil;
    }
    
    
    
    /* 网络可用，直接下载数据，并根据是否需要缓存来进行缓存操作 */
    NSURLSessionDataTask *URLSessionDataTask = [self POST:Url parameters:params progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self didRequestSuccessWithResponseObject:responseObject
                                           forUrl:Url
                                           params:params
                                      cacheOption:cacheOption
                                          encrypt:NO
                                     encryptBlock:nil
                                     decryptBlock:nil
                                          success:success];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *cjErrorMeesage = [CJRequestErrorMessageUtil getErrorMessageFromURLSessionTask:task];
        BOOL shouldGetCache = cacheOption | CJNeedGetCacheOptionRequestFailure;//有网，但是请求地址或者服务器错误等
        [self didRequestFailureWithResponseError:error
                                  cjErrorMeesage:cjErrorMeesage
                                          forUrl:Url
                                          params:params
                                  shouldGetCache:shouldGetCache
                                         encrypt:NO
                                    encryptBlock:nil
                                    decryptBlock:nil
                                         success:success
                                         failure:failure];
        
    }];
    
    return URLSessionDataTask;
}





#pragma mark - CJCacheEncrypt
/** 完整的描述请参见文件头部 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                         currentNetworkStatus:(BOOL)isNetworkEnabled
                                        cache:(BOOL)cache
                                      encrypt:(BOOL)encrypt
                                 encryptBlock:(NSData * (^)(NSDictionary *requestParmas))encryptBlock
                                 decryptBlock:(NSDictionary * (^)(NSString *responseString))decryptBlock
                                      success:(nullable void (^)(NSDictionary *_Nullable responseObject, BOOL isCacheData))success
                                      failure:(nullable void (^)(NSError * _Nullable error))failure
{
    CJNeedGetCacheOption cacheOption = CJNeedGetCacheOptionNetworkUnable | CJNeedGetCacheOptionRequestFailure;
    NSURLSessionDataTask *URLSessionDataTask = [self cj_postUrl:Url
                                                         params:params
                                           currentNetworkStatus:isNetworkEnabled
                                                    cacheOption:cacheOption
                                                        encrypt:encrypt
                                                   encryptBlock:encryptBlock
                                                   decryptBlock:decryptBlock
                                                       progress:nil
                                                        success:success
                                                        failure:failure];
    return URLSessionDataTask;
    
}


/**
 *  发起请求
 *
 *  @param Url              Url
 *  @param params           params
 *  @param isNetworkEnabled 当前的网络状态是否可用
 *  @param cacheOption      需要缓存网络数据的情况(如果有缓存，则即代表可以从缓存中获取数据)
 *  @param encrypt          是否加密
 *  @param encryptBlock     对请求的参数requestParmas加密的方法
 *  @param decryptBlock     对请求得到的responseString解密的方法
 *  @param uploadProgress   uploadProgress
 *  @param success          请求成功的回调success
 *  @param failure          请求失败的回调failure
 *
 *  return NSURLSessionDataTask
 */
- (nullable NSURLSessionDataTask *)cj_postUrl:(nullable NSString *)Url
                                       params:(nullable id)params
                         currentNetworkStatus:(BOOL)isNetworkEnabled
                                  cacheOption:(CJNeedGetCacheOption)cacheOption
                                //encacheBlock:(nullable NSData * _Nullable (^)(NSDictionary * _Nullable requestParmas))encacheBlock
                                //decacheBlock:(nullable NSDictionary * _Nullable (^)(NSString * _Nullable responseString))decacheBlock
                                      encrypt:(BOOL)encrypt
                                 encryptBlock:(NSData * (^)(NSDictionary *requestParmas))encryptBlock
                                 decryptBlock:(NSDictionary * (^)(NSString *responseString))decryptBlock
                                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                      success:(nullable void (^)(NSDictionary *_Nullable responseObject, BOOL isCacheData))success
                                      failure:(nullable void (^)(NSError * _Nullable error))failure
{
    //将传给服务器的参数用字符串打印出来
    NSString *allParamsJsonString = nil;
    if ([NSJSONSerialization isValidJSONObject:params]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
        allParamsJsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    //NSLog(@"传给服务器的json参数:%@", allParamsJsonString);
    
    if (isNetworkEnabled == NO) {
        /* 网络不可用，读取本地缓存数据 */
        NSString *cjErrorMeesage = NSLocalizedString(@"网络不给力", nil);
        NSError *error = nil;
        BOOL shouldGetCache = cacheOption | CJNeedGetCacheOptionNetworkUnable; //无网，网络不可用的情况下有用到缓存
        [self didRequestFailureWithResponseError:error
                                  cjErrorMeesage:cjErrorMeesage
                                          forUrl:Url
                                          params:params
                                  shouldGetCache:shouldGetCache
                                         encrypt:encrypt
                                    encryptBlock:encryptBlock
                                    decryptBlock:decryptBlock
                                         success:success
                                         failure:failure];
        
        return nil;
    }
    
    
    /* 网络可用，直接下载数据，并根据是否需要缓存来进行缓存操作 */
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
            [self didRequestSuccessWithResponseObject:responseObject
                                               forUrl:Url
                                               params:params
                                          cacheOption:cacheOption
                                              encrypt:encrypt
                                         encryptBlock:encryptBlock
                                         decryptBlock:decryptBlock
                                              success:success];
        }
        else
        {
            NSString *cjErrorMeesage = [CJRequestErrorMessageUtil getErrorMessageFromURLResponse:response];
            BOOL shouldGetCache = cacheOption | CJNeedGetCacheOptionRequestFailure;//有网，但是请求地址或者服务器错误等
            [self didRequestFailureWithResponseError:error
                                      cjErrorMeesage:cjErrorMeesage
                                              forUrl:Url
                                              params:params
                                      shouldGetCache:shouldGetCache
                                             encrypt:encrypt
                                        encryptBlock:encryptBlock
                                        decryptBlock:decryptBlock
                                             success:success
                                             failure:failure];
        }
    }];
    [task resume];
    
    return task;
}







#pragma mark - Private
- (void)didRequestSuccessWithResponseObject:(nullable id)responseObject
                                     forUrl:(nullable NSString *)Url
                                     params:(nullable id)params
                                cacheOption:(CJNeedGetCacheOption)cacheOption
                                    encrypt:(BOOL)encrypt
                               encryptBlock:(nullable NSData * _Nullable (^)(NSDictionary * _Nullable requestParmas))encryptBlock
                               decryptBlock:(nullable NSDictionary * _Nullable (^)(NSString * _Nullable responseString))decryptBlock
                                    success:(nullable void (^)(NSDictionary *_Nullable responseObject, BOOL isCacheData))success
{
    //将传给服务器的参数用字符串打印出来
    NSString *allParamsJsonString = nil;
    if ([NSJSONSerialization isValidJSONObject:params]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
        allParamsJsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    //NSLog(@"传给服务器的json参数:%@", allParamsJsonString);
    
    
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
        success(recognizableResponseObject, NO);//有网络的时候,responseObject等就不是来源磁盘(缓存),故为NO
    }
    
    BOOL shouldCache = cacheOption | CJNeedGetCacheOptionNetworkUnable | CJNeedGetCacheOptionRequestFailure; //是否需要本地缓存现在请求下来的网络数据
    if (shouldCache) {
        [CJRequestCacheDataUtil cacheNetworkData:responseObject byRequestUrl:Url parameters:params];
    }
}

- (void)didRequestFailureWithResponseError:(NSError * _Nullable)error
                              cjErrorMeesage:(nullable NSString *)cjErrorMeesage
                                     forUrl:(nullable NSString *)Url
                                     params:(nullable id)params
                            shouldGetCache:(BOOL)shouldGetCache
                                    encrypt:(BOOL)encrypt
                               encryptBlock:(nullable NSData * _Nullable (^)(NSDictionary * _Nullable requestParmas))encryptBlock
                               decryptBlock:(nullable NSDictionary * _Nullable (^)(NSString * _Nullable responseString))decryptBlock
                                   success:(nullable void (^)(NSDictionary *_Nullable responseObject, BOOL isCacheData))success
                                    failure:(nullable void (^)(NSError * _Nullable error))failure
{
    //将传给服务器的参数用字符串打印出来
    NSString *allParamsJsonString = nil;
    if ([NSJSONSerialization isValidJSONObject:params]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
        allParamsJsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    //NSLog(@"传给服务器的json参数:%@", allParamsJsonString);
    
    if (shouldGetCache) {
        [CJRequestCacheDataUtil requestCacheDataByUrl:Url params:params success:^(NSDictionary * _Nullable responseObject) {
            //NSDictionary *recognizableResponseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *recognizableResponseObject = responseObject;
            NSLog(@"\n\n  >>>>>>>>>>>>  网络请求Start  >>>>>>>>>>>>  \n地址：%@ \n参数：%@ \n结果：%@ \n\n传给服务器的json参数:%@ \n  <<<<<<<<<<<<<  网络请求End  <<<<<<<<<<<<<  \n\n\n", Url, params, recognizableResponseObject, allParamsJsonString);
            
            if (success) {
                success(recognizableResponseObject, YES);
            }
        } failure:^(CJRequestCacheFailureType failureType) {
            //从服务器请求不到数据，连从缓存中也都取不到
            if (failure) {
                NSError *newError = [CJRequestErrorMessageUtil getNewErrorWithError:error cjErrorMeesage:cjErrorMeesage];
                NSLog(@"\n\n  >>>>>>>>>>>>  网络请求Start  >>>>>>>>>>>>  \n地址：%@ \n参数：%@ \n结果：%@ \n\n传给服务器的json参数:%@ \n  <<<<<<<<<<<<<  网络请求End  <<<<<<<<<<<<<  \n\n\n", Url, params, cjErrorMeesage, allParamsJsonString);
                
                if (failure == CJRequestCacheFailureTypeCacheKeyNil) {
                    failure(newError);
                } else {
                    failure(newError);
                }
                
            }
        }];
        
    } else {
        NSLog(@"提示：这里之前未缓存，无法读取缓存，提示网络不给力");
        NSError *newError = [CJRequestErrorMessageUtil getNewErrorWithError:error cjErrorMeesage:cjErrorMeesage];
        NSLog(@"\n\n  >>>>>>>>>>>>  网络请求Start  >>>>>>>>>>>>  \n地址：%@ \n参数：%@ \n结果：%@ \n\n传给服务器的json参数:%@ \n  <<<<<<<<<<<<<  网络请求End  <<<<<<<<<<<<<  \n\n\n", Url, params, cjErrorMeesage, allParamsJsonString);
        
        if (failure) {
            failure(newError);
        }
    }
}


@end

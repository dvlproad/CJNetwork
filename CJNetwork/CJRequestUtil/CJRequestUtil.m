//
//  CJRequestUtil.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 15/11/22.
//  Copyright © 2015年 ciyouzen. All rights reserved.
//

#import "CJRequestUtil.h"

@implementation CJRequestUtil

/* //TODO:详细的app中需要进一步实现的通用方法
+ (void)cj_postUrl:(NSString *)Url
            params:(id)params
           encrypt:(BOOL)encrypt
           success:(void (^)(NSDictionary *responseObject))success
           failure:(void (^)(NSError *error))failure {
    
    NSData * (^encryptBlock)(NSDictionary *requestParmas) = ^NSData *(NSDictionary *requestParmas) {
        //TODO:详细的app中需要实现的方法
        NSData *bodyData = nil;
        return bodyData;
    };
    
    NSDictionary * (^decryptBlock)(NSString *responseString) = ^NSDictionary *(NSString *responseString) {
        //TODO:详细的app中需要实现的方法
        NSDictionary *responseObject = nil;
        return responseObject;
    };
    
    [self cj_postUrl:Url params:params encryptBlock:encryptBlock decryptBlock:decryptBlock success:success failure:failure];
}
*/

/**
 *  发起请求
 *
 *  @param Url          Url
 *  @param params       params
 *  @param encryptBlock 对请求的参数requestParmas加密的方法
 *  @param decryptBlock 对请求得到的responseString解密的方法
 *  @param success      请求成功的回调failure
 *  @param failure      请求失败的回调failure
 */
+ (void)cj_postUrl:(NSString *)Url
            params:(id)params
      encryptBlock:(NSData * (^)(NSDictionary *requestParmas))encryptBlock
      decryptBlock:(NSDictionary * (^)(NSString *responseString))decryptBlock
           success:(void (^)(NSDictionary *responseObject))success
           failure:(void (^)(NSError *error))failure
{
    NSURL *URL = [NSURL URLWithString:Url];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *bodyData = nil;
    if (encryptBlock) {
        //bodyData = [CJEncryptAndDecryptTool encryptParmas:params];
        bodyData = encryptBlock(params);
        
    } else {
        bodyData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    }
    [request setHTTPBody:bodyData];
    [request setHTTPMethod:@"POST"];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            NSDictionary *responseObject = nil;
            if (decryptBlock) {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                //responseObject = [CJEncryptAndDecryptTool decryptJsonString:responseString];
                responseObject = decryptBlock(responseString);
                
            } else {
                responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            }
            
            NSLog(@"NetworkClient：%@请求到的结果为responseObject = %@", Url, responseObject);
            if (success) {
                success(responseObject);
            }
        }
        else
        {
            //NSDictionary *responseObject = @{@"status":@(-1), @"message":@"网络异常"};
            if (failure) {
                failure(error);
            }
        }
    }];
    [task resume];
}




/**
 *  连接请求的参数，返回连接后所形成的字符串
 *
 *  @param requestParams 请求的参数
 *
 *  @return 连接后所形成的字符串
 */
+ (NSString *)connectRequestParams:(NSDictionary *)requestParams {
    NSMutableString *requestString = [NSMutableString new];
    for (NSString *key in [requestParams allKeys]) {
        id obj = [requestParams valueForKey:key];
        if ([obj isKindOfClass:[NSString class]]) {
            if (requestString.length!=0) {
                [requestString appendString:@"&"];
            }
            [requestString appendFormat:@"%@=%@",key,obj];
        }
        if ([obj isKindOfClass:[NSArray class]]) {
            for (NSString *value in obj) {
                if (requestString.length!=0) {
                    [requestString appendString:@"&"];
                }
                [requestString appendFormat:@"%@=%@",key,value];
            }
        }
    }
    
    return requestString;
}



@end

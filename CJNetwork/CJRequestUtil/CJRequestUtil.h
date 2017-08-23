//
//  CJRequestUtil.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 15/11/22.
//  Copyright © 2015年 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJRequestUtil : NSObject

/*
//TODO:详细的app中需要进一步实现的通用方法(详细的看.m文件)
+ (void)cj_postUrl:(NSString *)Url
            params:(id)params
           encrypt:(BOOL)encrypt
           success:(void (^)(NSDictionary *responseObject))success
           failure:(void (^)(NSError *error))failure;
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
           failure:(void (^)(NSError *error))failure;


@end

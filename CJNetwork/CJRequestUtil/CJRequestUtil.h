//
//  CJRequestUtil.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 15/11/22.
//  Copyright © 2015年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  系统的请求方法
 */
@interface CJRequestUtil : NSObject

#pragma mark - POST请求
/*
//TODO:在详细的app中需要进一步实现的通用方法(详细的看.m文件)
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
 *  @param encrypt      是否加密
 *  @param encryptBlock 对请求的参数requestParmas加密的方法
 *  @param decryptBlock 对请求得到的responseString解密的方法
 *  @param success      请求成功的回调failure
 *  @param failure      请求失败的回调failure
 *
 *  @return 请求的task
 */
+ (NSURLSessionDataTask *)cj_postUrl:(NSString *)Url
                              params:(id)params
                             encrypt:(BOOL)encrypt
                        encryptBlock:(NSData * (^)(NSDictionary *requestParmas))encryptBlock
                        decryptBlock:(NSDictionary * (^)(NSString *responseString))decryptBlock
                             success:(void (^)(NSDictionary *responseObject))success
                             failure:(void (^)(NSError *error))failure;





#pragma mark - GET请求
/**
 *  发起GET请求
 *
 *  @param Url          Url
 *  @param params       params
 *  @param success      请求成功的回调failure
 *  @param failure      请求失败的回调failure
 */
+ (void)cj_getUrl:(NSString *)Url
           params:(id)params
          success:(void (^)(NSDictionary *responseObject))success
          failure:(void (^)(NSError *error))failure;


@end

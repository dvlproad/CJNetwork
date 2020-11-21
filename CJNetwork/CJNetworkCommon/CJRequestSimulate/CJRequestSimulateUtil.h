//
//  CJRequestSimulateUtil.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/4/8.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJRequestSimulateUtil : NSObject

#pragma mark - remoteSimulateApi
/**
 *  获取模拟接口的完整模拟Url(如果接口名包含域名了，则直接使用接口名)
 *
 *  @param simulateDomain   设置模拟接口所在的域名(若未设置则将使用http://localhost/+类名作为域名)
 *  @param apiSuffix        接口名(如果接口名包含域名了，则直接使用接口名)
 *
 *  return  模拟接口的完整模拟Url
 */
+ (NSString *)remoteSimulateUrlWithDomain:(NSString *)simulateDomain apiSuffix:(NSString *)apiSuffix;

#pragma mark - localSimulateApi
/*
 *  开始本地模拟接口请求
 *
 *  @param apiSuffix        api文件的本地路径(可以不带.json，也可以带)
 *  @param completeBlock    获取到数据的回调
 */
+ (void)localSimulateApi:(NSString *)apiSuffix completeBlock:(void (^)(NSDictionary *responseDictionary))completeBlock;

NS_ASSUME_NONNULL_END

@end

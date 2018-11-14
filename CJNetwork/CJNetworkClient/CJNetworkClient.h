//
//  CJNetworkClient.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  其他NetworkClient可通过本CJNetworkClient继承，也可自己再实现

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager+CJEncrypt.h"

@interface CJNetworkClient : NSObject {
    
}
@property (nonatomic, copy) NSString *simulateDomain;   /**< 设置模拟接口所在的域名，当需要使用远程模拟的时候才需要设置(且若未设置则将使用http://localhost/+类名作为域名) */

+ (instancetype)sharedInstance;

#pragma mark - remoteSimulateApi
/// 只获取模拟接口的完整模拟Url
- (NSString *)cjGetRemoteSimulateUrlWithApiSuffix:(NSString *)apiSuffix;

#pragma mark - localSimulateApi
/// 开始本地模拟接口请求
- (void)cjLocalSimulateApi:(NSString *)apiSuffix completeBlock:(void (^)(NSDictionary *responseDictionary))completeBlock;

@end

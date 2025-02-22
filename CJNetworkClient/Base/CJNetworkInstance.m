//
//  CJNetworkInstance.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJNetworkInstance.h"
#import <objc/runtime.h>
#import <CQNetworkPublic/CJRequestURLHelper.h>

@interface CJNetworkInstance () {
    
}

@end



@implementation CJNetworkInstance

/*
#pragma mark - 单例
+ (instancetype)sharedInstance {
    id sharedInstance = objc_getAssociatedObject(self, @"cjNetworkClientSharedInstance");
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL] init];
        objc_setAssociatedObject(self, @"cjNetworkClientSharedInstance", sharedInstance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[self class] sharedInstance];
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        __weak typeof(self)weakSelf = self;
        _completeFullUrlBlock = ^NSString *(NSString *baseUrl, NSString *apiSuffix) {
            return [CJRequestURLHelper requestUrlWithBaseUrl:baseUrl apiSuffix:apiSuffix];
        };
        
        _completeAllParamsBlock = ^NSDictionary *(NSDictionary *customParams) {
            NSMutableDictionary *allParams = [[NSMutableDictionary alloc] init];
            if (weakSelf.commonParams) {
                [allParams addEntriesFromDictionary:weakSelf.commonParams];
            }
            if (customParams) {
                [allParams addEntriesFromDictionary:customParams];
            }
            return allParams;
            //return [environmentManager completeParamsWithCustomParams:customParams];
        };
    }
    return self;
}

#pragma mark - 设置
// 必须实现：执行请求的Manager(一定要执行)
- (void)setupCleanHTTPSessionManager:(AFHTTPSessionManager *)cleanHTTPSessionManager
             cryptHTTPSessionManager:(AFHTTPSessionManager *)cryptHTTPSessionManager
{
    NSAssert(cleanHTTPSessionManager || cryptHTTPSessionManager, @"不加密和加密的不可以同时都没有");
    _cleanHTTPSessionManager = cleanHTTPSessionManager;
    _cryptHTTPSessionManager = cryptHTTPSessionManager;
}

/*
- (void)setupHTTPSessionManager:(AFHTTPSessionManager *)httpSessionManager cryptWithParamsEncryptHandle:(NSDictionary * _Nonnull (^)(id _Nonnull))paramsCryptHandle responseDataDecryptHandle:(id  _Nonnull (^)(id _Nonnull))responseDataDecryptHandle
{
    _httpSessionManager = httpSessionManager;
    _paramsCryptHandle = paramsCryptHandle;
    _responseDataDecryptHandle = responseDataDecryptHandle;
}
//*/


@end

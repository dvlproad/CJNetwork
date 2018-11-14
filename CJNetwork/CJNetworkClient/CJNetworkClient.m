//
//  CJNetworkClient.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJNetworkClient.h"
#import <objc/runtime.h>

@implementation CJNetworkClient

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

#pragma mark - remoteSimulateApi
/// 只获取模拟接口的完整模拟Url
- (NSString *)cjGetRemoteSimulateUrlWithApiSuffix:(NSString *)apiSuffix
{
    if (!self.simulateDomain || self.simulateDomain.length == 0) {
        self.simulateDomain = [@"http://localhost/" stringByAppendingString:NSStringFromClass([self class])];
    }
    NSString *Url = [self.simulateDomain stringByAppendingString:apiSuffix];
    return Url;
}

#pragma mark - localSimulateApi
/// 开始本地模拟接口请求
- (void)cjLocalSimulateApi:(NSString *)apiSuffix completeBlock:(void (^)(NSDictionary *responseDictionary))completeBlock
{
    if ([apiSuffix hasPrefix:@"/"]) {
        apiSuffix = [apiSuffix substringFromIndex:1];
    }
    NSString *jsonName = [apiSuffix stringByReplacingOccurrencesOfString:@"/" withString:@":"];
    NSData *responseObject = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:jsonName ofType:nil]];
    
    NSDictionary *recognizableResponseObject = nil;
    //if ([NSJSONSerialization isValidJSONObject:responseObject]) {
    //    recognizableResponseObject = responseObject;
    //} else {
    recognizableResponseObject = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:nil];
    //}
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *responseDictionary = recognizableResponseObject;
        if (completeBlock) {
            completeBlock(responseDictionary);
        }
    });
}



@end

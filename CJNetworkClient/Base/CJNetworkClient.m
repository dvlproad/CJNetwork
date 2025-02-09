//
//  CJNetworkClient.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJNetworkClient.h"

@interface CJNetworkClient () {
    
}

@end



@implementation CJNetworkClient

/*
 *  设置服务器返回值的各种处理方法(一定要执行)
 *
 *  @param getSuccessResponseModelBlock 将"网络请求成功返回的数据responseObject"转换为"模型"的方法
 *  @param checkIsCommonFailureBlock    在"网络请求成功并转换为模型"后判断其是否是"异地登录"等共同错误并在此对共同错误做处理(可为nil)
 *  @param getFailureResponseModelBlock 将"网络请求失败返回的数据error"转换为"模型"的方法
 */
- (void)setupGetSuccessResponseModelBlock:(CJNetworkClientGetSuccessResponseModelBlock)getSuccessResponseModelBlock
                checkIsCommonFailureBlock:(BOOL(^)(CJResponseModel *responseModel))checkIsCommonFailureBlock
             getFailureResponseModelBlock:(CJNetworkClientGetFailureResponseModelBlock)getFailureResponseModelBlock
{
    NSAssert(getSuccessResponseModelBlock, @"getSuccessResponseModelBlock不能为空");
    NSAssert(getFailureResponseModelBlock, @"getFailureResponseModelBlock不能为空");
    _getSuccessResponseModelBlock = getSuccessResponseModelBlock;
    _checkIsCommonFailureBlock = checkIsCommonFailureBlock;
    _getFailureResponseModelBlock = getFailureResponseModelBlock;
}

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


@end

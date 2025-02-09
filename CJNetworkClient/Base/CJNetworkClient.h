//
//  CJNetworkClient.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  网络请求管理类，其他NetworkClient可通过本CJNetworkClient继承，也可自己再实现。

#import <Foundation/Foundation.h>
#import "CJNetworkInstance.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJNetworkClient : CJNetworkInstance {
    
}

#pragma mark - 请求判断
//必须实现：将"网络请求成功返回的数据responseObject"转换为"模型"的方法
@property (nonatomic, copy, readonly) CJResponseModel *(^getSuccessResponseModelBlock)(CJSuccessRequestInfo * _Nonnull successRequestInfo);

//必须实现：将"网络请求失败返回的数据error"转换为"模型"的方法
@property (nonatomic, copy, readonly) CJResponseModel* (^getFailureResponseModelBlock)(CJFailureRequestInfo * _Nonnull failureRequestInfo);

//可选实现：在"网络请求成功并转换为模型"后判断其是否是"异地登录"等共同错误并在此对共同错误做处理，如statusCode == -5 为异地登录(可为ni,非nil时一般返回值为NO)
//未设置时候 CJResponeFailureType 为 CJResponeFailureTypeNeedFurtherJudgeFailure
//设置时候 若返回YES,则即为CJResponeFailureTypeCommonFailure，其会走failure回调;
//设置时候 若返回NO,则即为CJResponeFailureTypeNeedFurtherJudgeFailure，其会走success回调；
//详细的走法如下代码所示：
//if (failureType == CJResponeFailureTypeCommonFailure) {
//    !failure ?: failure(NO, responseModel.message);
//
//} else if (failureType == CJResponeFailureTypeRequestFailure) {
//    !failure ?: failure(YES, responseModel.message);
//
//} else {
//    !success ?: success(responseModel);
//}
@property (nonatomic, copy, readonly) BOOL(^checkIsCommonFailureBlock)(CJResponseModel *responseModel);


/*
 *  设置服务器返回值的各种处理方法(一定要执行)
 *
 *  @param getSuccessResponseModelBlock 将"网络请求成功返回的数据responseObject"转换为"模型"的方法
 *  @param checkIsCommonFailureBlock    在"网络请求成功并转换为模型"后判断其是否是"异地登录"等共同错误并在此对共同错误做处理(可为nil)
 *  @param getFailureResponseModelBlock 将"网络请求失败返回的数据error"转换为"模型"的方法
 */
- (void)setupGetSuccessResponseModelBlock:(CJNetworkClientGetSuccessResponseModelBlock)getSuccessResponseModelBlock
                checkIsCommonFailureBlock:(BOOL(^)(CJResponseModel *responseModel))checkIsCommonFailureBlock
             getFailureResponseModelBlock:(CJNetworkClientGetFailureResponseModelBlock)getFailureResponseModelBlock;


@end

NS_ASSUME_NONNULL_END

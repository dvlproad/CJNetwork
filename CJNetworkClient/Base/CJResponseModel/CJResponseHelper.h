//
//  CJResponseHelper.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/18.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CQNetworkPublic/CJRequestInfoModel.h>
#import <CQNetworkPublic/CJResponseModel.h>
#import <CQNetworkPublic/CJRequestNetworkEnum.h>

NS_ASSUME_NONNULL_BEGIN

/*
 *  必须实现：将"网络请求成功返回的数据responseObject"转换为"模型"的方法
 *
 *  @param responseObject   网络请求成功返回的数据
 *  @param isCacheData      是否是缓存数据
 *
 *  @return 数据模型
 */
typedef CJResponseModel * _Nullable (^CJNetworkClientGetSuccessResponseModelBlock)(CJSuccessRequestInfo * _Nonnull successRequestInfo);

/*
 *  必须实现：将"网络请求失败返回的数据error"转换为"模型"的方法
 *
 *  @param error            网络请求失败返回的数据
 *  @param errorMessage     从网络中获取到错误信息getErrorMessageFromHTTPURLResponse
 *
 *  @return 数据模型
 */
typedef CJResponseModel * _Nullable (^CJNetworkClientGetFailureResponseModelBlock)(CJFailureRequestInfo * _Nonnull failureRequestInfo);


@interface CJResponseHelper : NSObject

+ (void)__dealSuccessRequestInfo:(CJSuccessRequestInfo *)successNetworkInfo
    getSuccessResponseModelBlock:(CJResponseModel *(^)(CJSuccessRequestInfo *bSuccessRequestInfo))getSuccessResponseModelBlock
       checkIsCommonFailureBlock:(BOOL(^)(CJResponseModel *responseModel))checkIsCommonFailureBlock
                   completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

+ (void)__dealFailureNetworkInfo:(CJFailureRequestInfo *)failureNetworkInfo
    getFailureResponseModelBlock:(CJNetworkClientGetFailureResponseModelBlock)getFailureResponseModelBlock
                   completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock;

@end

NS_ASSUME_NONNULL_END

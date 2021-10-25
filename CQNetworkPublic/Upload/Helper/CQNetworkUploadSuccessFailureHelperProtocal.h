//
//  CQNetworkUploadSuccessFailureHelperProtocal.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#ifndef CQNetworkUploadSuccessFailureHelperProtocal_h
#define CQNetworkUploadSuccessFailureHelperProtocal_h

#import "CJUploadModelProtocol.h"
#import "CJRequestNetworkEnum.h"
#import "CJResponseModel.h"
#import <CJNetworkFileModel/CJUploadFileModel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CQNetworkUploadSuccessFailureHelperProtocal <NSObject>

#pragma mark - Protocal为了解耦需要由分类来实现的方法
@required
/*
 *  上传文件的请求方法：只是上传文件，不对上传过程中的各个时刻信息的进行保存
 *
 *  @param model            上传请求相关的信息(包含请求方法、请求地址、请求参数等)real\simulate\local
 *  @param progress         上传请求过程的回调
 *  @param success          上传请求结束成功的回调(为方便接口的重复利用回调中的responseModel使用id类型)
 *  @param failure          上传请求结束失败的回调
 *
 *  @return 上传文件的请求
 */
+ (NSURLSessionDataTask *)uploadModel:(__kindof NSObject<CJUploadModelProtocol> *)model
                             progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                              success:(void (^)(CJResponseModel *responseModel))success
                              failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

@end


#endif /* CQNetworkUploadSuccessFailureHelperProtocal_h */

NS_ASSUME_NONNULL_END

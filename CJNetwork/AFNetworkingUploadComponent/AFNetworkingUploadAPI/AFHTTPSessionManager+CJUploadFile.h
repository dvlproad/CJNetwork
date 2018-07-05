//
//  AFHTTPSessionManager+CJUploadFile.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/10/5.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "CJUploadFileModel.h"


@interface AFHTTPSessionManager (CJUploadFile)

/**
 *  上传文件的请求方法：只是上传文件，不对上传过程中的各个时刻信息的进行保存
 *
 *  @param Url              Url
 *  @param parameters       parameters
 *  @param fileKey          文件参数：有些人会用file,有些人用upfile
 *  @param uploadFileModels 文件数据：要上传的数据组uploadFileModels
 *  @param uploadProgress   uploadProgress
 *  @param success          上传成功执行的回调
 *  @param failure          上传失败执行的回调
 *
 *  @return 上传文件的请求
 */
- (nullable NSURLSessionDataTask *)cj_postUploadUrl:(nullable NSString *)Url
                                             params:(nullable id)parameters
                                            fileKey:(nullable NSString *)fileKey
                                          fileValue:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                           progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                            success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject))success
                                            failure:(nullable void (^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failure;

@end

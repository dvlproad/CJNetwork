//
//  AFHTTPSessionManager+CJUploadFile.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/10/5.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "CJNetwork.h"

#import "CJUploadItemModel.h"

@interface AFHTTPSessionManager (CJUploadFile)

- (nullable NSURLSessionDataTask *)cj_postUploadUrl:(nullable NSString *)Url
                                         parameters:(nullable id)parameters
                                        uploadItems:(nullable NSArray<CJUploadItemModel *> *)uploadItems
                                           progress:(nullable AFUploadProgressBlock)uploadProgress
                                            success:(nullable AFRequestSuccess)success
                                            failure:(nullable AFRequestFailure)failure;

@end

//
//  IjinbuNetworkClient+UploadFile.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2017/4/5.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "IjinbuNetworkClient.h"
#import "AFHTTPSessionManager+CJUploadFile.h"
#import "IjinbuUploadItemRequest.h"

@interface IjinbuNetworkClient (UploadFile)

- (NSURLSessionDataTask *)requestUploadFile:(IjinbuUploadItemRequest *)request
                                   progress:(AFUploadProgressBlock)uploadProgress
                                    success:(AFRequestSuccess)success
                                    failure:(AFRequestFailure)failure;

@end

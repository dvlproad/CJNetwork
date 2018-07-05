//
//  UIView+AFNetworkingUpload.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/8/27.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "UIView+AFNetworkingUpload.h"

@implementation UIView (AFNetworkingUpload)

/* 完整的描述请参见文件头部 */
- (void)configureUploadRequestForItem:(CJBaseUploadItem *)saveUploadInfoToItem
        andUseUploadInfoConfigureView:(CJUploadProgressView *)uploadProgressView
      uploadRequestConfigureByManager:(AFHTTPSessionManager *)manager
                                  Url:(NSString *)Url
                               params:(id)parameters
                              fileKey:(NSString *)fileKey
                            fileValue:(NSArray<CJUploadFileModel *> *)uploadFileModels
                uploadInfoChangeBlock:(void(^)(CJBaseUploadItem *saveUploadInfoToItem))uploadInfoChangeBlock
       dealResopnseForUploadInfoBlock:(CJUploadMomentInfo * (^)(id responseObject))dealResopnseForUploadInfoBlock
{
    
    NSURLSessionDataTask *operation = saveUploadInfoToItem.operation;
    if (operation == nil) {
        operation =
        [AFNetworkingUploadUtil cj_UseManager:manager
                                postUploadUrl:Url
                                       params:parameters
                                      fileKey:fileKey
                               fileValueOwner:saveUploadInfoToItem
                  uploadMomentInfoChangeBlock:uploadInfoChangeBlock
               dealResopnseForUploadInfoBlock:dealResopnseForUploadInfoBlock];
        
        saveUploadInfoToItem.operation = operation;
    }
    
    
    //cjReUploadHandle
    __weak typeof(saveUploadInfoToItem)weakItem = saveUploadInfoToItem;
    [uploadProgressView setCjReUploadHandle:^(UIView *uploadProgressView) {
        __strong __typeof(weakItem)strongItem = weakItem;
        
        [strongItem.operation cancel];
        
        NSURLSessionDataTask *newOperation =
        [AFNetworkingUploadUtil cj_UseManager:manager
                                postUploadUrl:Url
                                       params:parameters
                                      fileKey:fileKey
                               fileValueOwner:saveUploadInfoToItem
                  uploadMomentInfoChangeBlock:uploadInfoChangeBlock
               dealResopnseForUploadInfoBlock:dealResopnseForUploadInfoBlock];
        
        strongItem.operation = newOperation;
    }];
    
    
    CJUploadMomentInfo *momentInfo = saveUploadInfoToItem.momentInfo;
    [uploadProgressView updateProgressText:momentInfo.uploadStatePromptText progressVaule:momentInfo.progressValue];//调用此方法避免reload时候显示错误
}

@end

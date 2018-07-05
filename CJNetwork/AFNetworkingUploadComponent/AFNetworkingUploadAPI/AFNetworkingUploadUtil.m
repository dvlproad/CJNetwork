//
//  AFNetworkingUploadUtil.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/06/07.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "AFNetworkingUploadUtil.h"

@implementation AFNetworkingUploadUtil

#pragma mark - 上传文件请求的接口
/* 完整的描述请参见文件头部 */
+ (NSURLSessionDataTask *)cj_UseManager:(AFHTTPSessionManager *)manager
                          postUploadUrl:(NSString *)Url
                                 params:(id)parameters
                                fileKey:(NSString *)fileKey
                              fileValue:(NSArray<CJUploadFileModel *> *)uploadFileModels
                   uploadInfoSaveInItem:(CJBaseUploadItem *)saveUploadInfoToItem
                  uploadInfoChangeBlock:(void(^)(CJBaseUploadItem *saveUploadInfoToItem))uploadInfoChangeBlock
         dealResopnseForUploadInfoBlock:(CJUploadMomentInfo * (^)(id responseObject))dealResopnseForUploadInfoBlock
{
    __weak typeof(saveUploadInfoToItem)weakItem = saveUploadInfoToItem;
    
    
    
    /* 正在上传 */
    void (^uploadingBlock)(NSProgress *progress) = ^ (NSProgress *progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong __typeof(weakItem)strongItem = weakItem;
            
            CJUploadMomentInfo *momentInfo = [[CJUploadMomentInfo alloc] init];
            momentInfo.uploadState = CJUploadMomentStateUploading;
            CGFloat progressValue = progress.fractionCompleted * 100;
            momentInfo.uploadStatePromptText = [NSString stringWithFormat:@"%.0lf%%", progressValue];
            momentInfo.progressValue = progressValue;
            
            strongItem.momentInfo = momentInfo;
            
            if (uploadInfoChangeBlock) {
                uploadInfoChangeBlock(strongItem);
            }
        });
    };
    
    /* 上传完成 */
    void (^uploadCompleteBlock)(CJUploadMomentInfo *momentInfo) = ^ (CJUploadMomentInfo *momentInfo) {
        __strong __typeof(weakItem)strongItem = weakItem;
        strongItem.momentInfo = momentInfo;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (uploadInfoChangeBlock) {
                uploadInfoChangeBlock(strongItem);
            }
        });
    };
    
    
    return [manager cj_postUploadUrl:Url params:parameters fileKey:fileKey fileValue:uploadFileModels progress:uploadingBlock success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        if (dealResopnseForUploadInfoBlock) {
            CJUploadMomentInfo *momentInfo = dealResopnseForUploadInfoBlock(responseObject);
            uploadCompleteBlock(momentInfo);
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        CJUploadMomentInfo *momentInfo = [[CJUploadMomentInfo alloc] init];
        momentInfo.responseModel = nil;
        momentInfo.uploadState = CJUploadMomentStateFailure;
        momentInfo.uploadStatePromptText = NSLocalizedString(@"点击重传", nil);
        
        uploadCompleteBlock(momentInfo);
        
        NSLog(@"error: %@", [error localizedDescription]);
    }];
}


@end

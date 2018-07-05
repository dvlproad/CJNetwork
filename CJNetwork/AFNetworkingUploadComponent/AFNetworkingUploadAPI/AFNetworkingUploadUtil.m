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
                                 params:(id)params
                                fileKey:(NSString *)fileKey
                         fileValueOwner:(CJBaseUploadItem *)fileValueOwner
            uploadMomentInfoChangeBlock:(void(^)(CJBaseUploadItem *momentInfoOwner))uploadMomentInfoChangeBlock
         dealResopnseForUploadInfoBlock:(CJUploadMomentInfo * (^)(id responseObject))dealResopnseForUploadInfoBlock
{
    __weak typeof(fileValueOwner)weakFileValueOwner = fileValueOwner;
    
    /* 正在上传 */
    void (^uploadingBlock)(NSProgress *progress) = ^ (NSProgress *progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong __typeof(weakFileValueOwner)strongFileValueOwner = weakFileValueOwner;
            
            CJUploadMomentInfo *momentInfo = [[CJUploadMomentInfo alloc] init];
            momentInfo.uploadState = CJUploadMomentStateUploading;
            CGFloat progressValue = progress.fractionCompleted * 100;
            momentInfo.uploadStatePromptText = [NSString stringWithFormat:@"%.0lf%%", progressValue];
            momentInfo.progressValue = progressValue;
            
            strongFileValueOwner.momentInfo = momentInfo;
            
            if (uploadMomentInfoChangeBlock) {
                uploadMomentInfoChangeBlock(strongFileValueOwner);
            }
        });
    };
    
    /* 上传完成 */
    void (^uploadCompleteBlock)(CJUploadMomentInfo *momentInfo) = ^ (CJUploadMomentInfo *momentInfo) {
        __strong __typeof(weakFileValueOwner)strongFileValueOwner = weakFileValueOwner;
        strongFileValueOwner.momentInfo = momentInfo;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (uploadMomentInfoChangeBlock) {
                uploadMomentInfoChangeBlock(strongFileValueOwner);
            }
        });
    };
    
    
    return [manager cj_postUploadUrl:Url params:params fileKey:fileKey fileValue:fileValueOwner.uploadFileModels progress:uploadingBlock success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
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

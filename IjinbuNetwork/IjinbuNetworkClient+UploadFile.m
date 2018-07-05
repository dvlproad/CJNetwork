//
//  IjinbuNetworkClient+UploadFile.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/4/5.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "IjinbuNetworkClient+UploadFile.h"
#import "IjinbuHTTPSessionManager.h"

#ifdef CJTESTPOD
#import "AFNetworkingUploadUtil.h"
#else
#import <CJNetwork/AFNetworkingUploadUtil.h>
#endif

#import "IjinbuUploadItemResult.h"


@implementation IjinbuNetworkClient (UploadFile)

/* 完整的描述请参见文件头部 */
- (nullable NSURLSessionDataTask *)ijinbu_multiUploadFileWithParams:(nullable id)params
                                                   uploadFileModels:(nullable NSArray<CJUploadFileModel *> *)uploadFileModels
                                                           progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                                      completeBlock:(nullable void (^)(IjinbuResponseModel * _Nullable responseModel))completeBlock
{
    AFHTTPSessionManager *manager = [IjinbuHTTPSessionManager sharedInstance];
    
    NSString *Url = API_BASE_Url_ijinbu(@"ijinbu/app/public/batchUpload");
    NSLog(@"Url = %@", Url);
    NSLog(@"params = %@", params);
    
    return [manager cj_postUploadUrl:Url parameters:params uploadFileModels:uploadFileModels progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        IjinbuResponseModel *responseModel = [[IjinbuResponseModel alloc] init];
        responseModel.status = [responseObject[@"status"] integerValue];
        responseModel.message = responseObject[@"msg"];
        responseModel.result = responseObject[@"result"];
        if (completeBlock) {
            completeBlock(responseModel);
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        IjinbuResponseModel *responseModel = [[IjinbuResponseModel alloc] init];
        responseModel.status = -1;
        responseModel.message = NSLocalizedString(@"网络请求失败", nil);
        responseModel.result = nil;
        if (completeBlock) {
            completeBlock(responseModel);
        }
    }];
}


/* 完整的描述请参见文件头部 */
+ (NSURLSessionDataTask *)detailedRequestUploadItems:(NSArray<CJUploadFileModel *> *)uploadFileModels
                                             toWhere:(NSInteger)toWhere
                             andsaveUploadInfoToItem:(CJBaseUploadItem *)saveUploadInfoToItem
                               uploadInfoChangeBlock:(void(^)(CJBaseUploadItem *item))uploadInfoChangeBlock {
    
    AFHTTPSessionManager *manager = [IjinbuHTTPSessionManager sharedInstance];
    
    NSString *Url = API_BASE_Url_ijinbu(@"ijinbu/app/public/batchUpload");
    NSDictionary *parameters = @{@"uploadType": @(toWhere)};
    NSLog(@"Url = %@", Url);
    NSLog(@"params = %@", parameters);
    
    /* 从请求结果response中获取uploadInfo的代码块 */
    CJUploadInfo *(^dealResopnseForUploadInfoBlock)(id responseObject) = ^CJUploadInfo *(id responseObject)
    {
        IjinbuResponseModel *responseModel = [[IjinbuResponseModel alloc] init];
        responseModel.status = [responseObject[@"status"] integerValue];
        responseModel.message = responseObject[@"msg"];
        responseModel.result = responseObject[@"result"];
        
        CJUploadInfo *uploadInfo = [[CJUploadInfo alloc] init];
        uploadInfo.responseModel = responseModel;
        if (responseModel.status == 1) {
            NSMutableArray<NSDictionary *> *dictionarys = responseModel.result;
            
            NSMutableArray<IjinbuUploadItemResult *> *operationUploadResult = [[NSMutableArray alloc] init];
            for (NSDictionary *dictionary in dictionarys) {
                IjinbuUploadItemResult *itemResult = [[IjinbuUploadItemResult alloc] initWithHisDictionary:dictionary];
                [operationUploadResult addObject:itemResult];
            }
        
            
            if (operationUploadResult == nil || operationUploadResult.count == 0) {
                uploadInfo.uploadState = CJUploadStateFailure;
                uploadInfo.uploadStatePromptText = @"点击重传";
                
            } else {
                BOOL findFailure = NO;
                for (IjinbuUploadItemResult *uploadItemResult in operationUploadResult) {
                    NSString *networkUrl = uploadItemResult.networkUrl;
                    if (networkUrl == nil || [networkUrl length] == 0) {
                        NSLog(@"Failure:文件上传后返回的网络地址为空");
                        findFailure = YES;
                        
                    }
                }
                
                if (findFailure) {
                    uploadInfo.uploadState = CJUploadStateFailure;
                    uploadInfo.uploadStatePromptText = @"点击重传";
                    
                } else {
                    uploadInfo.uploadState = CJUploadStateSuccess;
                    uploadInfo.uploadStatePromptText = @"上传成功";
                }
            }
            
        } else if (responseModel.status == 2) {
            uploadInfo.uploadState = CJUploadStateFailure;
            uploadInfo.uploadStatePromptText = responseModel.message;
            
        } else {
            uploadInfo.uploadState = CJUploadStateFailure;
            uploadInfo.uploadStatePromptText = @"点击重传";
        }
        
        return uploadInfo;
    };
    
    
    NSURLSessionDataTask *operation =
    [AFNetworkingUploadUtil cj_UseManager:manager
                            postUploadUrl:Url
                               parameters:parameters
                         uploadFileModels:uploadFileModels
                     uploadInfoSaveInItem:saveUploadInfoToItem
                    uploadInfoChangeBlock:uploadInfoChangeBlock
           dealResopnseForUploadInfoBlock:dealResopnseForUploadInfoBlock];
    
    return operation;
}

@end

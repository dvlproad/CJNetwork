//
//  CJNetworkClient+CJDemoApp.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJNetworkClient+CJDemoApp.h"
#import "CJNetworkClient+Upload1.h"
#import "CJNetworkClient+Upload2.h"

@implementation CJNetworkClient (CJDemoApp)

- (NSURLSessionDataTask *)cjdemoR1_uploadImageApi:(NSString *)apiSuffix
                                        urlParams:(nullable id)urlParams
                                       formParams:(nullable id)formParams
                          imageKeyDataDictionarys:(NSDictionary *)imageKeyDataDicts
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                    completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSMutableArray<CJUploadFileModel *> *uploadFileModels = [self __uploadFileModels:imageKeyDataDicts];
    
    return [self real1_uploadApi:apiSuffix urlParams:urlParams formParams:formParams settingModel:settingModel uploadFileModels:uploadFileModels progress:nil completeBlock:completeBlock];
}

- (NSURLSessionDataTask *)cjdemoR2_uploadImageApi:(NSString *)apiSuffix
                                        urlParams:(nullable id)urlParams
                                       formParams:(nullable id)formParams
                          imageKeyDataDictionarys:(NSDictionary *)imageKeyDataDicts
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                          success:(void (^)(CJResponseModel *responseModel))success
                                          failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    NSMutableArray<CJUploadFileModel *> *uploadFileModels = [self __uploadFileModels:imageKeyDataDicts];
    
    return [self real2_uploadApi:apiSuffix urlParams:urlParams formParams:formParams settingModel:settingModel uploadFileModels:uploadFileModels progress:nil success:success failure:failure];
}

#pragma mark - simulateApi
- (NSURLSessionDataTask *)cjdemoS1_uploadImageApi:(NSString *)apiSuffix
                                        urlParams:(nullable id)urlParams
                                       formParams:(nullable id)formParams
                          imageKeyDataDictionarys:(NSDictionary *)imageKeyDataDicts
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                    completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSMutableArray<CJUploadFileModel *> *uploadFileModels = nil;
    
    return [self simulate1_uploadApi:apiSuffix urlParams:urlParams formParams:formParams settingModel:settingModel uploadFileModels:uploadFileModels progress:nil completeBlock:completeBlock];
}

- (NSURLSessionDataTask *)cjdemoS2_uploadImageApi:(NSString *)apiSuffix
                                        urlParams:(nullable id)urlParams
                                       formParams:(nullable id)formParams
                          imageKeyDataDictionarys:(NSDictionary *)imageKeyDataDicts
                                     settingModel:(nullable CJRequestSettingModel *)settingModel
                                          success:(void (^)(CJResponseModel *responseModel))success
                                          failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    NSMutableArray<CJUploadFileModel *> *uploadFileModels = nil;
    
    return [self simulate2_uploadApi:apiSuffix urlParams:urlParams formParams:formParams settingModel:settingModel uploadFileModels:uploadFileModels progress:nil success:success failure:failure];
}

#pragma mark - localApi
- (nullable NSURLSessionDataTask *)cjdemoL1_uploadImageApi:(NSString *)apiSuffix
                                                 urlParams:(nullable id)urlParams
                                                formParams:(nullable id)formParams
                                   imageKeyDataDictionarys:(NSDictionary *)imageKeyDataDicts
                                              settingModel:(nullable CJRequestSettingModel *)settingModel
                                             completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSMutableArray<CJUploadFileModel *> *uploadFileModels = nil;
    
    return [self local1_uploadApi:apiSuffix urlParams:urlParams formParams:formParams settingModel:settingModel uploadFileModels:uploadFileModels progress:nil completeBlock:completeBlock];
}

- (nullable NSURLSessionDataTask *)cjdemoL2_uploadImageApi:(NSString *)apiSuffix
                                                 urlParams:(nullable id)urlParams
                                                formParams:(nullable id)formParams
                                   imageKeyDataDictionarys:(NSDictionary *)imageKeyDataDicts
                                              settingModel:(nullable CJRequestSettingModel *)settingModel
                                                   success:(void (^)(CJResponseModel *responseModel))success
                                                   failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    NSMutableArray<CJUploadFileModel *> *uploadFileModels = nil;
    
    return [self local2_uploadApi:apiSuffix urlParams:urlParams formParams:formParams settingModel:settingModel uploadFileModels:uploadFileModels progress:nil success:success failure:failure];
}


#pragma mark - Private
- (NSMutableArray<CJUploadFileModel *> *)__uploadFileModels:(NSDictionary *)imageKeyDataDicts {
    NSString *imagePrefixName = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]*1000];
    
    NSMutableArray<CJUploadFileModel *> *uploadFileModels = [[NSMutableArray alloc] init];
    NSInteger imageCount = imageKeyDataDicts.allKeys.count;
    for (NSInteger i = 0; i < imageCount; i++) {
        NSString *imageSuffixName = [NSString stringWithFormat:@"_%zd.jpg", i];
        NSString *imageName = [imagePrefixName stringByAppendingString:imageSuffixName];
        
        NSString *imageKey = imageKeyDataDicts.allKeys[i];
        NSData *imageData = [imageKeyDataDicts objectForKey:imageKey];
        
        CJUploadFileModel *imageUploadModel = [[CJUploadFileModel alloc] initWithItemType:CJUploadItemTypeImage itemName:imageName itemData:imageData itemKey:imageKey];
        [uploadFileModels addObject:imageUploadModel];
    }
    
    return uploadFileModels;
}

@end

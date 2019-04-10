//
//  CJNetworkClient+CJDemoApp.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJNetworkClient+CJDemoApp.h"

@implementation CJNetworkClient (CJDemoApp)

// the cjdemo app's upload image example, other app can refer to it
- (NSURLSessionDataTask *)cjdemoR1_uploadImageApi:(NSString *)apiSuffix
                                           params:(nullable NSDictionary *)customParams
                                       imageDatas:(NSArray<NSData *> *)imageDatas
                                     settingModel:(CJRequestSettingModel *)settingModel
                                    completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSMutableArray<CJUploadFileModel *> *uploadFileModels = [self __uploadFileModelsFromImageDatas:imageDatas];
    
    return [self real1_uploadApi:apiSuffix params:customParams settingModel:settingModel fileKey:@"file" fileValue:uploadFileModels progress:nil completeBlock:completeBlock];
}

// the cjdemo app's upload image example, other app can refer to it
- (NSURLSessionDataTask *)cjdemoR2_uploadImageApi:(NSString *)apiSuffix
                                           params:(nullable NSDictionary *)customParams
                                       imageDatas:(NSArray<NSData *> *)imageDatas
                                     settingModel:(CJRequestSettingModel *)settingModel
                                          success:(void (^)(CJResponseModel *responseModel))success
                                          failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    NSMutableArray<CJUploadFileModel *> *uploadFileModels = [self __uploadFileModelsFromImageDatas:imageDatas];
    
    return [self real2_uploadApi:apiSuffix params:customParams settingModel:settingModel fileKey:@"file" fileValue:uploadFileModels progress:nil success:success failure:failure];
}

#pragma mark - simulateApi
// the cjdemo app's upload image example, other app can refer to it
- (NSURLSessionDataTask *)cjdemoS1_uploadImageApi:(NSString *)apiSuffix
                                           params:(nullable NSDictionary *)customParams
                                       imageDatas:(NSArray<NSData *> *)imageDatas
                                     settingModel:(CJRequestSettingModel *)settingModel
                                    completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSMutableArray<CJUploadFileModel *> *uploadFileModels = nil;
    
    return [self simulate1_uploadApi:apiSuffix params:customParams settingModel:settingModel fileKey:@"file" fileValue:uploadFileModels progress:nil completeBlock:completeBlock];
}

// the cjdemo app's upload image example, other app can refer to it
- (NSURLSessionDataTask *)cjdemoS2_uploadImageApi:(NSString *)apiSuffix
                                           params:(nullable NSDictionary *)customParams
                                       imageDatas:(NSArray<NSData *> *)imageDatas
                                     settingModel:(CJRequestSettingModel *)settingModel
                                          success:(void (^)(CJResponseModel *responseModel))success
                                          failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    NSMutableArray<CJUploadFileModel *> *uploadFileModels = nil;
    
    return [self simulate2_uploadApi:apiSuffix params:customParams settingModel:settingModel fileKey:@"file" fileValue:uploadFileModels progress:nil success:success failure:failure];
}

#pragma mark - localApi
// the cjdemo app's upload image example, other app can refer to it
- (nullable NSURLSessionDataTask *)cjdemoL1_uploadImageApi:(NSString *)apiSuffix
                                                    params:(nullable NSDictionary *)customParams
                                                imageDatas:(NSArray<NSData *> *)imageDatas
                                              settingModel:(CJRequestSettingModel *)settingModel
                                             completeBlock:(void (^)(CJResponeFailureType failureType, CJResponseModel *responseModel))completeBlock
{
    NSMutableArray<CJUploadFileModel *> *uploadFileModels = nil;
    
    return [self local1_uploadApi:apiSuffix params:customParams settingModel:settingModel fileKey:@"file" fileValue:uploadFileModels progress:nil completeBlock:completeBlock];
}

// the cjdemo app's upload image example, other app can refer to it
- (nullable NSURLSessionDataTask *)cjdemoL2_uploadImageApi:(NSString *)apiSuffix
                                                    params:(nullable NSDictionary *)customParams
                                                imageDatas:(NSArray<NSData *> *)imageDatas
                                              settingModel:(CJRequestSettingModel *)settingModel
                                                   success:(void (^)(CJResponseModel *responseModel))success
                                                   failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure
{
    NSMutableArray<CJUploadFileModel *> *uploadFileModels = nil;
    
    return [self local2_uploadApi:apiSuffix params:customParams settingModel:settingModel fileKey:@"file" fileValue:uploadFileModels progress:nil success:success failure:failure];
}


#pragma mark - Private
- (NSMutableArray<CJUploadFileModel *> *)__uploadFileModelsFromImageDatas:(NSArray<NSData *> *)imageDatas {
    NSString *imagePrefixName = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]*1000];
    
    NSMutableArray<CJUploadFileModel *> *uploadFileModels = [[NSMutableArray alloc] init];
    NSInteger imageCount = imageDatas.count;
    for (NSInteger i = 0; i < imageCount; i++) {
        NSString *imageSuffixName = [NSString stringWithFormat:@"_%ld.jpg", i];
        NSString *imageName = [imagePrefixName stringByAppendingString:imageSuffixName];
        
        NSData *imageData = [imageDatas objectAtIndex:i];
        
        CJUploadFileModel *imageUploadModel = [[CJUploadFileModel alloc] initWithItemType:CJUploadItemTypeImage itemName:imageName itemData:imageData];
        [uploadFileModels addObject:imageUploadModel];
    }
    
    return uploadFileModels;
}

@end

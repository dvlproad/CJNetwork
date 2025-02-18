//
//  CQTSSandboxFileUtil.m
//  CQDemoKit
//
//  Created by lcQian on 2020/4/7.
//  Copyright © 2020 dvlproad. All rights reserved.
//

#import "CQTSSandboxFileUtil.h"
#import "CQTSResourceUtil.h"
#import "NSError+CQTSErrorString.h"

@implementation CQTSSandboxFileUtil

#pragma mark - Copy Bundle File
/// 拷贝主工程中的文件到沙盒中
///
/// @param fileNameWithExtension        要拷贝的文件
/// @param inBundle                                     从项目中的哪个bundle中拷贝（nil时候为 [NSBundle mainBundle] ）
/// @param sandboxType                               要放到的沙盒位置
/// @param subDirectory                             要放到的沙盒的子目录
///
/// @return 返回存放后的文件路径信息（存放失败，返回nil）
+ (nullable NSDictionary *)copyFile:(NSString *)fileNameWithExtension
                           inBundle:(nullable NSBundle *)bundle
                      toSandboxType:(CQTSSandboxType)sandboxType
                       subDirectory:(nullable NSString *)subDirectory
{
    NSDictionary *result = [CQTSResourceUtil extractFileNameAndExtensionFromFileName:fileNameWithExtension];
    NSString *fileName = result[@"fileName"];
    NSString *fileExtension = result[@"fileExtension"];
    
    // 获取原始图片的路径
    if (bundle == nil) {
        bundle = [NSBundle mainBundle];
    }
    NSURL *imageURL = [bundle URLForResource:fileName withExtension:fileExtension];
    if (!imageURL) {
        NSLog(@"Image not found in bundle");
        return nil;
    }

    // 创建目标路径（共享资源目录下的目标文件路径）:相对路径
    NSString *relativePath = @"";
    if (subDirectory != nil && subDirectory.length > 0) {
        relativePath = subDirectory;
    }
    NSString *newFileName = [NSString stringWithFormat:@"%@.%@", fileName, fileExtension];
    relativePath = [relativePath stringByAppendingPathComponent:newFileName];
    // 绝对路径
    NSString *sandboxPath = [CQTSSandboxPathUtil sandboxPath:sandboxType];
    NSURL *sandboxURL = [NSURL fileURLWithPath:sandboxPath];
    NSURL *destinationURL = [sandboxURL URLByAppendingPathComponent:relativePath];

    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 检查目标文件是否已存在，如果存在则删除它
    if ([fileManager fileExistsAtPath:destinationURL.path]) {
        if (![fileManager removeItemAtURL:destinationURL error:&error]) {
            NSLog(@"Failed to remove existing file: %@", error.localizedDescription);
            return nil;
        }
    }

    // 检查并创建目标路径的父目录（一次性创建所有中间目录）
    NSURL *parentDirectory = [destinationURL URLByDeletingLastPathComponent];
    if (![fileManager fileExistsAtPath:parentDirectory.path]) {
        if (![fileManager createDirectoryAtURL:parentDirectory
                   withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"Failed to create directory: %@", error.localizedDescription);
            return nil;
        }
    }
    
    // 将图片从源目录复制到共享目录
    if (![fileManager copyItemAtURL:imageURL toURL:destinationURL error:&error]) {
        NSLog(@"Failed to copy file: %@", error.localizedDescription);
        return nil;
    }

    NSLog(@"File copied to shared directory: %@", destinationURL.path);
    return @{
        @"fileName": fileName,
        @"fileExtension": fileExtension,
        @"absoluteFilePath": destinationURL.path,
        @"relativeFilePath": relativePath
    };
}


+ (void)downloadFileWithUrl:(NSString *)fileUrl
              toSandboxType:(CQTSSandboxType)sandboxType
               subDirectory:(nullable NSString *)subDirectory
                   fileName:(nullable NSString *)fileNameWithExtension
                    success:(void (^)(NSDictionary *fileDictionary))success
                    failure:(void (^)(NSString *errorMessage))failure
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf _downloadFileWithUrl:fileUrl
                        toSandboxType:sandboxType
                         subDirectory:subDirectory
                             fileName:fileNameWithExtension
                              success:^(NSDictionary * _Nonnull fileDictionary) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(fileDictionary);
            });
        } failure:^(NSString * _Nonnull errorMessage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(errorMessage);
            });
        }];
    });
}


+ (void)_downloadFileWithUrl:(NSString *)fileUrl
              toSandboxType:(CQTSSandboxType)sandboxType
               subDirectory:(nullable NSString *)subDirectory
                   fileName:(nullable NSString *)fileNameWithExtension
                    success:(void (^)(NSDictionary *fileDictionary))success
                    failure:(void (^)(NSString *errorMessage))failure
{
    NSURL *fileURL = [NSURL URLWithString:fileUrl];
    if (!fileURL) {
        failure(@"fileUrl错误");
        return;
    }
    
    NSURLSessionDownloadTask *downloadTask = [[NSURLSession sharedSession] downloadTaskWithURL:fileURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (!location || !response || error || ((NSHTTPURLResponse *)response).statusCode != 200) {
            failure(error.cqtsErrorString);
            return;
        }
        
        NSError *fileError = nil;
        NSData *data = [NSData dataWithContentsOfURL:location options:0 error:&fileError];
        if (!data || fileError) {
            failure(fileError.cqtsErrorString);
            return;
        }
        
        NSDictionary *result;
        if (fileNameWithExtension == nil) {
            NSString *lastPathComponent = fileUrl.lastPathComponent;
            result = [CQTSResourceUtil extractFileNameAndExtensionFromFileName:lastPathComponent];
        } else {
            result = [CQTSResourceUtil extractFileNameAndExtensionFromFileName:fileNameWithExtension];
        }
        NSString *fileName = result[@"fileName"];
        NSString *fileExtension = result[@"fileExtension"];
        
        // 创建目标路径（共享资源目录下的目标文件路径）:相对路径
        NSString *relativePath = @"";
        if (subDirectory != nil && subDirectory.length > 0) {
            relativePath = subDirectory;
        }
        NSString *newFileName = [NSString stringWithFormat:@"%@.%@", fileName, fileExtension];
        relativePath = [relativePath stringByAppendingPathComponent:newFileName];
        // 绝对路径
        NSString *sandboxPath = [CQTSSandboxPathUtil sandboxPath:sandboxType];
        NSURL *sandboxURL = [NSURL fileURLWithPath:sandboxPath];
        NSURL *destinationURL = [sandboxURL URLByAppendingPathComponent:relativePath];
        NSString *directory = [destinationURL.URLByDeletingLastPathComponent path];
        BOOL isDirectory;
        if (![[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDirectory] || !isDirectory) {
            NSError *createDirError;
            [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&createDirError];
            if (createDirError) {
                failure(createDirError.cqtsErrorString);
                return;
            }
        }
        
        [data writeToFile:destinationURL.path options:0 error:&fileError];
        if (fileError) {
            failure(fileError.cqtsErrorString);
            
        } else {
            NSLog(@"File download to directory: %@", destinationURL.path);
            success(@{
                @"fileName": fileName,
                @"fileExtension": fileExtension,
                @"absoluteFilePath": destinationURL.path,
                @"relativeFilePath": relativePath
            });
        }
    }];
    
    [downloadTask resume];
}


@end

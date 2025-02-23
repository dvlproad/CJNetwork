//
//  CQTSPhotoUtil.m
//  CQDemoKit
//
//  Created by ciyouzen on 2020/4/7.
//  Copyright © 2020 dvlproad. All rights reserved.
//

#import "CQTSPhotoUtil.h"
#import <CQDemoKit/CJUIKitToastUtil.h>
#import <Photos/Photos.h>

@implementation CQTSPhotoUtil

+ (void)saveImageToPhotoAlbum:(NSURL *)mediaLocalURL
                      success:(void (^)(void))success
                      failure:(void (^)(NSString *errorMessage))failure
{
    UIImage *watiToSaveImage = [UIImage imageWithContentsOfFile:mediaLocalURL.path];
    if (watiToSaveImage == nil) {
        NSString *errorMessage = [NSString stringWithFormat:@"图片数据获取失败，无法保存"];
        failure(errorMessage);
        return;
    }
    
    // 请求相册权限
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) {
            failure(@"没有相册权限");
            return;
        }
        
        NSError *error = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            [PHAssetChangeRequest creationRequestForAssetFromImage:watiToSaveImage];
        } error:&error];
        
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"保存失败，请确认您的文件是不是图片: %@", error.localizedDescription];
            failure(errorMessage);
        } else {
            success();
        }
    }];
}


+ (void)saveVideoToPhotoAlbum:(NSURL *)mediaLocalURL
                      success:(void (^)(void))success
                      failure:(void (^)(NSString *errorMessage))failure
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) {
            failure(@"没有相册权限");
            return;
        }
        
        NSError *error = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:mediaLocalURL];
        } error:&error];
        
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"保存失败，请确认您的文件是不是视频: %@", error.localizedDescription];
            failure(errorMessage);
        } else {
            success();
        }
    }];
}



/// 根据路径的后缀名保存任意视频（此法不推荐，因为很多图片或视频的地址，并不一定是以其后缀名结尾）
+ (void)saveMediaByFileExtensionToPhotoAlbum:(NSURL *)mediaLocalURL
                                     success:(void (^)(void))success
                                     failure:(void (^)(NSString *errorMessage))failure
{
    // 请求相册权限
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) {
            failure(@"没有相册权限");
            return;
        }
        
        NSString *fileExtension = [mediaLocalURL pathExtension].lowercaseString;    // 获取文件扩展名
        if (fileExtension == nil || fileExtension.length == 0) {
            failure(@"获取文件扩展名失败");
            return;
        }
        
        UIImage *watiToSaveImage = nil;
        if ([self isImageFileExtension:fileExtension]) {    // 如果是图片
            watiToSaveImage = [UIImage imageWithContentsOfFile:mediaLocalURL.path];
            if (watiToSaveImage == nil) {
                NSString *errorMessage = [NSString stringWithFormat:@"图片数据获取失败"];
                failure(errorMessage);
                return;
            }
            
        } else if ([self isVideoFileExtension:fileExtension]) {
            
        } else {
            NSString *errorMessage = [NSString stringWithFormat:@"暂时不支持的文件类型: %@", fileExtension];
            failure(errorMessage);
            return;
        }
        
        
        NSError *error = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            if (watiToSaveImage != nil) {   // 如果是图片
                [PHAssetChangeRequest creationRequestForAssetFromImage:watiToSaveImage];
                
            } else if ([self isVideoFileExtension:fileExtension]) { // 如果是视频
                [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:mediaLocalURL];
            }
            
        } error:&error];
        
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"保存失败: %@", error.localizedDescription];
            failure(errorMessage);
            // 判断当前是否是主线程
//            if ([NSThread isMainThread]) {
//                [CJUIKitToastUtil showMessage:errorMessage];
//            } else {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [CJUIKitToastUtil showMessage:errorMessage];
//                });
//            }
        } else {
            success();
        }
    }];
}


+ (BOOL)isImageFileExtension:(NSString *)extension {
    NSArray *imageExtensions = @[@"jpg", @"jpeg", @"png", @"gif", @"bmp"];
    return [imageExtensions containsObject:extension];
}

+ (BOOL)isVideoFileExtension:(NSString *)extension {
    NSArray *videoExtensions = @[@"mp4", @"mov", @"avi", @"mkv", @"flv"];
    return [videoExtensions containsObject:extension];
}



@end

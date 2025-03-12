//
//  TSDownloadUtil.m
//  CJNetworkDemo
//
//  Created by qian on 2025/3/2.
//  Copyright © 2025 dvlproad. All rights reserved.
//

#import "TSDownloadUtil.h"
#import <CQDemoKit/CQTSResourceUtil.h>
#import <CQDemoKit/CQTSPhotoUtil.h>

#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CQDemoKit/CJUIKitAlertUtil.h>

#import <Photos/Photos.h>
#import "TSDownloadPlayViewController.h"
#import "HSDownloadManager.h"
#import "TSDownloadVideoIdManager.h"

#import "HSDownloadManager.h"

#import "AppInfoManager.h"

@implementation TSDownloadUtil

+ (void)askSaveDownloadModel:(CQDownloadRecordModel *)downloadModel {
    UIViewController *viewController = [AppInfoManager.sharedInstance getTopViewController];
    
    NSString *localAbsPath = [CQDownloadCacheUtil fileLocalAbsPathForUrl:downloadModel];
    NSURL *mediaLocalURL = [NSURL fileURLWithPath:localAbsPath];
    [self saveInViewController:viewController forMediaLocalURL:mediaLocalURL];
}

+ (void)saveInViewController:(UIViewController *)vc forMediaLocalURL:(NSURL *)mediaLocalURL {
    CQTSFileType fileType = [CQTSResourceUtil fileTypeForFilePathOrUrl:mediaLocalURL.path];
    
    NSString *typeString = @"";
    if (fileType == CQTSFileTypeVideo) {
        typeString = NSLocalizedStringFromTable(@"视频", @"LocalizableDownloader", nil);
    } else if (fileType == CQTSFileTypeAudio) {
        typeString = NSLocalizedStringFromTable(@"音频", @"LocalizableDownloader", nil);
        // PHPhotosErrorDomain错误3300 表示 无法将音频文件存入相册，因为 iOS 的相册 (Photos) 仅支持存储图片和视频，不支持音频文件（如 MP3、M4A）。
        NSArray *itemsToShare = @[mediaLocalURL];
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        [vc presentViewController:activityVC animated:YES completion:nil];
        
        return;
        
    } else {
        typeString = NSLocalizedStringFromTable(@"图片", @"LocalizableDownloader", nil);
    }
    NSString *title = [NSString stringWithFormat:NSLocalizedStringFromTable(@"是否要保存【%@】到相册", @"LocalizableDownloader", nil), typeString];
    
    [CJUIKitAlertUtil showCancleOKAlertInViewController:vc withTitle:title message:nil cancleBlock:nil okBlock:^{
        if (fileType == CQTSFileTypeVideo) {
            [CQTSPhotoUtil saveVideoToPhotoAlbum:mediaLocalURL success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CJUIKitToastUtil showMessage:NSLocalizedStringFromTable(@"保存成功", @"LocalizableDownloader", nil)];
                });
            } failure:^(NSString * _Nonnull errorMessage) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CJUIKitAlertUtil showIKnowAlertInViewController:vc withTitle:errorMessage iKnowBlock:nil];
                });
            }];
            return;
        } else if (fileType == CQTSFileTypeAudio) {
            [CQTSPhotoUtil saveAudioToPhotoAlbum:mediaLocalURL success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CJUIKitToastUtil showMessage:NSLocalizedStringFromTable(@"保存成功", @"LocalizableDownloader", nil)];
                });
            } failure:^(NSString * _Nonnull errorMessage) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CJUIKitAlertUtil showIKnowAlertInViewController:vc withTitle:errorMessage iKnowBlock:nil];
                });
            }];
            return;
        } else {
            [CQTSPhotoUtil saveImageToPhotoAlbum:mediaLocalURL success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CJUIKitToastUtil showMessage:NSLocalizedStringFromTable(@"保存成功", @"LocalizableDownloader", nil)];
                });
            } failure:^(NSString * _Nonnull errorMessage) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CJUIKitAlertUtil showIKnowAlertInViewController:vc withTitle:errorMessage iKnowBlock:nil];
                });
            }];
        }
    }];
}

@end

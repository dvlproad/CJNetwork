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

#import <CQDemoKit/CQTSLocImagesUtil.h>
#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CQDemoKit/CJUIKitAlertUtil.h>


#import "TSDownloadPlayViewController.h"
#import "HSDownloadManager.h"
#import "TSDownloadVideoIdManager.h"

#import "HSDownloadManager.h"

@implementation TSDownloadUtil

+ (void)saveInViewController:(UIViewController *)vc forDownloadModel:(CQTSLocImageDataModel *)downloadModel {
    NSString *downloadUrl = downloadModel.imageName;
    NSString *localAbsPath = [[HSDownloadManager sharedInstance] fileLocalAbsPathForUrl:downloadUrl];
    NSURL *mediaLocalURL = [NSURL fileURLWithPath:localAbsPath];
    CQTSFileType fileType = [CQTSResourceUtil fileTypeForFilePathOrUrl:mediaLocalURL.path];
    
    NSString *title = [NSString stringWithFormat:@"是否要保存【%@】到相册", fileType == CQTSFileTypeVideo ? @"视频" : @"图片"];
    NSString *message = downloadModel.imageName;
    [CJUIKitAlertUtil showCancleOKAlertInViewController:vc withTitle:title message:message cancleBlock:nil okBlock:^{
        if (fileType == CQTSFileTypeVideo) {
            [CQTSPhotoUtil saveVideoToPhotoAlbum:mediaLocalURL success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CJUIKitToastUtil showMessage:@"保存成功"];
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
                    [CJUIKitToastUtil showMessage:@"保存成功"];
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

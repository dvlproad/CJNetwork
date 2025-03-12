//
//  CJDownloadEnumUtil.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJDownloadEnumUtil.h"

@implementation CJDownloadEnumUtil

+ (NSString *)currentStateTextForState:(CJFileDownloadState)state {
    switch (state) {
        case CJFileDownloadStateReady:
            return NSLocalizedStringFromTable(@"下载准备", @"LocalizableDownloader", nil);
        case CJFileDownloadStateDownloading:
            return NSLocalizedStringFromTable(@"下载中", @"LocalizableDownloader", nil);
        case CJFileDownloadStatePause:
            return NSLocalizedStringFromTable(@"暂停", @"LocalizableDownloader", nil);
        case CJFileDownloadStateSuccess:
            return NSLocalizedStringFromTable(@"下载成功", @"LocalizableDownloader", nil);
        case CJFileDownloadStateFailure:
            return NSLocalizedStringFromTable(@"下载失败", @"LocalizableDownloader", nil);
        default:
            return NSLocalizedStringFromTable(@"未知", @"LocalizableDownloader", nil);
            break;
    }
}

+ (NSString *)nextStateTextForState:(CJFileDownloadState)state {
    switch (state) {
        case CJFileDownloadStateReady:
            return NSLocalizedStringFromTable(@"开始", @"LocalizableDownloader", nil);
        case CJFileDownloadStateDownloading:
            return NSLocalizedStringFromTable(@"暂停", @"LocalizableDownloader", nil);
        case CJFileDownloadStatePause:
            return NSLocalizedStringFromTable(@"继续", @"LocalizableDownloader", nil);
        case CJFileDownloadStateSuccess:
            return NSLocalizedStringFromTable(@"完成", @"LocalizableDownloader", nil);
        case CJFileDownloadStateFailure:
            return NSLocalizedStringFromTable(@"重下", @"LocalizableDownloader", nil);
        default:
            return NSLocalizedStringFromTable(@"未知", @"LocalizableDownloader", nil);
            break;
    }
}

@end

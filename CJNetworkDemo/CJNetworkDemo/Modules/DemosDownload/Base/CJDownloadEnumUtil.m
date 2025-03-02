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
            return @"下载准备";
        case CJFileDownloadStateDownloading:
            return @"下载中";
        case CJFileDownloadStatePause:
            return @"暂停";
        case CJFileDownloadStateSuccess:
            return @"下载成功";
        case CJFileDownloadStateFailure:
            return @"下载失败";
        default:
            return @"未知";
            break;
    }
}

+ (NSString *)nextStateTextForState:(CJFileDownloadState)state {
    switch (state) {
        case CJFileDownloadStateReady:
            return @"开始";
        case CJFileDownloadStateDownloading:
            return @"暂停";
        case CJFileDownloadStatePause:
            return @"继续";
        case CJFileDownloadStateSuccess:
            return @"完成";
        case CJFileDownloadStateFailure:
            return @"重下";
        default:
            return @"未知";
            break;
    }
}

@end

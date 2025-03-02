//
//  CJDownloadEnumUtil.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CJFileDownloadState) {
    CJFileDownloadStateUnknown,         // 未知
    CJFileDownloadStateReady,           // 可以下载（显示开始下载）
    CJFileDownloadStatePause,           // 暂停下载（显示继续下载）
    CJFileDownloadStateDownloading,     // 下载中（显示暂停下载）
    CJFileDownloadStateSuccess,         // 下载完成（显示删除下载）
    CJFileDownloadStateFailure,         // 下载失败（显示重新下载）
};


NS_ASSUME_NONNULL_BEGIN

@interface CJDownloadEnumUtil : NSObject

+ (NSString *)currentStateTextForState:(CJFileDownloadState)state;

+ (NSString *)nextStateTextForState:(CJFileDownloadState)state;

@end

NS_ASSUME_NONNULL_END

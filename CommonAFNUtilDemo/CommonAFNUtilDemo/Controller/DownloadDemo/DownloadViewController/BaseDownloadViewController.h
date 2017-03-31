//
//  BaseDownloadViewController.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2017/3/31.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PKGURL  @"http://big1.wy119.com/droid4X.pkg"

typedef NS_ENUM(NSUInteger, CJFileDownloadState) {
    CJFileDownloadStateDownloadReadyOrPause,
    CJFileDownloadStateDownloading,
    CJFileDownloadStateDownloadFinish,
};

@interface BaseDownloadViewController : UIViewController {
    
}
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

- (void)updateButtonByDownloadState:(CJFileDownloadState)downloadState;
- (void)updateProgress:(CGFloat)progress;

- (void)pause;

- (void)download;

/** 删除下载的文件(以便重新下载) */
- (IBAction)deleteDownloadFile:(id)sender;

@end

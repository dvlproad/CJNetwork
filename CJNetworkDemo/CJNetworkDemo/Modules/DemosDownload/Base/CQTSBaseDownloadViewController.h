//
//  CQTSBaseDownloadViewController.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJDownloadEnumUtil.h"

#define PKGURL  @"http://big1.wy119.com/droid4X.pkg"

@interface CQTSBaseDownloadViewController : UIViewController {
    
}
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

- (void)updateButtonByDownloadState:(CJFileDownloadState)downloadState;
- (void)updateProgress:(CGFloat)progress;

/*
 *  初始化文件上传时候的上传模型
 *
 *  @param downloadHandle       开始下载的事件
 *  @param pauseHandle          暂停下载的事件
 *  @param deleteHandle         删除下载文件的事件
 */
- (instancetype)initWithDownloadHandle:(void (^)(void))downloadHandle
                           pauseHandle:(void (^)(void))pauseHandle
                          deleteHandle:(void (^)(void))deleteHandle NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

@end

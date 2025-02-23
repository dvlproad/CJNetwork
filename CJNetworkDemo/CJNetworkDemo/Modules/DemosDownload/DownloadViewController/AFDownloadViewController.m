//
//  AFDownloadViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "AFDownloadViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface AFDownloadViewController () {
    
}
@property (nonatomic, weak) IBOutlet UIButton *downloadButton;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;   /**< 下载操作 */

@end



@implementation AFDownloadViewController

- (instancetype)initWithNibName
{
    __weak typeof(self)weakSelf = self;
    self = [super initWithDownloadHandle:^{
        [weakSelf download];
    } pauseHandle:^{
        [weakSelf pause];
    } deleteHandle:^{
        [weakSelf deleteDownloadFile];
    }];
    
    if (self) {
        
    }
    return self;
}


- (void)download {
    [_downloadTask resume];
}

- (void)pause {
    [_downloadTask suspend];
}

/** 删除下载的文件(以便重新下载)  */
- (void)deleteDownloadFile {
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"使用AFN进行下载", nil);
    
    self.progressView.progress = 0;
    
    
    NSString *movieUrl = @"https://github.com/dvlproad/001-UIKit-CQDemo-iOS/blob/1de60c07fba6fa5d29a49e982a4fc02f22e21d9d/CQDemoKit/Demo_Resource/LocDataModel/Resources/mp4/vap.mp4";
    _downloadTask =
    [self createDownloadTaskWithUrl:movieUrl progress:^(NSProgress *downloadProgress) {
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);//当前已经下载的大小/文件的总大小
        
        //回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            [self updateProgress:progress];
        });
        
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        
        //NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
        //UIImage *img = [UIImage imageWithContentsOfFile:imgFilePath];
        //self.imageView.image = img;
        [self updateButtonByDownloadState:CJFileDownloadStateSuccess];
    }];
}

- (NSURLSessionDownloadTask *)createDownloadTaskWithUrl:(NSString *)url
                                               progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                            destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                      completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //下载Task操作
     NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                      progress:downloadProgressBlock
                                                                   destination:destination
                                                             completionHandler:completionHandler];
    
    return downloadTask;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

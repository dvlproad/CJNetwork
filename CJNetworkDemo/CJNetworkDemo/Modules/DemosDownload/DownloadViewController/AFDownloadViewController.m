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
    
    
    NSString *movieUrl = @"https://v9-default.365yg.com/3b1ab8c13231762702f76c102ded6249/67a8a1a2/video/tos/cn/tos-cn-ve-15/ok492pE6eFAoNnDnAv3GD4gIDfA7FAQxqBAnwE/?a=2011&ch=0&cr=0&dr=0&cd=0%7C0%7C0%7C0&cv=1&br=2371&bt=2371&cs=0&ds=3&ft=aT_7TQQqUYqfJEZPo0OW_QYaUqiX1bzQoVJEwDC7MCPD-Ipz&mime_type=video_mp4&qs=0&rc=Ozw2OTQ6Z2g8ODxoPDVnZkBpM2t0OHU5cmtqeDMzNGkzM0A2YGM0Li82XjExYy5jMzQzYSNwaXMtMmRrb2dgLS1kLTBzcw%3D%3D&btag=c0000e00010000&dy_q=1739101057&feature_id=aa7df520beeae8e397df15f38df0454c&l=20250209193737ABBFAE4CBFF775918DE8";
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
        [self updateButtonByDownloadState:CJFileDownloadStateDownloadFinish];
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

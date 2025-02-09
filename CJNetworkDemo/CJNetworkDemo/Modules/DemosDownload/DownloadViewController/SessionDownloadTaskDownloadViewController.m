//
//  SessionDownloadTaskDownloadViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "SessionDownloadTaskDownloadViewController.h"
#import <CQDemoKit/CJUIKitAlertUtil.h>

#import <AFNetworking/AFNetworking.h>

@interface SessionDownloadTaskDownloadViewController () {
    
}
@property (nonatomic, weak) IBOutlet UIButton *downloadButton;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;   /**< 下载操作 */

@property (nonatomic, strong) NSURLSession *backgroundURLSession;

@property (nonatomic, copy) NSString *cacheDirectory;       /**< 缓存的目录 */
@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, strong) NSData *resumeData;
@property (nonatomic, assign) BOOL downloading;

@end



@implementation SessionDownloadTaskDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.progressView.progress = 0;
    
    NSLog(@"home = %@", NSHomeDirectory());
    
    self.cacheDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    /*
    _downloadTask =
    [self createDownloadTaskWithUrl:@"http://mw5.dwstatic.com/1/3/1528/133489-99-1436409822.mp4" progress:^(NSProgress *downloadProgress) {
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);//当前已经下载的大小/文件的总大小
        
        //回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        });
        
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        
        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
        UIImage *img = [UIImage imageWithContentsOfFile:imgFilePath];
        //self.imageView.image = img;
        [self.downloadButton setTitle:@"完成" forState:UIControlStateNormal];
    }];
    */
}

- (IBAction)downloadButtonClick:(UIButton *)button {
    button.selected = !button.isSelected;
    
    if (button.selected) {
        self.downloadTask = [self downloadTaskWithUrl:@"http://mw5.dwstatic.com/1/3/1528/133489-99-1436409822.mp4"];
        
    } else {
//        [_downloadTask suspend];
        
        //如果是可恢复的下载任务，应该先将数据保存到partialData中，注意在这里不要调用cancel方法
        [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            self.downloadTask = nil;
            
            [self copyUnfinishDownloadFileToSafeDirectory];
        }];
    }
}

/*
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
*/


- (NSURLSessionDownloadTask *)downloadTaskWithUrl:(NSString *)url {
    NSURL *downloadURL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:downloadURL];
    
    NSURLSessionDownloadTask *downloadTask = nil;
    
    NSString *currentFileName = [url lastPathComponent];
    NSString *currentFilePath = [self.cacheDirectory stringByAppendingPathComponent:currentFileName];
    NSData *fileData = [NSData dataWithContentsOfFile:currentFilePath];
    
    if (fileData) {
        downloadTask = [self.backgroundURLSession downloadTaskWithResumeData:fileData];
        
//        NSString *Caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
//        [[NSFileManager defaultManager] removeItemAtPath:Caches error:nil];
//        
//        [self MoveDownloadFile];
        
    } else {
        downloadTask = [self.backgroundURLSession downloadTaskWithRequest:request];
    }
    
    downloadTask.taskDescription = [NSString stringWithFormat:@"后台下载"];
    
    [downloadTask resume];
    
    return downloadTask;
}

- (NSURLSession *)backgroundURLSession
{
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *identifier = @"background";
        NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
        session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                delegate:self
                                           delegateQueue:[NSOperationQueue mainQueue]];
    });
    return session;
    
}



//暂停下载,获取文件指针和缓存文件
- (void)downloadPause:(NSString *)fileName
{
    if (!self.downloading)
    {
        return;
    }
    
    NSLog(@"%s",__func__);
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumeData = resumeData;
        self.downloadTask = nil;
        [resumeData writeToFile:self.filePath atomically:YES];
        
        [self copyUnfinishDownloadFileToSafeDirectory];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //做完保存操作之后让他继续下载
            if (resumeData) {
                self.downloadTask = [self.backgroundURLSession downloadTaskWithResumeData:resumeData];
                [self.downloadTask resume];
            }
        });
    }];
}

//未下载完成的文件存放在temp目录下，而又由于tmp中的文件随时有可能被删除，所以为了确保能利用之前未下载完成的文件，我们这里讲tmp中未下载完成的网络文件(该网络文件会以"CFNetworkDownload"开头)移动到安全目录下，以此来防止其被删除
- (void)copyUnfinishDownloadFileToSafeDirectory
{
    NSString *safeDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSArray *tempSubpaths = [[NSFileManager defaultManager] subpathsAtPath:NSTemporaryDirectory()];
    
    for (NSString *tempSubpath in tempSubpaths)
    {
        if ([tempSubpath rangeOfString:@"CFNetworkDownload"].length > 0) {
            NSString *tmpPath = [NSTemporaryDirectory() stringByAppendingPathComponent:tempSubpath];
            
            NSString *safePath = [safeDirectory stringByAppendingPathComponent:tempSubpath];
            [[NSFileManager defaultManager] copyItemAtPath:tmpPath toPath:safePath error:nil];
            [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
        }
    }
}

//讲道理这个和上面的应该封装下
- (void)MoveDownloadFile
{
    NSArray *subpaths = [[NSFileManager defaultManager] subpathsAtPath:self.cacheDirectory];
    
    for (NSString *subpath in subpaths) {
        if ([subpath rangeOfString:@"CFNetworkDownload"].length>0)
        {
            NSString *docFilePath = [self.cacheDirectory stringByAppendingPathComponent:subpath];
            NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:subpath];
            //反向移动
            [[NSFileManager defaultManager] copyItemAtPath:docFilePath toPath:path error:nil];
            
            //建议创建一个plist表来管理,可以通过task的response的***name获取到文件名称,kvc存储或者直接建立数据库来进行文件管理,不然文件多了可能会管理混乱;
        }
    }
    NSLog(@"%@,%@",subpaths,[[NSFileManager defaultManager] subpathsAtPath:NSTemporaryDirectory()]);
}


#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"%s", __func__);
    
    self.downloading = NO;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    self.downloading = NO;
    
    [CJUIKitAlertUtil showCancleOKAlertInViewController:self withTitle:@"温馨提示" message:@"亲，您的文件下载好了，快去看看吧" cancleBlock:nil okBlock:nil];
    
    //下载完成缓存到以下目录,并删除源文件
    NSString *downloadfileName = downloadTask.response.suggestedFilename;
    NSString *saveTofilePath = [self.cacheDirectory stringByAppendingPathComponent:downloadfileName];
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:saveTofilePath] error:nil];
    [[NSFileManager defaultManager] removeItemAtURL:location error:nil];
    
    NSLog(@"下载完成：将源文件从%@缓存到以下目录%@", location, saveTofilePath);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    self.downloading = YES;
    
    CGFloat percent = 100.0 * totalBytesWritten/totalBytesExpectedToWrite;
    NSString *percentString = [NSString stringWithFormat:@"下载中,进度为%.2f%%", percent];
    NSLog(@"percent = %@", percentString);
    self.progressView.progress = totalBytesWritten/totalBytesExpectedToWrite;
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

//
//  SessionDataTaskDownloadViewController.m
//  CJNetworkDemo
//
//  Created by dvlproad on 2017/3/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "SessionDataTaskDownloadViewController.h"
#import "MQLResumeManager.h"

@interface SessionDataTaskDownloadViewController () {
    
}

@property (nonatomic, strong) MQLResumeManager *manager;
@property (nonatomic, strong) NSString *targetPath;



@end



@implementation SessionDataTaskDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)pause {
    [self.manager cancel];
    self.manager = nil;
}


-(void)download {
    //1.准备
    if (self.manager) {
        [self pause];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    self.targetPath = [documentsDirectory stringByAppendingPathComponent:@"myPic"];
    
    NSURL *url = [NSURL URLWithString:@"http://p1.pichost.me/i/40/1639665.png"];
    
    self.manager = [MQLResumeManager resumeManagerWithURL:url targetPath:self.targetPath success:^{
        
        NSLog(@"success");
        self.imageView.image = [UIImage imageWithContentsOfFile:self.targetPath];
        [self updateButtonByDownloadState:CJFileDownloadStateDownloadFinish];
        
    } failure:^(NSError *error) {
        NSLog(@"failure");
        
    } progress:^(long long totalReceivedContentLength, long long totalContentLength) {
        
        float percent = 1.0 * totalReceivedContentLength / totalContentLength;
        [self updateProgress:percent];
    }];
    
    //2.启动
    [self.manager start];
    
}



/** 删除下载的文件(以便重新下载) */
- (IBAction)deleteDownloadFile:(id)sender {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:self.targetPath error:&error];
    if (error == nil) {
        self.imageView.image = [UIImage imageWithContentsOfFile:self.targetPath];
        [self updateProgress:0];
        [self updateButtonByDownloadState:CJFileDownloadStateDownloadReadyOrPause];
    }
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

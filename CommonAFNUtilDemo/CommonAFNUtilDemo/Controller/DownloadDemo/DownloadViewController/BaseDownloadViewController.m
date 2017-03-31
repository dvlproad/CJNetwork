//
//  BaseDownloadViewController.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2017/3/31.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "BaseDownloadViewController.h"

@interface BaseDownloadViewController ()

@property (nonatomic, weak) IBOutlet UIButton *downloadButton;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, weak) IBOutlet UILabel *progressLabel;

@property (nonatomic, assign) CJFileDownloadState downloadState;

@end



@implementation BaseDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)downloadButtonClick:(UIButton *)button {
    switch (self.downloadState) {
        case CJFileDownloadStateDownloadReadyOrPause:   //准备下载，点击之后开始下载
        {
            [self updateButtonByDownloadState:CJFileDownloadStateDownloading];
            [self download];
            break;
        }
        case CJFileDownloadStateDownloading: //正在下载，点击之后变成暂停
        {
            [self updateButtonByDownloadState:CJFileDownloadStateDownloadReadyOrPause];
            [self pause];
            break;
        }
        default:
            break;
    }
}

- (void)pause {
    
}


- (void)download {
    
}


- (void)updateButtonByDownloadState:(CJFileDownloadState)downloadState {
    self.downloadState = downloadState;
    switch (downloadState) {
        case CJFileDownloadStateDownloadReadyOrPause:
        {
            [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
            [self.downloadButton setEnabled:YES];
            self.deleteButton.hidden = YES;
            break;
        }
        case CJFileDownloadStateDownloading:
        {
            [self.downloadButton setTitle:@"暂停" forState:UIControlStateNormal];
            [self.downloadButton setEnabled:YES];
            self.deleteButton.hidden = YES;
            break;
        }
        case CJFileDownloadStateDownloadFinish:
        {
            [self.downloadButton setTitle:@"完成" forState:UIControlStateNormal];
            [self.downloadButton setEnabled:NO];
            self.deleteButton.hidden = NO;
            
            break;
        }
        default:
            break;
    }
}

- (void)updateProgress:(CGFloat)progress {
    if (progress == 0) {
        self.progressView.progress = 0;
        self.progressLabel.text = nil;
    } else {
        NSString *strPersent = [[NSString alloc]initWithFormat:@"%.f", progress *100];
        self.progressView.progress = progress;
        self.progressLabel.text = [NSString stringWithFormat:@"已下载%@%%", strPersent];
    }
}

/** 完整的描述请参见文件头部 */
- (IBAction)deleteDownloadFile:(id)sender {
    
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

//
//  CQTSBaseDownloadViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CQTSBaseDownloadViewController.h"
#import <Masonry/Masonry.h>

@interface CQTSBaseDownloadViewController ()

@property (nonatomic, weak) IBOutlet UIButton *downloadButton;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, weak) IBOutlet UILabel *progressLabel;

@property (nonatomic, assign) CJFileDownloadState downloadState;

@property (nonatomic, copy) void (^downloadHandle)(void);
@property (nonatomic, copy) void (^pauseHandle)(void);
@property (nonatomic, copy) void (^deleteHandle)(void);

@end



@implementation CQTSBaseDownloadViewController

- (instancetype)initWithDownloadHandle:(void (^)(void))downloadHandle
                           pauseHandle:(void (^)(void))pauseHandle
                          deleteHandle:(void (^)(void))deleteHandle
{
    self = [super initWithNibName:@"CQTSBaseDownloadViewController" bundle:nil];
    if (self) {
        self.downloadHandle = downloadHandle;
        self.pauseHandle = pauseHandle;
        self.deleteHandle = deleteHandle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
- (void)setupViews {
    UILabel *progressValueLabel = [[UILabel alloc] init];
    [self.view addSubview:progressValueLabel];
    [progressValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(40);
        make.height.equalTo(@20);
        make.left.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
    }];
    progressValueLabel.text = @"0%";
    self.progressLabel = progressValueLabel;
    
    UIProgressView *progressView = [[UIProgressView alloc] init];
    [self.view addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressLabel.mas_bottom).offset(10);
        make.height.equalTo(@2);
        make.left.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
    }];
    self.progressView = progressView;
}
*/

- (IBAction)downloadButtonClick:(UIButton *)button {
    switch (self.downloadState) {
        case CJFileDownloadStateReady:   //准备下载，点击之后开始下载
        case CJFileDownloadStatePause:   //暂停下载，点击之后继续下载
        {
            [self updateButtonByDownloadState:CJFileDownloadStateDoing];
            self.downloadHandle();
            break;
        }
        case CJFileDownloadStateDoing: //正在下载，点击之后变成暂停
        {
            [self updateButtonByDownloadState:CJFileDownloadStatePause];
            self.pauseHandle();
            break;
        }
        default:
            break;
    }
}


- (void)updateButtonByDownloadState:(CJFileDownloadState)downloadState {
    self.downloadState = downloadState;
    switch (downloadState) {
        case CJFileDownloadStateReady:   //准备下载，点击之后开始下载
        case CJFileDownloadStatePause:   //暂停下载，点击之后继续下载
        {
            [self.downloadButton setTitle:downloadState == CJFileDownloadStateReady ? @"下载" : @"继续" forState:UIControlStateNormal];
            [self.downloadButton setEnabled:YES];
            self.deleteButton.hidden = YES;
            break;
        }
        case CJFileDownloadStateDoing:
        {
            [self.downloadButton setTitle:@"暂停" forState:UIControlStateNormal];
            [self.downloadButton setEnabled:YES];
            self.deleteButton.hidden = YES;
            break;
        }
        case CJFileDownloadStateSuccess:
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
- (IBAction)deleteDownloadFileAction:(id)sender {
    self.deleteHandle();
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

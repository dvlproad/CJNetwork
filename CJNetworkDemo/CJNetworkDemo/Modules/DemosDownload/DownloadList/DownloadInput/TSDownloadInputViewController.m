//
//  TSDownloadInputViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//
//  要解析的地址的输入界面

#import "TSDownloadInputViewController.h"
#import <CQDemoKit/CJUIKitAlertUtil.h>
#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CQDemoKit/NSError+CQTSErrorString.h>
#import <CQDemoKit/CQTSLocImagesUtil.h>
#import <CJBaseUIKit/UIView+CJAutoMoveUp.h>
#import <CJMonitor/CJLogSuspendWindow.h>
#import <CQVideoUrlAnalyze_Swift/CQVideoUrlAnalyze_Swift-Swift.h>
#import <CJNetwork_Swift/CJNetwork_Swift-Swift.h>
#import <CQDemoKit/CQTSSandboxPathUtil.h>

#import <CJNetwork/AFHTTPSessionManager+CJSerializerEncrypt.h>
#import <CJNetwork/CQDemoHTTPSessionManager.h>

#import <CQOverlayKit/CQHUDUtil.h>
#import <CQOverlayKit/CQIndicatorHUDUtil.h>

// 下载
#import "HSDownloadManager.h"

#import "TSDownloadInputView.h"

#import "TSDownloadVideoIdManager.h"

#import "TSDownloadCollectionViewController.h"
#import "TSDownloadCollectionViewCell.h"

@interface TSDownloadInputViewController () {
    
}
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) TSDownloadInputView *downloadInputView;

@end

@implementation TSDownloadInputViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.downloadInputView pasteClipboard];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (TSDownloadInputView *)downloadInputView {
    if (!_downloadInputView) {
        __weak typeof(self)weakSelf = self;
        _downloadInputView = [[TSDownloadInputView alloc] initWithFetchVideoHandle:^(NSString * _Nonnull text) {
//            [self fetchVideo];
//            [CJUIKitToastUtil showMessage:NSLocalizedStringFromTable(@"可在此执行下载", @"LocalizableDownloader", nil)];
//            [weakSelf tikwm_analyzeTiktokShortenedUrl:text failure:^(NSString * _Nonnull errorMessage) {
//                [CJUIKitToastUtil showMessage:errorMessage];
//            }];
            // 先本地解析，若失败再用第三方解析
            //[CQHUDUtil showLoadingHUD];
            [CQIndicatorHUDUtil showLoadingHUD:@"解析中"];
//            [weakSelf local_analyzeTiktokShortenedUrl:text failure:^(NSError * _Nonnull error) {
                [weakSelf tikwm_analyzeTiktokShortenedUrl:text failure:^(NSString * _Nonnull errorMessage) {
                    [CJUIKitToastUtil showMessage:errorMessage];
                }];
//            }];
        }];
    }
    return _downloadInputView;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 监听键盘弹出
    //[self.downloadInputView cj_registerKeyboardNotificationWithAutoMoveUpSpacing:30 hasSpacing:YES];
}

- (void)dealloc {
    [self.downloadInputView cj_removeKeyboardNotification];
}

- (void)registerKeyboardNotification {
    __weak typeof(self)weakSelf = self;
    [self.downloadInputView cj_registerKeyboardNotificationWithWillShowBlock:nil willHideBlock:nil willChangeFrameBlock:^(CGFloat keyboardHeight, CGFloat keyboardTopY, CGFloat duration) {
        [weakSelf.downloadInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (keyboardHeight > 0) {
                CGFloat defaultTabBarHeight = 49.0;
                make.bottom.mas_equalTo(weakSelf.mas_bottomLayoutGuide).offset(-keyboardHeight+defaultTabBarHeight);
            } else {
                make.bottom.mas_equalTo(weakSelf.mas_bottomLayoutGuideTop).offset(-30);
            }
        }];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationItem.title = NSLocalizedStringFromTable(@"视频解析", @"LocalizableDownloader", nil);
    
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
//        make.height.mas_equalTo(200);
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).offset(-0);
    }];
    UIImage *image = [UIImage cqdemokit_xcassetImageNamed:@"cqts_icon_01.png" withCache:YES];
    [self.imageView setImage:image];
    
    [self.view addSubview:self.downloadInputView];
    [self.downloadInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        //make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.height.mas_equalTo(110);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).offset(-30);
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self registerKeyboardNotification];
    
//    NSString *shortenedUrl = @"https://www.tiktok.com/t/ZT2fyo8FN/";
    NSString *shortenedUrl = @"https://www.tiktok.com/t/ZT2mkNaFw/";
//    NSString *shortenedUrl = @"https://vt.tiktok.com/ZSMVE5Qdh/";
//    NSString *shortenedUrl = @"https://vt.tiktok.com/ZSMVKbhkh/";
    self.downloadInputView.textField.text = shortenedUrl;
}

- (void)dismissKeyboard {
    [self.view endEditing:YES]; // 让当前 view 内的所有子视图（如 UITextField）失去第一响应者，从而关闭键盘
}

- (void)tikwm_analyzeTiktokShortenedUrl:(NSString *)shortenedUrl failure:(void (^)(NSString * _Nonnull))failure {
    __weak typeof(self)weakSelf = self;
    
    CQAnalyzeVideoUrlType type = CQAnalyzeVideoUrlTypeVideoWithoutWatermarkHD;
    [CQVideoUrlAnalyze_Tiktok requestUrlFromShortenedUrl:shortenedUrl type:type success:^(NSString * _Nonnull expandedUrl, NSString * _Nonnull videoId, NSString * _Nonnull videoUrl) {
        NSString *message = [NSString stringWithFormat:@"解析结果如下:\nexpandedUrl=%@\nvideoId=%@\nvideoUrl=%@", expandedUrl, videoId, videoUrl];
        [self __showResponseLogMessage:message];
        
        // 添加数据
        NSArray *records = [TSDownloadVideoIdManager.sharedInstance getRecordsForVideoId:videoId];
        CQDownloadRecordModel *downloadRecordModel = records.firstObject;
        downloadRecordModel.downloadMethod = CJFileDownloadMethodProgress;
        [CQDownloadCacheUtil process_addRecord:downloadRecordModel];
        [TSDownloadVideoIdManager.sharedInstance addDownloadRecoredModels:@[downloadRecordModel]];
        // 跳转到"已解析"Tab
        dispatch_async(dispatch_get_main_queue(),^{
            //[CJUIKitAlertUtil showCancleOKAlertInViewController:self withTitle:@"解析成功，是否下载" message:videoUrl cancleBlock:nil okBlock:^{
                [weakSelf __goRecordsPage];
                
                // addVideoByVideoId 插入在第一个位置
//                TSDownloadCollectionViewCell *cell = [vc.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
//                [cell.downloadView startDownload];
                [weakSelf downloadFileUrlRecord:downloadRecordModel];
            //}];
        });
    } failure:^(NSString * _Nonnull errorMessage) {
        [self __showResponseLogMessage:errorMessage];
        failure(errorMessage);
    }];
}

- (void)local_analyzeTiktokShortenedUrl:(NSString *)shortenedUrl failure:(void (^)(NSError * _Nonnull))failure {
    __weak typeof(self)weakSelf = self;
    
    CQDownloadRecordModel *downloadRecordModel = [[CQDownloadRecordModel alloc] init];
    downloadRecordModel.url = shortenedUrl;
    
    // 添加数据
    //downloadRecordModel.downloadState = CJFileDownloadStateSuccess;
    [CQDownloadCacheUtil nototal_addRecord:downloadRecordModel withDownloadState:CJFileDownloadStateReady];
    [TSDownloadVideoIdManager.sharedInstance addDownloadRecoredModels:@[downloadRecordModel]];
    [weakSelf __goRecordsPage];
    
    [TikTokService getActualVideoUrlFromShortenedUrl:shortenedUrl success:^(NSString * _Nonnull videoUrl) {
        dispatch_async(dispatch_get_main_queue(),^{
            [CQDownloadCacheUtil nototal_updateRecord:downloadRecordModel withDownloadState:CJFileDownloadStateDownloading];
            
            //[CJUIKitAlertUtil showCancleOKAlertInViewController:self withTitle:NSLocalizedStringFromTable(@"解析成功，是否下载", @"LocalizableDownloader", nil) message:videoUrl cancleBlock:nil okBlock:^{
                [TikTokService downloadAccessRestrictedDataFromActualVideoUrl:videoUrl saveToLocalURLGetter:^NSURL * _Nonnull(NSString * _Nonnull videoFileExtension) {
                    NSString *saveToAbsPath = downloadRecordModel.saveToAbsPath;
                    return [NSURL fileURLWithPath:saveToAbsPath];
                    
                } success:^(NSURL * _Nonnull cacheURL) {
                    dispatch_async(dispatch_get_main_queue(),^{
                        NSString *message = [NSString stringWithFormat:@"解析并且下载成功:\n视频短链=%@\n视频地址=%@\n保存位置=%@", shortenedUrl, videoUrl, cacheURL.absoluteString];
                        [self __showResponseLogMessage:message];
                        
                        [CQDownloadCacheUtil nototal_updateRecord:downloadRecordModel withDownloadState:CJFileDownloadStateSuccess];
                    });
                    
                } failure:^(NSError * _Nonnull error) {
                    [self __showResponseLogMessage:error.localizedDescription];
                    failure(error);
                }];
            //}];
        });
    } failure:^(NSError * _Nonnull error) {
        [self __showResponseLogMessage:error.localizedDescription];
        failure(error);
    }];
}

- (void)__goRecordsPage {
    [CQHUDUtil dismissLoadingHUD];
    
    [self.tabBarController setSelectedIndex:1];
    UINavigationController *rootVC = [self.tabBarController selectedViewController];
    TSDownloadCollectionViewController *vc = rootVC.childViewControllers.firstObject;
    vc.collectionView.sectionDataModels = [TSDownloadVideoIdManager.sharedInstance sectionDataModels];
}

- (void)downloadFileUrlRecord:(CQDownloadRecordModel *)downloadRecordModel {
    //__weak typeof(self)weakSelf = self;
    [[HSDownloadManager sharedInstance] downloadOrPause:downloadRecordModel progressBlock:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        /*
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *progressValue = [NSString stringWithFormat:@"%.f%%", progress * 100];
            NSString *message = [NSString stringWithFormat:@"1当前下载进度:=========%@", progressValue];
            [self __showResponseLogMessage:message];
        });
        */
    } state:^(CJFileDownloadState state, NSError * _Nullable error) {
        /*
        dispatch_async(dispatch_get_main_queue(), ^{
            [self __showResponseLogMessage:[CJDownloadEnumUtil currentStateTextForState:state]];
            
            switch (state) {
                case CJFileDownloadStateReady:{
                    break;
                }
                case CJFileDownloadStateDownloading: {
                    break;
                }
                case CJFileDownloadStatePause: {
                    break;
                }
                case CJFileDownloadStateSuccess: {
                    NSString *localAbsPath = [[HSDownloadManager sharedInstance] fileLocalAbsPathForUrl:downloadUrl];
                    NSString *message = [NSString stringWithFormat:@"下载完成，存放在:%@", localAbsPath];
                    [self __showResponseLogMessage:message];
                    
                    
                    if (weakSelf.tabBarController.selectedIndex == 1) {
                        UINavigationController *rootVC = [self.tabBarController selectedViewController];
                        TSDownloadCollectionViewController *vc = rootVC.childViewControllers.firstObject;
                        [vc.collectionView reloadData];
                    }
                    
                    break;
                }
                case CJFileDownloadStateFailure: {
                    [self __showResponseLogMessage:error.cqtsErrorString];
                    break;
                }
                default:
                    break;
            }
        });
        */
    }];
}



#pragma mark - Private Method
- (void)fetchTikTokData {
    // 设置 API URL（这是你提供的 URL）
    NSString *urlString = @"https://tiktok-api23.p.rapidapi.com/your-endpoint";
    
    // 创建 NSURL 对象
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 创建 NSMutableURLRequest 对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 设置 HTTP 方法为 GET
    [request setHTTPMethod:@"GET"];
    
    // 添加 RapidAPI 的认证头
    [request setValue:@"your-rapidapi-key" forHTTPHeaderField:@"X-RapidAPI-Key"];
    [request setValue:@"tiktok-api23.p.rapidapi.com" forHTTPHeaderField:@"X-RapidAPI-Host"];
    
    // 创建 URLSession
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 创建数据任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            // 处理响应数据
            NSError *jsonError;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError) {
                NSLog(@"JSON Parsing Error: %@", jsonError.localizedDescription);
            } else {
                NSLog(@"Response: %@", jsonResponse);
            }
        }
    }];
    
    // 启动请求
    [dataTask resume];
}


/// 显示返回结果log
- (void)__showResponseLogMessage:(NSString *)message {
    //[CJUIKitToastUtil showMessage:message];
//    [CJLogViewWindow appendObject:message];
    NSLog(@"%@", message);
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

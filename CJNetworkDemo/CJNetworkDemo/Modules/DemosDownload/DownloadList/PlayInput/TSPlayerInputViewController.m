//
//  TSPlayerInputViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//
//  要播放的视频地址的输入界面

#import "TSPlayerInputViewController.h"
#import <CQDemoKit/CJUIKitAlertUtil.h>
#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CQDemoKit/NSError+CQTSErrorString.h>
#import <CQDemoKit/CQTSLocImagesUtil.h>
#import <CJBaseUIKit/UIView+CJAutoMoveUp.h>
#import <CJMonitor/CJLogSuspendWindow.h>
#import <CQVideoUrlAnalyze_Swift/CQVideoUrlAnalyze_Swift-Swift.h>

#import <CJNetwork/AFHTTPSessionManager+CJSerializerEncrypt.h>
#import <CJNetwork/CQDemoHTTPSessionManager.h>

#import "TestNetworkClient.h"

// 下载
#import "HSDownloadManager.h"

#import "TSPlayerInputView.h"

#import "TSDownloadVideoIdManager.h"

#import "TSInputPlayerViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <PhotosUI/PhotosUI.h>

@interface TSPlayerInputViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate> {
    
}
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) TSPlayerInputView *downloadInputView;

@end

@implementation TSPlayerInputViewController

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

- (TSPlayerInputView *)downloadInputView {
    if (!_downloadInputView) {
        __weak typeof(self)weakSelf = self;
        _downloadInputView = [[TSPlayerInputView alloc] initWithFetchVideoHandle:^(NSString * _Nonnull text) {
            [weakSelf tryPlayNetworkUrl:text];
        }];
    }
    return _downloadInputView;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.downloadInputView cj_registerKeyboardNotificationWithAutoMoveUpSpacing:30 hasSpacing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationItem.title = NSLocalizedString(@"视频解析", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"从相册中选择" style:UIBarButtonItemStylePlain target:self action:@selector(chooseVideoFromSystem)];
    
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
//        make.height.mas_equalTo(200);
//        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).offset(-0);
    }];
//    UIImage *image = [UIImage cqdemokit_xcassetImageNamed:@"cqts_icon_01.png" withCache:YES];
    UIImage *image = [CQTSLocImagesUtil cjts_localImageBG1];
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
    
//    NSString *shortenedUrl = @"https://www.tiktok.com/t/ZT2fyo8FN/";
    NSString *shortenedUrl = @"https://www.tiktok.com/t/ZT2mkNaFw/";
    self.downloadInputView.textField.text = shortenedUrl;
    self.downloadInputView.textField.text = @"https://www.tikwm.com/video/media/hdplay/7465611957203160340.mp4";
}

- (void)dismissKeyboard {
    [self.view endEditing:YES]; // 让当前 view 内的所有子视图（如 UITextField）失去第一响应者，从而关闭键盘
}


- (void)tryPlayNetworkUrl:(NSString *)networkUrl {
    // 判断 networkUrl 是不是有效的网络地址
    if (networkUrl.length == 0) {
        [CJUIKitToastUtil showMessage:@"请先输入视频地址"];
        return;
    }
    
    if (![networkUrl hasPrefix:@"http://"] && ![networkUrl hasPrefix:@"https://"]) {
        [CJUIKitToastUtil showMessage:@"请输入有效的视频地址"];
        return;
    }
    NSURL *videoURL = [NSURL URLWithString:networkUrl];
    [self playVideoURL:videoURL];
}

/// 相册是 assets-library://asset/asset.MP4?id=4FA00137-ECF1-4693-A976-2605D12A207D&ext=MP4
- (void)playVideoURL:(NSURL *)videoURL {
    //__weak typeof(self)weakSelf = self;
    TSInputPlayerViewController *playerViewController = [[TSInputPlayerViewController alloc] initWithVideoURL:videoURL];
    playerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:playerViewController animated:YES completion:^{
        
    }];
}


/// 显示返回结果log
- (void)__showResponseLogMessage:(NSString *)message {
    //[CJUIKitToastUtil showMessage:message];
//    [CJLogViewWindow appendObject:message];
    NSLog(@"%@", message);
}


#pragma mark - 从相册中选择视频
// 从相册中选择视频
- (void)chooseVideoFromSystem {
    if (@available(iOS 14, *)) { // （使用 PHPickerViewController）
        [self chooseVideoFromSystemIOS14];
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];// 设置类型
    // 设置所支持的类型，设置只能拍照，或则只能录像，或者两者都可以
    //[imagePickerController setMediaTypes:@[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]];
    [imagePickerController setMediaTypes:@[(NSString *)kUTTypeMovie]]; // 仅支持视频
    
    [imagePickerController setDelegate:self];
    imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh; // 视频质量
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)chooseVideoFromSystemIOS14 API_AVAILABLE(ios(14)) {
    PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
    config.filter = [PHPickerFilter videosFilter]; // 仅选择视频
    config.selectionLimit = 1; // 仅允许单选
    
    PHPickerViewController *picker = [[PHPickerViewController alloc] initWithConfiguration:config];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark PHPickerViewControllerDelegate
// 处理选择结果
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14)) {
    [picker dismissViewControllerAnimated:YES completion:nil]; // 立即关闭相册

    if (results.count > 0) {
        PHPickerResult *result = results.firstObject;

        if ([result.itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeMovie]) {
            // loadItemForTypeIdentifier 会自动将文件拷贝到临时目录（通常在 file://private/var/.../），而 loadFileRepresentationForTypeIdentifier 可能只是一个沙盒路径，不一定可访问。
            /* 此方法无法拷贝
            [result.itemProvider loadFileRepresentationForTypeIdentifier:(NSString *)kUTTypeMovie completionHandler:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                if (URL) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self playVideoURL:URL];
                    });
                }
            }];
            */
            
            [result.itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeMovie options:nil completionHandler:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                if (URL) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //iOS 14+ 使用 PHPickerViewController 选择视频时，获取的 NSURL 是沙盒临时路径，但默认没有拷贝到可访问的目录，导致 AVPlayer 无法正常播放。而 UIImagePickerController 直接提供的是一个可访问的本地文件路径，所以在 iOS 14 以下可以正常播放。
                        NSURL *playableURL = [self copyVideoToTemporaryDirectory:URL];
                        [self playVideoURL:playableURL];
                    });
                }
            }];
        }
        
        if ([result.itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeMovie]) {
//            [result.itemProvider loadFileRepresentationForTypeIdentifier:(NSString *)kUTTypeMovie completionHandler:^(NSURL * _Nullable URL, NSError * _Nullable error) {
            [result.itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeMovie options:nil completionHandler:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                if (URL) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //iOS 14+ 使用 PHPickerViewController 选择视频时，获取的 NSURL 是沙盒临时路径，但默认没有拷贝到可访问的目录，导致 AVPlayer 无法正常播放。而 UIImagePickerController 直接提供的是一个可访问的本地文件路径，所以在 iOS 14 以下可以正常播放。
                        NSURL *playableURL = [self copyVideoToTemporaryDirectory:URL];
                        [self playVideoURL:playableURL];
                    });
                }
            }];
        }
    }
}

// 复制视频到 NSTemporaryDirectory，确保 AVPlayer 可访问
- (NSURL *)copyVideoToTemporaryDirectory:(NSURL *)originalURL {
    NSString *tempDirectory = NSTemporaryDirectory();
    NSString *videoName = [NSString stringWithFormat:@"picked_video_%@.mov", [[NSUUID UUID] UUIDString]];
    NSString *tempPath = [tempDirectory stringByAppendingPathComponent:videoName];
    
    NSURL *tempURL = [NSURL fileURLWithPath:tempPath];

    // 使用 NSFileManager 复制文件
    NSError *error;
    [[NSFileManager defaultManager] copyItemAtURL:originalURL toURL:tempURL error:&error];
    
    if (error) {
        NSLog(@"视频拷贝失败: %@", error.localizedDescription);
        return nil;
    }
    
    return tempURL;
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    NSLog(@"Picker returned successfully.");
    
    NSLog(@"%@", info);
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // 判断获取类型：图片
    NSURL *videoURL;
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){
        
    } else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (videoURL != nil) {
            [self playVideoURL:videoURL];
        }
    }];
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

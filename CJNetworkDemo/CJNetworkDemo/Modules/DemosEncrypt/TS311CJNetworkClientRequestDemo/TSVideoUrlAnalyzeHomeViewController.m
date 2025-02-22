//
//  TSVideoUrlAnalyzeHomeViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//
//  快捷指令：抖音解析 无水印;

#import "TSVideoUrlAnalyzeHomeViewController.h"
#import <CJMonitor/CJLogSuspendWindow.h>
//#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CQVideoUrlAnalyze_Swift/CQVideoUrlAnalyze_Swift-Swift.h>

#import <CJNetwork/AFHTTPSessionManager+CJSerializerEncrypt.h>
#import <CJNetwork/CQDemoHTTPSessionManager.h>

#import "TestNetworkClient.h"

@interface TSVideoUrlAnalyzeHomeViewController ()

@property (nonatomic, strong) dispatch_queue_t commonConcurrentQueue; //创建并发队列
@property (nonatomic, copy) NSString *api;
@property (nonatomic, copy) NSString *videoResultUrl;

@end

@implementation TSVideoUrlAnalyzeHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"抖音解析 无水印", nil);
    __weak typeof(self)weakSelf = self;
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    // Douyin
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"Douyin 视频地址解析";
        
        {
            CQDMModuleModel *loginModule = [[CQDMModuleModel alloc] init];
            loginModule.title = @"抖音解析 无水印";
            loginModule.content = @"获取抖音解析的api，并利用api解析出视频地址";
            loginModule.contentLines = 2;
            loginModule.actionBlock = ^{
                [CQVideoUrlAnalyze_Douyin analyzeUrl:@"https://v.douyin.com/iPY4TLua/" success:^(NSArray<NSString *> * _Nonnull videoResultUrls) {
                    if (videoResultUrls.count > 0) {
                        weakSelf.videoResultUrl = videoResultUrls[0];
                        [weakSelf __showResponseLogMessage:weakSelf.videoResultUrl];
                    }
                    
                } failure:^(NSString * _Nonnull errorMessage) {
                    [weakSelf __showResponseLogMessage:errorMessage];
                }];
            };
            [sectionDataModel.values addObject:loginModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    // Tiktok
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"Tiktok 视频地址解析";
        {
            CQDMModuleModel *loginModule = [[CQDMModuleModel alloc] init];
            loginModule.title = @"解析tiktok视频地址";
            loginModule.content = @"无水印";
            loginModule.actionBlock = ^{
                NSString *shortenedUrl = @"https://www.tiktok.com/t/ZT2fyo8FN/";
                [CQVideoUrlAnalyze_Tiktok requestUrlFromShortenedUrl:shortenedUrl type:CQAnalyzeVideoUrlTypeVideoWithoutWatermarkHD success:^(NSString * _Nonnull expandedUrl, NSString * _Nonnull videoId, NSString * _Nonnull videoUrl) {
                    NSString *message = [NSString stringWithFormat:@"expandedUrl=%@\nvideoId=%@\nvideoUrl=%@", expandedUrl, videoId, videoUrl];
                    [self __showResponseLogMessage:message];
                } failure:^(NSString * _Nonnull errorMessage) {
                    [self __showResponseLogMessage:errorMessage];
                }];
            };
            [sectionDataModel.values addObject:loginModule];
        }
        [sectionDataModels addObject:sectionDataModel];
    }

    self.sectionDataModels = sectionDataModels;
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
    [CJLogViewWindow appendObject:message];
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

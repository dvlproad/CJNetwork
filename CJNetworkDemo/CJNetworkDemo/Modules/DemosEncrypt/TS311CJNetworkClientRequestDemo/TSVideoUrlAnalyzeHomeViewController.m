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

#import <CJNetwork/AFHTTPSessionManager+CJSerializerEncrypt.h>
#import "TSCleanHTTPSessionManager.h"

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
    
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    // 单个请求
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"抖音解析 无水印";
        
        {
            CQDMModuleModel *loginModule = [[CQDMModuleModel alloc] init];
            loginModule.title = @"获取抖音解析的api";
            loginModule.actionBlock = ^{
                [self __testGetRequest];
            };
            [sectionDataModel.values addObject:loginModule];
        }
        {
            CQDMModuleModel *loginModule = [[CQDMModuleModel alloc] init];
            loginModule.title = @"利用api解析出视频地址";
            loginModule.actionBlock = ^{
                [self __testPostRequest];
            };
            [sectionDataModel.values addObject:loginModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }

    self.sectionDataModels = sectionDataModels;
}



#pragma mark - Private Method
// 测试GET网络请求
- (void)__testGetRequest {
    AFHTTPSessionManager *manager = [TSCleanHTTPSessionManager sharedInstance];
    NSString *Url = @"http://i.rcuts.com/update/247";   // 快捷指令：抖音解析 无水印
    NSDictionary *allParams = @{
//        @"code": @"utf-8",
//        @"q": @"玩具车"
    };
    NSDictionary<NSString *, NSString *> *headers = @{};
    
    __weak typeof(self)weakSelf = self;
    [manager cj_requestUrl:Url params:allParams headers:headers method:CJRequestMethodGET cacheSettingModel:nil logType:CJRequestLogTypeSuppendWindow progress:nil success:^(CJSuccessRequestInfo * _Nullable successRequestInfo) {
        //NSString *message = [NSString stringWithFormat:@"GET请求测试成功。。。\n%@", successRequestInfo.networkLogString];
        //[self __showResponseLogMessage:message];
        
        NSDictionary *responseDictionary = successRequestInfo.responseObject;
        weakSelf.api = [responseDictionary objectForKey:@"api"];
        
    } failure:^(CJFailureRequestInfo * _Nullable failureRequestInfo) {
        NSString *message = [NSString stringWithFormat:@"GET请求测试失败。。。\n%@", failureRequestInfo.errorMessage];
        [self __showResponseLogMessage:message];
    }];
}

// 测试POST网络请求
- (void)__testPostRequest {
    __weak typeof(self)weakSelf = self;
    
    /*
    AFHTTPSessionManager *manager = [TSCleanHTTPSessionManager sharedInstance];
//    NSString *Url = @"http://api.rcuts.com/Video/DouYin.php";
    NSString *Url = self.api;
    NSDictionary *allParams = @{
        @"url": @"https://v.douyin.com/iPY4TLua/",
        @"token": @"rcuts"
    };
    NSDictionary<NSString *, NSString *> *headers = @{};
    
    
    [manager cj_requestUrl:Url params:allParams headers:headers method:CJRequestMethodPOST cacheSettingModel:nil logType:CJRequestLogTypeSuppendWindow progress:nil success:^(CJSuccessRequestInfo * _Nullable successRequestInfo) {
        //NSString *message = [NSString stringWithFormat:@"POST请求测试成功。。。\n%@", successRequestInfo.networkLogString];
        //[self __showResponseLogMessage:message];
        
        NSDictionary *responseDictionary = successRequestInfo.responseObject;
        NSArray *videoResultUrls = [responseDictionary objectForKey:@"video_url"];
        if (videoResultUrls.count > 0) {
            weakSelf.videoResultUrl = videoResultUrls[0];
        }
        [self __showResponseLogMessage:weakSelf.videoResultUrl];
        
        
    } failure:^(CJFailureRequestInfo * _Nullable failureRequestInfo) {
        NSString *message = [NSString stringWithFormat:@"POST请求测试失败。。。\n%@", failureRequestInfo.errorMessage];
        [self __showResponseLogMessage:message];
    }];
    */

    CJRequestBaseModel *requestModel = [[CJRequestBaseModel alloc] init];
    requestModel.ownBaseUrl = @"http://api.rcuts.com";
    requestModel.apiSuffix = @"Video/DouYin.php";
    requestModel.customParams = @{
        @"url": @"https://v.douyin.com/iPY4TLua/",
        @"token": @"rcuts"
    };
    requestModel.requestMethod = CJRequestMethodPOST;
    
    CJRequestSettingModel *settingModel = [[CJRequestSettingModel alloc] init];
//    CJRequestCacheSettingModel *requestCacheModel = [[CJRequestCacheSettingModel alloc] init];
//    requestCacheModel.cacheStrategy = CJRequestCacheStrategyEndWithCacheIfExist;
//    requestCacheModel.cacheTimeInterval = 10;
//    settingModel.requestCacheModel = requestCacheModel;
    settingModel.logType = CJRequestLogTypeConsoleLog;
    requestModel.settingModel = settingModel;
    
    
    [[TestNetworkClient sharedInstance] requestModel:requestModel success:^(CJResponseModel *responseModel) {
        //NSString *message = [NSString stringWithFormat:@"POST请求测试成功。。。\n%@", successRequestInfo.networkLogString];
        //[self __showResponseLogMessage:message];
        
        NSDictionary *responseDictionary = responseModel.result;
        NSArray *videoResultUrls = [responseDictionary objectForKey:@"video_url"];
        if (videoResultUrls.count > 0) {
            weakSelf.videoResultUrl = videoResultUrls[0];
        }
        [self __showResponseLogMessage:weakSelf.videoResultUrl];
        
    } failure:^(BOOL isRequestFailure, NSString *errorMessage) {
        //
    }];
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

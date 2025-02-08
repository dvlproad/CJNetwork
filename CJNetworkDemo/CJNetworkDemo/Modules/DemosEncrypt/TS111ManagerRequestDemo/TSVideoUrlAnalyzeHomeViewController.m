//
//  TSVideoUrlAnalyzeHomeViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TSVideoUrlAnalyzeHomeViewController.h"
#import <CJMonitor/CJLogSuspendWindow.h>
//#import <CQDemoKit/CJUIKitToastUtil.h>

#import <CJNetwork/AFHTTPSessionManager+CJSerializerEncrypt.h>
#import "TSCleanHTTPSessionManager.h"

@interface TSVideoUrlAnalyzeHomeViewController ()

@property (nonatomic, strong) dispatch_queue_t commonConcurrentQueue; //创建并发队列

@end

@implementation TSVideoUrlAnalyzeHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"Request首页", nil);
    
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    // 单个请求
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"测试请求(单次)";
        
        {
            CQDMModuleModel *loginModule = [[CQDMModuleModel alloc] init];
            loginModule.title = @"测试网络请求GET(单次)";
            loginModule.actionBlock = ^{
                [self __testGetRequest];
            };
            [sectionDataModel.values addObject:loginModule];
        }
        {
            CQDMModuleModel *loginModule = [[CQDMModuleModel alloc] init];
            loginModule.title = @"测试网络请求POST(单次)";
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
    
    [manager cj_requestUrl:Url params:allParams headers:headers method:CJRequestMethodGET cacheSettingModel:nil logType:CJRequestLogTypeSuppendWindow progress:nil success:^(CJSuccessRequestInfo * _Nullable successRequestInfo) {
        NSString *message = [NSString stringWithFormat:@"GET请求测试成功。。。\n%@", successRequestInfo.networkLogString];
        [self __showResponseLogMessage:message];
    } failure:^(CJFailureRequestInfo * _Nullable failureRequestInfo) {
        NSString *message = [NSString stringWithFormat:@"GET请求测试失败。。。\n%@", failureRequestInfo.errorMessage];
        [self __showResponseLogMessage:message];
    }];
}

// 测试POST网络请求
- (void)__testPostRequest {
    AFHTTPSessionManager *manager = [TSCleanHTTPSessionManager sharedInstance];
//    NSString *Url = @"https://api.apiopen.top/getWangYiNews";
    NSString *Url = @"http://api.rcuts.com/Video/DouYin.php";
    NSDictionary *allParams = @{
        @"url": @"https://v.douyin.com/iPY4TLua/",
        @"token": @"rcuts"
    };
//    NSDictionary *allParams = @{
//        @"page": @(1),
//        @"count": @(5)
//    };
    NSDictionary<NSString *, NSString *> *headers = @{};
    
    [manager cj_requestUrl:Url params:allParams headers:headers method:CJRequestMethodPOST cacheSettingModel:nil logType:CJRequestLogTypeSuppendWindow progress:nil success:^(CJSuccessRequestInfo * _Nullable successRequestInfo) {
        NSString *message = [NSString stringWithFormat:@"POST请求测试成功。。。\n%@", successRequestInfo.networkLogString];
        [self __showResponseLogMessage:message];
    } failure:^(CJFailureRequestInfo * _Nullable failureRequestInfo) {
        NSString *message = [NSString stringWithFormat:@"POST请求测试失败。。。\n%@", failureRequestInfo.errorMessage];
        [self __showResponseLogMessage:message];
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

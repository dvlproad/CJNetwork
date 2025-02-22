//
//  TS11CleanRequestRepeatHomeViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TS11CleanRequestRepeatHomeViewController.h"
#import <CJMonitor/CJLogSuspendWindow.h>
//#import <CQDemoKit/CJUIKitToastUtil.h>

#import <CJNetwork/AFHTTPSessionManager+CJSerializerEncrypt.h>
#import <CJNetwork/CQDemoHTTPSessionManager.h>

@interface TS11CleanRequestRepeatHomeViewController ()

@property (nonatomic, strong) dispatch_queue_t commonConcurrentQueue; //创建并发队列

@end

@implementation TS11CleanRequestRepeatHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"请求重复发送测试", nil);
    
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    // 发起多个相同的请求
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"测试发起多个相同的请求，得到的结果次数";
        
        {
            CQDMModuleModel *loginModule = [[CQDMModuleModel alloc] init];
            loginModule.title = @"测试多个相同的GET请求(多次)";
            loginModule.actionBlock = ^{
                [self __testManySameRequest];
            };
            [sectionDataModel.values addObject:loginModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }

    self.sectionDataModels = sectionDataModels;
}



#pragma mark - Private Method
// 测试发起多个相同的请求，得到的结果次数
- (void)__testManySameRequest {
    for (int i = 0; i < 4; i++) {
        //[NSThread detachNewThreadSelector:@selector(__testGetRequest) toTarget:self withObject:@(i)];
        [self __testGetRequestWithIndex:i];
    }
}


// 测试GET网络请求
- (void)__testGetRequestWithIndex:(NSInteger)requestIndex {
    // [淘宝宝贝名称查询GET](https://api.you-fire.com/youapi/api/detail/b5d2217f923e11e986e700163e0e0ef0)
    AFHTTPSessionManager *manager = [CQDemoHTTPSessionManager sharedInstance];
    NSString *Url = @"https://suggest.taobao.com/sug";
    NSDictionary *allParams = @{
        @"code": @"utf-8",
        @"q": @"玩具车",
        @"m_requestIndex": @(requestIndex),
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

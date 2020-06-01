//
//  TS12MyNetworkClientHomeViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TS12MyNetworkClientHomeViewController.h"
#import <CJMonitor/CJLogSuspendWindow.h>
//#import <CQDemoKit/CJUIKitToastUtil.h>

#import "HealthyNetworkClient.h"


@interface TS12MyNetworkClientHomeViewController ()

@property (nonatomic, strong) dispatch_queue_t commonConcurrentQueue; //创建并发队列

@end

@implementation TS12MyNetworkClientHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"MyNetworkClient首页", nil);
    
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    // 单个请求
    {
        CJSectionDataModel *sectionDataModel = [[CJSectionDataModel alloc] init];
        sectionDataModel.theme = @"测试请求(单次)";
        
        {
            CJModuleModel *loginModule = [[CJModuleModel alloc] init];
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
// 测试POST网络请求
- (void)__testPostRequest {
    NSString *apiName = @"/getWangYiNews";
    NSDictionary *params = @{
        @"page": @(1),
        @"count": @(2)
    };
    
    [[HealthyNetworkClient sharedInstance] health_postApi:apiName params:params encrypt:YES success:^(HealthResponseModel *responseModel) {
        NSString *message = [NSString stringWithFormat:@"GET请求测试成功。。。%@", responseModel.cjNetworkLog];
        [self __showResponseLogMessage:message];
        
    } failure:^(NSString *errorMessage) {
        NSString *message = [NSString stringWithFormat:@"GET请求测试成功。。。%@", errorMessage];
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

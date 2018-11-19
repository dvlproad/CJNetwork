//
//  EncryptHomeViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "EncryptHomeViewController.h"

#import "HealthyNetworkClient.h"
#import "HealthyHTTPSessionManager.h"

@interface EncryptHomeViewController ()

@end

@implementation EncryptHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"Encrypt首页", nil);
    
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    //弹窗
    {
        CJSectionDataModel *sectionDataModel = [[CJSectionDataModel alloc] init];
        sectionDataModel.theme = @"Encrypt相关";
        {
            CJModuleModel *loginModule = [[CJModuleModel alloc] init];
            loginModule.title = @"登录(健康)";
            loginModule.selector = @selector(testLoginHealth);
            [sectionDataModel.values addObject:loginModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    
    self.sectionDataModels = sectionDataModels;
}

- (void)testLoginHealth {
    [self loginHealthWithCompleteBlock:^(CJResponseModel *responseModel) {
        if (responseModel.status == 0) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"登录成功", nil)];
            if (responseModel.cjNetworkLog) {
                [CJAlert showDebugViewWithTitle:@"登录提醒" message:responseModel.cjNetworkLog];
                [CJLogViewWindow appendObject:responseModel.cjNetworkLog];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"登录失败", nil)];
            
            [CJLogViewWindow appendObject:@"加密页面的健康登录失败"];
            if (responseModel.cjNetworkLog) {
                [CJAlert showDebugViewWithTitle:@"登录提醒" message:responseModel.cjNetworkLog];
                [CJLogViewWindow appendObject:responseModel.cjNetworkLog];
            }
        }
    }];
}

- (void)loginHealthWithCompleteBlock:(void (^)(CJResponseModel *responseModel))completeBlock {
    NSString *apiName = @"http://121.40.82.169/drupal/api/login";
    NSDictionary *params = @{@"username" : @"test",
                             @"password" : @"test",
                             };
    /*
    AFHTTPSessionManager *manager = [HealthyHTTPSessionManager sharedInstance];
    [manager cj_postUrl:UITrackingRunLoopMode params:params settingModel:nil success:^(CJSuccessNetworkInfo * _Nullable successNetworkInfo) {
        <#code#>
    } failure:^(CJFailureNetworkInfo * _Nullable failureNetworkInfo) {
        <#code#>
    }];
    */
    [[HealthyNetworkClient sharedInstance] health_postApi:apiName params:params encrypt:YES success:^(HealthResponseModel *responseModel) {
        if (completeBlock) {
            completeBlock(responseModel);
        }
        
    } failure:^(NSError * _Nullable error) {
        CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        responseModel.status = -1;
        responseModel.message = NSLocalizedString(@"网络请求失败", nil);
        responseModel.result = nil;
        responseModel.cjNetworkLog = error.userInfo[@"cjNetworkLog"];
        if (completeBlock) {
            completeBlock(responseModel);
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

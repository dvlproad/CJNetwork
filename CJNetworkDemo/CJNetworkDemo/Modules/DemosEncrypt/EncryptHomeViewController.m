//
//  EncryptHomeViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "EncryptHomeViewController.h"
#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CQDemoKit/CJUIKitAlertUtil.h>

#import "SimulationHomeViewController.h"

#import "TSCleanRequestHomeViewController.h"
#import "TS11CleanRequestRepeatHomeViewController.h"
#import "RequestCacheHomeViewController.h"

#import "TS12MyNetworkClientHomeViewController.h"

@interface EncryptHomeViewController ()

@property (nonatomic, strong) dispatch_queue_t commonConcurrentQueue; //创建并发队列

@end

@implementation EncryptHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"Encrypt首页", nil);
    
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    
    // 本地模拟网络请求
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"本地模拟网络请求";
        
        {
            CQDMModuleModel *requestModule = [[CQDMModuleModel alloc] init];
            requestModule.title = @"本地模拟网络请求";
            requestModule.classEntry = [SimulationHomeViewController class];
            [sectionDataModel.values addObject:requestModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    // 网络请求(未封装时候)
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"未封装时候";
        
        {
            CQDMModuleModel *requestModule = [[CQDMModuleModel alloc] init];
            requestModule.title = @"测试网络请求(Manager)";
            requestModule.classEntry = [TSCleanRequestHomeViewController class];
            [sectionDataModel.values addObject:requestModule];
        }
        {
            CQDMModuleModel *requestModule = [[CQDMModuleModel alloc] init];
            requestModule.title = @"测试网络请求进阶之重复Repeat发送问题(Manager)";
            requestModule.classEntry = [TS11CleanRequestRepeatHomeViewController class];
            [sectionDataModel.values addObject:requestModule];
        }
        {
            CQDMModuleModel *requestModule = [[CQDMModuleModel alloc] init];
            requestModule.title = @"测试网络请求进阶之缓存Cache处理问题(Manager)";
            requestModule.content = @"(请一定要执行验证)";
            requestModule.classEntry = [RequestCacheHomeViewController class];
            [sectionDataModel.values addObject:requestModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    
    // 网络请求(未封装时候)
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"自己一层封装";
        
        {
            CQDMModuleModel *requestModule = [[CQDMModuleModel alloc] init];
            requestModule.title = @"测试网络请求(MyNetworkClient)";
            requestModule.classEntry = [TS12MyNetworkClientHomeViewController class];
            [sectionDataModel.values addObject:requestModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    // 网络请求(未封装时候)
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"两层封装";
        
        {
            CQDMModuleModel *requestModule = [[CQDMModuleModel alloc] init];
            requestModule.title = @"测试网络请求(CJNetworkClient)--待添加";
//            requestModule.classEntry = [TSCleanRequestHomeViewController class];
            [sectionDataModel.values addObject:requestModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }

    self.sectionDataModels = sectionDataModels;
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

//
//  SimulationHomeViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "SimulationHomeViewController.h"
#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CQDemoKit/CJUIKitAlertUtil.h>

#import <CJNetwork/CJRequestSimulateUtil.h>

@interface SimulationHomeViewController ()

@end

@implementation SimulationHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self similuteApi];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"Simulation首页", nil);
    
    __weak typeof(self)weakSelf = self;
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    // 本地模拟网络请求
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"本地模拟网络请求";
        
        {
            CQDMModuleModel *requestModule = [[CQDMModuleModel alloc] init];
            requestModule.title = @"本地模拟网络请求";
            requestModule.actionBlock = ^{
                [weakSelf similuteApi];
            };
            [sectionDataModel.values addObject:requestModule];
        }
        
        {
            CQDMModuleModel *requestModule = [[CQDMModuleModel alloc] init];
            requestModule.title = @"进入下一页回来执行viewWillAppear中的请求";
            requestModule.classEntry = [UIViewController class];
            [sectionDataModel.values addObject:requestModule];
        }
       
        [sectionDataModels addObject:sectionDataModel];
    }
    
    self.sectionDataModels = sectionDataModels;
}

- (void)similuteApi {
    [CJRequestSimulateUtil localSimulateApi:@"api/card/cardlist" completeBlock:^(NSDictionary * _Nonnull responseDictionary) {
        NSArray *dictionarys = responseDictionary[@"result"];
        NSLog(@"dictionarys = %@", dictionarys);
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

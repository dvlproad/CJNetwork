//
//  DownloadHomeViewController.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "DownloadHomeViewController.h"
#import <CQDemoKit/CJUIKitAlertUtil.h>
#import <CQDemoKit/CQTSSandboxFileUtil.h>

//断点续传
#import "AFDownloadViewController.h"
#import "SessionDownloadTaskDownloadViewController.h"
#import "SessionDataTaskDownloadViewController.h"

//downloadList
#import "DownloadListViewController.h"

#import "AFNDemoViewController.h"

@interface DownloadHomeViewController () {
    
}
@property (nonatomic, copy, nullable) NSString *realDownloadZipRelativePath;

@end

@implementation DownloadHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"Download首页", nil);
    
    __weak typeof(self)weakSelf = self;
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    // 单个文件下载
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"单个文件下载断点续传相关(包含进度显示)";
        
        {
            CQDMModuleModel *toastUtilModule = [[CQDMModuleModel alloc] init];
            toastUtilModule.title = @"单个文件：使用系统进行下载";
            toastUtilModule.content = self.realDownloadZipRelativePath;
            toastUtilModule.actionBlock = ^{
                NSString *Url = @"https://github.com/dvlproad/001-UIKit-CQDemo-iOS/blob/1de60c07fba6fa5d29a49e982a4fc02f22e21d9d/CQDemoKit/Demo_Resource/LocDataModel/Resources/mp4/vap.mp4";
                [CQTSSandboxFileUtil downloadFileWithUrl:Url toSandboxType:CQTSSandboxTypeDocuments
                                                subDirectory:@"downloadMp4" fileName:nil success:^(NSDictionary *dict) {
                    NSString *absoluteFilePath = dict[@"absoluteFilePath"];
                    NSString *relativeFilePath = dict[@"relativeFilePath"];
                    weakSelf.realDownloadZipRelativePath = relativeFilePath;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView reloadData];
                    });
                    
                } failure:^(NSString *errorMessage){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [CJUIKitAlertUtil showIKnowAlertInViewController:weakSelf withTitle:errorMessage iKnowBlock:nil];
                    });
                }];
            };
            [sectionDataModel.values addObject:toastUtilModule];
        }
        {
            CQDMModuleModel *toastUtilModule = [[CQDMModuleModel alloc] init];
            toastUtilModule.title = @"单个文件：使用AFN进行下载";
            toastUtilModule.actionBlock = ^{
                UIViewController *viewController = [[AFDownloadViewController alloc] initWithNibName];
                viewController.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:viewController animated:YES];
            };
            [sectionDataModel.values addObject:toastUtilModule];
        }
        {
            CQDMModuleModel *alertUtilModule = [[CQDMModuleModel alloc] init];
            alertUtilModule.title = @"单个文件：使用MQLResumeManager下载(断点续传)";
            alertUtilModule.actionBlock = ^{
                UIViewController *viewController = [[SessionDataTaskDownloadViewController alloc] initWithNibName];
                viewController.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:viewController animated:YES];
            };
            [sectionDataModel.values addObject:alertUtilModule];
        }
        
        {
            CQDMModuleModel *alertUtilModule = [[CQDMModuleModel alloc] init];
            alertUtilModule.title = @"单个文件：AFN";
            alertUtilModule.classEntry = [SessionDownloadTaskDownloadViewController class];
            alertUtilModule.isCreateByXib = YES;
            [sectionDataModel.values addObject:alertUtilModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    // 文件列表下载
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"文件列表下载";
        {
            CQDMModuleModel *alertUtilModule = [[CQDMModuleModel alloc] init];
            alertUtilModule.title = @"断点续传(HSDownloadManager)";
            alertUtilModule.classEntry = [DownloadListViewController class];
            alertUtilModule.isCreateByXib = YES;
            [sectionDataModel.values addObject:alertUtilModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"其他相关";
        {
            CQDMModuleModel *toastUtilModule = [[CQDMModuleModel alloc] init];
            toastUtilModule.title = @"AFNDemoViewController";
            toastUtilModule.classEntry = [AFNDemoViewController class];
            toastUtilModule.isCreateByXib = YES;
            [sectionDataModel.values addObject:toastUtilModule];
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

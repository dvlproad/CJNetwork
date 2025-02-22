//
//  DownloadHomeViewController.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "DownloadHomeViewController.h"
#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CQDemoKit/CJUIKitAlertUtil.h>
#import <CQDemoKit/CQTSSandboxFileUtil.h>
#import <CQDemoKit/CQTSSandboxPathUtil.h>
#import <CJNetwork_Swift/CJNetwork_Swift-Swift.h>

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
                NSURL *sandboxURL = [CQTSSandboxPathUtil sandboxURL:CQTSSandboxTypeDocuments];
                [CQTSSandboxFileUtil downloadFileWithUrl:Url toSandboxURL:sandboxURL
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
    
    // 使用 zip
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"普通文件、json、zip等文件的下载和解析";
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"下载普通文件";
            module.actionBlock = ^{
                NSString *mp4Url = @"https://github.com/dvlproad/001-UIKit-CQDemo-iOS/blob/1de60c07fba6fa5d29a49e982a4fc02f22e21d9d/CQDemoKit/Demo_Resource/LocDataModel/Resources/mp4/vap.mp4";
                NSString *directoryUrl = [CQTSSandboxPathUtil sandboxPath:CQTSSandboxTypeDocuments];
                NSURL *directoryURL = [NSURL fileURLWithPath:directoryUrl];
                [CJDownloadUtil downloadFileUrl:mp4Url fileDataDecryptHandle:^NSData * _Nullable(NSData * _Nonnull serviceData) {
                    return serviceData;
                } saveToDirectoryURL:directoryURL saveWithFileName:@"vap.mp4"  success:^(NSURL * _Nonnull unzipLocalURL) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *message = [NSString stringWithFormat:@"file解压后的地址: %@", unzipLocalURL.path];
                        [CJUIKitToastUtil showMessage:message];
                    });
                } failure:^(NSString * _Nonnull errorMessage) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [CJUIKitToastUtil showMessage:errorMessage];
                    });
                }];
            };
            [sectionDataModel.values addObject:module];
        }
        {
            CQDMModuleModel *module = [[CQDMModuleModel alloc] init];
            module.title = @"下载zip文件";
            module.actionBlock = ^{
                NSString *zipUrl = @"http://shs4ggs0e.hd-bkt.clouddn.com/symbol/TestDownloadBundle.bundle.zip";
                NSString *directoryUrl = [CQTSSandboxPathUtil sandboxPath:CQTSSandboxTypeDocuments];
                NSURL *directoryURL = [NSURL fileURLWithPath:directoryUrl];
                
                [CJDownloadUtil downloadZipUrl:zipUrl zipDataDecryptHandle:nil saveToDirectoryURL:directoryURL saveWithZipName:nil upzipFileName:@"TestDownloadBundle.bundle" zipProgressHandler:nil success:^(NSURL * _Nonnull unzipLocalURL) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *message = [NSString stringWithFormat:@"zip解压后的地址: %@", unzipLocalURL.path];
                        [CJUIKitToastUtil showMessage:message];
                    });
                } failure:^(NSString * _Nonnull errorMessage) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [CJUIKitToastUtil showMessage:errorMessage];
                    });
                }];
            };
            [sectionDataModel.values addObject:module];
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

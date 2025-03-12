//
//  CQDownloadSettingViewController.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CQDownloadSettingViewController.h"
#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CQDemoKit/CJUIKitAlertUtil.h>
#import <CQDemoKit/CQTSSandboxFileUtil.h>
#import <CQDemoKit/CQTSSandboxPathUtil.h>
#import <CJNetwork_Swift/CJNetwork_Swift-Swift.h>

#import "TSDownloadVideoIdManager.h"
#import "HSDownloadManager.h"

@interface CQDownloadSettingViewController () {
    
}
@property (nonatomic, copy, nullable) NSString *realDownloadZipRelativePath;

@end

@implementation CQDownloadSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedStringFromTable(@"更多", @"LocalizableDownloader", nil);
    
    __weak typeof(self)weakSelf = self;
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    // 单个文件下载
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = NSLocalizedStringFromTable(@"设置", @"LocalizableDownloader", nil);
        /*
        {
            CQDMModuleModel *toastUtilModule = [[CQDMModuleModel alloc] init];
            toastUtilModule.title = NSLocalizedStringFromTable(@"关于我们", @"LocalizableDownloader", nil);
            toastUtilModule.actionBlock = ^{
                
            };
            [sectionDataModel.values addObject:toastUtilModule];
        }
        */
        {
            CQDMModuleModel *toastUtilModule = [[CQDMModuleModel alloc] init];
            toastUtilModule.title = NSLocalizedStringFromTable(@"打开设置", @"LocalizableDownloader", nil);
            toastUtilModule.actionBlock = ^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            };
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

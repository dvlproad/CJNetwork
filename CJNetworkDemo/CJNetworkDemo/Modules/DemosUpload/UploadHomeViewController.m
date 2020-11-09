//
//  UploadHomeViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/4/5.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "UploadHomeViewController.h"

@interface UploadHomeViewController ()

@end

@implementation UploadHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"Upload首页", nil);
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    //弹窗
    {
//        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
//        sectionDataModel.theme = @"Upload相关";
//        {
//            CQDMModuleModel *toastUtilModule = [[CQDMModuleModel alloc] init];
//            toastUtilModule.title = @"UploadViewController";
//            toastUtilModule.classEntry = [UploadViewController class];
//            [sectionDataModel.values addObject:toastUtilModule];
//        }
//        
//        [sectionDataModels addObject:sectionDataModel];
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

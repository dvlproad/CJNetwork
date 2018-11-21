//
//  CacheHomeViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CacheHomeViewController.h"

#import "LoginViewController.h"


@interface CacheHomeViewController () 

@end

@implementation CacheHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"Cache首页", nil);
    
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    //弹窗
    {
        CJSectionDataModel *sectionDataModel = [[CJSectionDataModel alloc] init];
        sectionDataModel.theme = @"缓存相关";
        {
            CJModuleModel *toastUtilModule = [[CJModuleModel alloc] init];
            toastUtilModule.title = @"LoginViewController";
            toastUtilModule.classEntry = [LoginViewController class];
            [sectionDataModel.values addObject:toastUtilModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
   
    self.sectionDataModels = sectionDataModels;
}

- (void)goLogin {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:vc animated:YES];
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

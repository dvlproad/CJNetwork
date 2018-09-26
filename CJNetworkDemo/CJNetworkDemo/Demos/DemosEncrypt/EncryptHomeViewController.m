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

@interface EncryptHomeViewController () <UITableViewDataSource, UITableViewDelegate> {
    
}

@end

@implementation EncryptHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"Encrypt首页", nil); //知识点:使得tabBar中的title可以和显示在顶部的title保持各自
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView = tableView;
    
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    //弹窗
    {
        CJSectionDataModel *sectionDataModel = [[CJSectionDataModel alloc] init];
        sectionDataModel.theme = @"Encrypt相关";
        {
            CJModuleModel *toastUtilModule = [[CJModuleModel alloc] init];
            toastUtilModule.title = @"登录(健康)";
            //toastUtilModule.classEntry = [UIViewController class];
            [sectionDataModel.values addObject:toastUtilModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    
    self.sectionDataModels = sectionDataModels;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionDataModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CJSectionDataModel *sectionDataModel = [self.sectionDataModels objectAtIndex:section];
    NSArray *dataModels = sectionDataModel.values;
    
    return dataModels.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    CJSectionDataModel *sectionDataModel = [self.sectionDataModels objectAtIndex:section];
    
    NSString *indexTitle = sectionDataModel.theme;
    return indexTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CJSectionDataModel *sectionDataModel = [self.sectionDataModels objectAtIndex:indexPath.section];
    NSArray *dataModels = sectionDataModel.values;
    CJModuleModel *moduleModel = [dataModels objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = moduleModel.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"didSelectRowAtIndexPath = %ld %ld", indexPath.section, indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
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
    }
}

- (void)loginHealthWithCompleteBlock:(void (^)(CJResponseModel *responseModel))completeBlock {
    NSString *apiName = @"http://121.40.82.169/drupal/api/login";
    NSDictionary *params = @{@"username" : @"test",
                             @"password" : @"test",
                             };
    
    AFHTTPSessionManager *manager = [HealthyHTTPSessionManager sharedInstance];
    
    [[HealthyNetworkClient sharedInstance] health_postApi:apiName params:params encrypt:YES success:^(HealthResponseModel *responseModel) {
    //    [manager cj_postUrl:Url params:params shouldCache:NO progress:nil success:^(NSDictionary * _Nullable responseObject, BOOL isCacheData) {
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

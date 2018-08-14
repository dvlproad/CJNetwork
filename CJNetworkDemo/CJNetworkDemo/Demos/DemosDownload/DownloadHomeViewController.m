//
//  DownloadHomeViewController.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "DownloadHomeViewController.h"

//断点续传
#import "AFDownloadViewController.h"
#import "SessionDownloadTaskDownloadViewController.h"
#import "SessionDataTaskDownloadViewController.h"

//downloadList
#import "DownloadListViewController.h"

#import "AFNDemoViewController.h"
#import "RepeatRequestViewController.h"

@interface DownloadHomeViewController () <UITableViewDataSource, UITableViewDelegate> {
    
}

@end

@implementation DownloadHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"Download首页", nil); //知识点:使得tabBar中的title可以和显示在顶部的title保持各自
    
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
        sectionDataModel.theme = @"断点续传相关(包含进度显示)";
        {
            CJModuleModel *toastUtilModule = [[CJModuleModel alloc] init];
            toastUtilModule.title = @"使用AFN进行下载";
            toastUtilModule.classEntry = [AFDownloadViewController class];
            [sectionDataModel.values addObject:toastUtilModule];
        }
        {
            CJModuleModel *alertUtilModule = [[CJModuleModel alloc] init];
            alertUtilModule.title = @"断点续传(MQLResumeManager)";
            alertUtilModule.classEntry = [SessionDataTaskDownloadViewController class];
            [sectionDataModel.values addObject:alertUtilModule];
        }
        {
            CJModuleModel *alertUtilModule = [[CJModuleModel alloc] init];
            alertUtilModule.title = @"SessionDownloadTaskDownloadViewController";
            alertUtilModule.classEntry = [SessionDownloadTaskDownloadViewController class];
            [sectionDataModel.values addObject:alertUtilModule];
        }
        {
            CJModuleModel *alertUtilModule = [[CJModuleModel alloc] init];
            alertUtilModule.title = @"断点续传(HSDownloadManager)";
            alertUtilModule.classEntry = [DownloadListViewController class];
            [sectionDataModel.values addObject:alertUtilModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    {
        CJSectionDataModel *sectionDataModel = [[CJSectionDataModel alloc] init];
        sectionDataModel.theme = @"其他相关";
        {
            CJModuleModel *toastUtilModule = [[CJModuleModel alloc] init];
            toastUtilModule.title = @"AFNDemoViewController";
            toastUtilModule.classEntry = [AFNDemoViewController class];
            [sectionDataModel.values addObject:toastUtilModule];
        }
        {
            CJModuleModel *alertUtilModule = [[CJModuleModel alloc] init];
            alertUtilModule.title = @"请求的重复发送问题";
            alertUtilModule.classEntry = [RepeatRequestViewController class];
            [sectionDataModel.values addObject:alertUtilModule];
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
    NSLog(@"didSelectRowAtIndexPath = %ld %ld", indexPath.section, indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CJSectionDataModel *sectionDataModel = [self.sectionDataModels objectAtIndex:indexPath.section];
    NSArray *dataModels = sectionDataModel.values;
    CJModuleModel *moduleModel = [dataModels objectAtIndex:indexPath.row];
    
    
    Class classEntry = moduleModel.classEntry;
    NSString *nibName = NSStringFromClass(moduleModel.classEntry);
    
    
    UIViewController *viewController = nil;
    
    NSArray *noxibViewControllers = @[NSStringFromClass([UIViewController class]),
                                      NSStringFromClass([RepeatRequestViewController class])];
    
    NSString *clsString = NSStringFromClass(moduleModel.classEntry);
    if ([noxibViewControllers containsObject:clsString])
    {
        viewController = [[classEntry alloc] init];
        viewController.view.backgroundColor = [UIColor whiteColor];
    } else {
        if ([clsString isEqualToString:NSStringFromClass([AFDownloadViewController class])] ||
            [clsString isEqualToString:NSStringFromClass([SessionDataTaskDownloadViewController class])]) {
            nibName = @"BaseDownloadViewController";
        }
        viewController = [[classEntry alloc] initWithNibName:nibName bundle:nil];
    }
    viewController.title = NSLocalizedString(moduleModel.title, nil);
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
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

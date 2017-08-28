//
//  DownloadHomeViewController.m
//  CJNetworkDemo
//
//  Created by dvlproad on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "DownloadHomeViewController.h"

//断点续传
#import "AFDownloadViewController.h"
#import "SessionDownloadTaskDownloadViewController.h"
#import "SessionDataTaskDownloadViewController.h"

//downloadList
#import "DownloadListViewController.h"

@interface DownloadHomeViewController ()

@end

@implementation DownloadHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)goAFDownloadViewController:(id)sender {
    AFDownloadViewController *viewController = [[AFDownloadViewController alloc] initWithNibName:@"BaseDownloadViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)goSessionDataTaskDownloadViewController:(id)sender {
    SessionDataTaskDownloadViewController *viewController = [[SessionDataTaskDownloadViewController alloc] initWithNibName:@"BaseDownloadViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)goSessionDownloadTaskDownloadViewController:(id)sender {
    SessionDownloadTaskDownloadViewController *viewController = [[SessionDownloadTaskDownloadViewController alloc] initWithNibName:@"SessionDownloadTaskDownloadViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

//downloadList
- (IBAction)goDownloadListViewController:(id)sender {
    DownloadListViewController *viewController = [[DownloadListViewController alloc] initWithNibName:@"DownloadListViewController" bundle:nil];
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

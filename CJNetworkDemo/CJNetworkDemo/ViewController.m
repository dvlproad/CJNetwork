//
//  ViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "ViewController.h"
#import "Login.h"
#import "AFNDemoViewController.h"

#import "CheckVersionNetworkClient.h"
#import "TestNetworkClient.h"

#import "DownloadHomeViewController.h"

#import <AFNetworking/UIActivityIndicatorView+AFNetworking.h>

static int apiTestCount = 0;

@interface ViewController (){
    NSString *trackViewUrl;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"AFNetworking测试", nil);
}

- (IBAction)goLoginDemo:(id)sender{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    Login *vc = [sb instantiateViewControllerWithIdentifier:@"Login"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goAFNTest:(id)sender{
    AFNDemoViewController *vc = [[AFNDemoViewController alloc]initWithNibName:@"AFNDemoViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)checkVersion:(id)sender {
    NSURLSessionDataTask *URLSessionDataTask =
    [[CheckVersionNetworkClient sharedInstance] checkVersionWithAPPID:@"587767923" success:^(BOOL isLastest, NSString *app_trackViewUrl) {
        if (isLastest == NO) {
            trackViewUrl = app_trackViewUrl;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
            alert.tag = 10000;
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本已是最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 10001;
            [alert show];
        }
        
    } failure:^{
        NSLog(@"网络检查失败");
    }];
    
    //网络请求时候的动画添加
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] init];
    indicatorView.frame = CGRectMake(100, 200, 100, 100);/*calculate frame here*/
    indicatorView.backgroundColor = [UIColor redColor];
    [self.view addSubview:indicatorView];
    [indicatorView setAnimatingWithStateOfTask:URLSessionDataTask];
}


- (IBAction)goDownloadHomeViewController:(id)sender {
    DownloadHomeViewController *viewController = [[DownloadHomeViewController alloc] initWithNibName:@"DownloadHomeViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10000 && buttonIndex == 1) {
        //[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
    }
}

- (IBAction)apiTest:(id)sender{ //测试多次发送返回几次结果
    apiTestCount = 0;
    
    for (int i = 0; i < 10; i++) {
        [self doAPITest];
//        [NSThread detachNewThreadSelector:@selector(doAPITest) toTarget:self withObject:nil];
    }
}


- (void)doAPITest{
    [[TestNetworkClient sharedInstance] requestBaiduHomeSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"接口测试成功。。。%d", apiTestCount++);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"接口测试失败。。。");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

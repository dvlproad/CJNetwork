//
//  ViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "AFNDemoViewController.h"

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
    LoginViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goAFNTest:(id)sender{
    AFNDemoViewController *vc = [[AFNDemoViewController alloc]initWithNibName:@"AFNDemoViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
    
    for (int i = 0; i < 1; i++) {
        [self doAPITest];
//        [NSThread detachNewThreadSelector:@selector(doAPITest) toTarget:self withObject:nil];
    }
}


- (void)doAPITest{
    [[TestNetworkClient sharedInstance] requestBaiduHomeCompleteBlock:^(CJResponseModel *responseModel) {
        if (responseModel.status == 0) {
            NSLog(@"接口测试成功。。。%d", apiTestCount++);
        } else {
            NSLog(@"接口测试失败。。。");
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

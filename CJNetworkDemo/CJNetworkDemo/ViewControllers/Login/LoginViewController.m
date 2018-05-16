//
//  LoginViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "LoginViewController.h"

#import "AppInfoManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nameTextField.text = @"test";
    self.pasdTextField.text = @"test";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange:) name:@"NetworkEnableChange" object:nil];
}

- (void)networkChange:(NSNotification *)notification {
    BOOL networkEnable = [AppInfoManager sharedInstance].networkEnable;
    NSLog(@"当前网络:%@", networkEnable ? @"可用" : @"不可用");
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

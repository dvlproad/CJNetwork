//
//  ViewController.m
//  CommonASIUtilDemo
//
//  Created by lichq on 8/31/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "ViewController.h"
#import "ASIDemoViewController.h"

static int apiTestCount = 0;

@interface ViewController (){
    NSString *trackViewUrl;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"ASIHttpRequest测试", nil);
}

- (IBAction)goAFNTest:(id)sender{
    ASIDemoViewController *vc = [[ASIDemoViewController alloc]initWithNibName:@"ASIDemoViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)checkVersion:(id)sender{
    [CommonASIUtil checkVersionWithAPPID:@"587767923" success:^(BOOL isLastest, NSString *app_trackViewUrl) {
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
    NSString *Url = API_BASE_Url_LookHouse(@"buy/getHouseList");
    NSDictionary *params = @{@"area": @"",
                             @"squareFrom": @"",
                             @"squareTo"  : @"",
                             @"amountForm": @"100",
                             @"amountTo"  : @"200",
                             @"searchConn": @""};
    
    NSURL *URL = [NSURL URLWithString:Url];
    ASIHTTPRequest *request = [CurrentASIRequest request_URL:URL params:params method:ASIRequestType_POST isNeedToken:NO];
    [[CommonASIInstance shareCommonASIInstance] request:request delegate:self userInfo:@{@"requestType": @"doAPITest"}];
}

- (void)onRequestFailure:(ASIHTTPRequest *)request{
    NSLog(@"接口测试失败。。。");
}

- (void)onRequestSuccess:(ASIHTTPRequest *)request{
    NSLog(@"接口测试成功。。。%d", apiTestCount++);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  RepeatRequestViewController.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "RepeatRequestViewController.h"

#import "TestNetworkClient.h"


static int apiTestCount = 0;

@interface RepeatRequestViewController (){
    NSString *trackViewUrl;
}

@end


@implementation RepeatRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"请求的重复发送问题", nil);
    
    
    UIButton *cjTestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cjTestButton setFrame:CGRectMake(50, 100, 200, 40)];
    [cjTestButton setBackgroundColor:[UIColor colorWithRed:0.4 green:0.3 blue:0.4 alpha:0.5]];
    [cjTestButton setTitle:@"接口测试(重复发送)" forState:UIControlStateNormal];
    [cjTestButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cjTestButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cjTestButton addTarget:self action:@selector(apiRepeatTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cjTestButton];
    [cjTestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.top.mas_equalTo(self.view).mas_offset(100);
        make.height.mas_equalTo(44);
    }];
}

- (void)apiRepeatTest { //测试多次发送返回几次结果
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

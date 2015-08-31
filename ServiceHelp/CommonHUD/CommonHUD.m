//
//  CommonHUD.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/6/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CommonHUD.h"
#import <SVProgressHUD.h>

@implementation CommonHUD

+ (void)hud_dismiss{
    dispatch_async(dispatch_get_main_queue(), ^{ //为了确保是在主线程中更新界面
        [SVProgressHUD dismiss];
    });
}

+ (void)hud_showText:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:text maskType:SVProgressHUDMaskTypeClear];
    });
}

+ (void)hud_showLoading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:NSLocalizedString(@"加载中...", nil) maskType:SVProgressHUDMaskTypeClear];
    });
}


+ (void)hud_showNoNetwork
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"网络不给力", nil)];
    });
}

@end

//
//  AFNUtilCheck.m
//  CommonAFNUtilDemo
//
//  Created by 李超前 on 15/11/22.
//  Copyright © 2015年 ciyouzen. All rights reserved.
//

#import "AFNUtilCheck.h"

@implementation AFNUtilCheck

#pragma mark - 私有方法
+ (void)hud_showNoNetwork{
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"网络不给力", nil)];
}

#pragma mark - 公共方法
+ (void)checkVersionWithAPPID:(NSString *)appid success:(void(^)(BOOL isLastest, NSString *app_trackViewUrl))success failure:(void(^)(void))failure{
    
    NSString *Url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appid];//你的应用程序的ID,如587767923
    
    BOOL isNetworkEnabled = [AFNetworkReachabilityManager sharedManager].isReachable;
    if (isNetworkEnabled == NO) {
        //NSLog(@"网络不给力");
        [self hud_showNoNetwork];
    }else{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:Url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
            NSArray *infoArray = [dic objectForKey:@"results"];
            if ([infoArray count]) {
                NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                NSString *lastVersion = [releaseInfo objectForKey:@"version"];//获取appstore最新的版本号
                
                NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
                NSString *curVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
                //NSString *curVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
                
//                NSLog(@"appStore最新版本号为:%@，本地版本号为:%@",lastVersion, curVersion);
                
                if (![lastVersion isEqualToString:curVersion]) {
                    NSString *trackViewUrl = [releaseInfo objectForKey:@"trackViewUrl"];//获取应用程序的地址:即应用程序在appstore中的介绍页面
                    success(NO, trackViewUrl);
                }else{
                    success(YES, nil);
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"检查更新请求发生错误", nil)];
            failure();
        }];
    }
}


@end

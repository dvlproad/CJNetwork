//
//  AFHTTPSessionManager+CJCheckVersion.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "AFHTTPSessionManager+CJCheckVersion.h"

@implementation AFHTTPSessionManager (CJCheckVersion)

- (NSURLSessionDataTask *)checkVersionWithAPPID:(NSString *)appid
                                        success:(void(^)(BOOL isLastest, NSString *app_trackViewUrl))success
                                        failure:(void(^)(void))failure {
    
    NSString *Url = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@", appid]; //你的应用程序的ID,如587767923
    NSDictionary *parameters = nil;
    
    NSURLSessionDataTask *URLSessionDataTask =
    [self POST:Url parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
        NSArray *infoArray = [dic objectForKey:@"results"];
        if ([infoArray count]) {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSString *lastVersion = [releaseInfo objectForKey:@"version"];//获取appstore最新的版本号
            
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *curVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
            NSLog(@"appStore最新版本号为:%@，本地版本号为:%@",lastVersion, curVersion);
            
            if (![lastVersion isEqualToString:curVersion]) {
                NSString *trackViewUrl = [releaseInfo objectForKey:@"trackViewUrl"];//获取应用程序的地址:即应用程序在appstore中的介绍页面
                if (success) {
                    success(NO, trackViewUrl);
                }
                
            } else {
                if (success) {
                    success(YES, nil);
                }
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[SVProgressHUD showErrorWithStatus:NSLocalizedString(@"检查更新请求发生错误", nil)];
        NSLog(@"%@", NSLocalizedString(@"检查更新请求发生错误", nil));
        if (failure) {
            failure();
        }
        
    }];
    
    return URLSessionDataTask;
}

@end

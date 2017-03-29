//
//  CJNetworkClient.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "CJNetworkClient.h"
#import "CJNetworkClientHTTPSessionManager.h"

@implementation CJNetworkClient

+ (CJNetworkClient *)sharedInstance {
    static CJNetworkClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (NSURLSessionDataTask *)checkVersionWithAPPID:(NSString *)appid
                                        success:(void(^)(BOOL isLastest, NSString *app_trackViewUrl))success
                                        failure:(void(^)(void))failure {
    
    NSString *Url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appid]; //你的应用程序的ID,如587767923
    NSDictionary *parameters = nil;
    
    AFHTTPSessionManager *manager = [CJNetworkClientHTTPSessionManager sharedInstance];
    
    NSURLSessionDataTask *URLSessionDataTask =
    [manager cj_postRequestUrl:Url parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
                success(NO, trackViewUrl);
            }else{
                success(YES, nil);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"检查更新请求发生错误", nil)];
        failure();
    }];
    
    
    return URLSessionDataTask;
}


@end

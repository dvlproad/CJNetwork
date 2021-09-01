//
//  AppDelegate.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "AppDelegate.h"
#import "UIWindow+RootSetting.h"
#import <CJMonitor/CJLogSuspendWindow.h>

#import "AppDelegate+StartUp.h"

#import "AppInfoManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[AppInfoManager sharedInstance] startNetworkMonitoring]; //开启网络监听
    
    [self startUp];
    [self performSelector:@selector(tryAutoLogin) withObject:nil afterDelay:0.35f];
    /*
     如果启动就去检测 建议延时调用
     eg:[self performSelector:@selector(login:) withObject:nil afterDelay:0.35f];
     
     由于检测网络有一定的延迟，所以如果启动app立即去检测调用[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus 有可能得到的是status == AFNetworkReachabilityStatusUnknown;但是此时明明是有网的，建议在收到监听网络状态回调以后再取[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus。
     */
    
    // 设置主窗口,并设置根控制器
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window settingRoot];
    
    
    [CJLogSuspendWindow showWithFrame:CGRectMake(10, 200, 100, 100) configBlock:^(CJLogSuspendWindow *bSuspendWindow) {
        
    }];
    
    return YES;
}

- (void)tryAutoLogin{
    //自动登录的功能
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

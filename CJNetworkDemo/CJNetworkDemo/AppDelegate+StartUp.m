//
//  AppDelegate+StartUp.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 1/3/19.
//  Copyright © 2019 dvlproad. All rights reserved.
//

#import "AppDelegate+StartUp.h"
#import "TestNetworkClient.h"
//#import "TestNetworkEnvironmentManager.h"

@implementation AppDelegate (StartUp)

- (void)startUp {
    //TestNetworkEnvironmentManager *environmentManager = [TestNetworkEnvironmentManager sharedInstance];
    //NSString *fullUrl = [environmentManager completeUrlWithApiSuffix:apiSuffix];
    //NSMutableDictionary *allParams = [environmentManager completeParamsWithCustomParams:customParams];
    [TestNetworkClient sharedInstance].baseUrl = @"";
    [TestNetworkClient sharedInstance].commonParams = [NSMutableDictionary dictionaryWithDictionary:@{}];
}

@end

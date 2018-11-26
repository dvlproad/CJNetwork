//
//  CJNetworkEnvironmentManager.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/8/1.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJNetworkEnvironmentManager.h"
#import <CJBaseHelper/DeviceCJHelper.h>
#import <CJBaseHelper/NSObjectCJHelper.h>
#import <OpenUDID/OpenUDID.h>

@interface CJNetworkEnvironmentManager() {
    
}

@end



@implementation CJNetworkEnvironmentManager

+ (CJNetworkEnvironmentManager *)sharedInstance {
    static CJNetworkEnvironmentManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Url
- (NSString *)completeUrlWithApiSuffix:(NSString *)apiSuffix {
    NSString *baseUrl = [self getBaseUrl];
    
    NSString *mainUrl = [[baseUrl stringByAppendingString:apiSuffix] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return mainUrl;
}

- (NSString *)getBaseUrl {
    CJNetworkEnvironmentModel *environmentModel = self.environmentModel;
    
    NSString *hostName = nil;
//    if (environmentModel.useDomain) {
    hostName = environmentModel.domain;
//    } else {
//        hostName = environmentModel.ip;
//    }
//
//    if ([hostName containsString:@"coffee"]){
//        //request.needAddHeader = NO;
//    } else {
//        //request.needAddHeader = YES;
//        hostName = environmentModel.domain;
//    }
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@://%@", environmentModel.schema, hostName];
    baseUrl = [baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return baseUrl;
}

#pragma mark - Params
- (NSDictionary *)completeParamsWithCustomParams:(NSDictionary *)customParams {
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:customParams];
    
    NSDictionary *commonParams = [self completeCommonParamsWithSpecificCommonParams:self.specificCommonParams];
    [allParams addEntriesFromDictionary:commonParams];
    
    return allParams;
}

//CommonParams
- (NSDictionary *)completeCommonParamsWithSpecificCommonParams:(NSDictionary *)specificCommonParams
{
    NSMutableDictionary *commonParams = [[NSMutableDictionary alloc] init];
    
    NSString *udid = [OpenUDID value];
    [commonParams setObject:udid forKey:@"imei"];
    
    NSString *currentDevicePlatform = [DeviceCJHelper getCurrentDeviceName];
    [commonParams setValue:currentDevicePlatform forKey:@"device_type_phone"];
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    appVersion = [appVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (appVersion.length == 2) {
        appVersion = [appVersion stringByAppendingString:@"00"];
    } else if (appVersion.length == 3) {
        appVersion = [appVersion stringByAppendingString:@"0"];
    }
    [commonParams setValue:appVersion forKey:@"appVersion"];
    
//    NSString *appNameType = LuckinDriverAppNameType;
//    [commonParams setValue:appNameType forKey:@"app_type"];
//
//    NSInteger appDataSourceType = LuckinDriverAppDataSourceType;
//    [commonParams setValue:@(appDataSourceType) forKey:@"app"];
    if (specificCommonParams) {
        //[commonParams setValue:kCid forKey:@"mapiVersion"]; //必须添加
        [commonParams addEntriesFromDictionary:specificCommonParams];
    }
    
    return commonParams;
}


@end

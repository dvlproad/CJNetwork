//
//  NetworkUtil.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/5/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "NetworkUtil.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation NetworkUtil

//获取wifi名称即SSID(SSID全称Service Set IDentifier, 即Wifi网络的公开名称)
//模拟器测试无效，始终为空，真机有效
+ (NSString *)getSSID
{
    NSString *ssid = nil;
    NSArray *ifs = (NSArray *)CFBridgingRelease(CNCopySupportedInterfaces());
    NSDictionary *info = nil;
    
    if(ifs == nil){
        //NSLog(@"can not find interface");
        return nil;
    }
    
    for (NSString *ifnam in ifs)
    {
        info = (NSDictionary *)CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam));
        
        if (info && [info count])
        {
            ssid = [info objectForKey:@"SSID"];
            if(ssid != nil)
                break;
        }
    }
    
    return ssid;
}


@end

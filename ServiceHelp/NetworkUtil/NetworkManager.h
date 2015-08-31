//
//  NetworkManager.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 7/31/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reachability.h>

@protocol NetWorkManagerDelegate;

@interface NetworkManager: NSObject
///!!!NOTICE:WNEH YOU WANT TO GET THIS,YOU MUST START THE WATCH FIRST
@property (nonatomic, assign, readonly, getter = curNetworkStatus) NetworkStatus curNetworkStatus;
///!!!NOTICE:WNEH YOU WANT TO GET THIS,YOU MUST START THE WATCH FIRST
@property (nonatomic, assign, readonly, getter = isNetworkEnabled) BOOL isNetworkEnabled;
@property (nonatomic, weak) id<NetWorkManagerDelegate> delegate;

+ (NetworkManager *)sharedInstance; //获取网络管理器
- (BOOL)startNetworkeWatch:(NSString*)address;  //开始检测网络
- (void)stopNetworkWatch;                       //停止检测网络
- (NetworkStatus)checkNowNetWorkStatus:(NSString *)address; //检测当前网络状态

- (BOOL)isHasNetWork:(NSString *)address;    //是否有网络
- (BOOL)isWiFiNetWork:(NSString *)address;   //是否Wifi
- (BOOL)isWWANiNetWork:(NSString *)address;  //是否3G/GPRS

@end


//您的应用程序需要实现此协议，当网络发生变化时候，与用户交互
@protocol NetWorkManagerDelegate
//@required
@optional
- (void)netWorkStatusWillChange:(NetworkStatus)status;

@optional
- (void)netWorkStatusWillEnabled;
- (void)netWorkStatusWillEnabledViaWifi;
- (void)netWorkStatusWillEnabledViaWWAN;
- (void)netWorkStatusWillDisconnection;
@end


//
//  NetworkManager.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 7/31/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "NetworkManager.h"
#import "NetworkUtil.h"

@interface NetworkManager ()
{
    Reachability *reach;
}

@end





@implementation NetworkManager

+ (NetworkManager *)sharedInstance{
    static NetworkManager *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NetworkManager alloc] init];
    });
    
    return sharedManager;
}

- (BOOL)startNetworkeWatch:(NSString*)address{
    NSLog(@"开始监听网络");
    
    //在这里获取网络的变化，然后再发送一个新的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChangedAction:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    NSString *hostName = @"www.baidu.com";
    if (address && ([address compare:@""] != NSOrderedSame)){
        hostName = address;
    }
    
    reach = [Reachability reachabilityWithHostName:hostName];
    _curNetworkStatus = [reach currentReachabilityStatus];
    _isNetworkEnabled = _curNetworkStatus != NotReachable;
    BOOL finish = [reach startNotifier];//开启网络状况的监听
    return finish;
}

- (NetworkStatus)checkNowNetWorkStatus:(NSString*)address{
    NSString *hostName = @"www.baidu.com";
    if (address && ([address compare:@""] != NSOrderedSame)){
        hostName = address;
    }
    
    Reachability *curReach = [Reachability reachabilityWithHostName:hostName];//reachabilityForLocalWiFi不能判断出该Wi-Fi能否上网，所以用reachabilityWithHostName加个具体的网址
    _curNetworkStatus = [curReach currentReachabilityStatus];
    _isNetworkEnabled = _curNetworkStatus != NotReachable;
    return _curNetworkStatus;
}

- (void)stopNetworkWatch{
    [reach stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 网络状态改变时，执行如下方法：
- (void)reachabilityChangedAction:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    NSString *ssid = [NetworkUtil getSSID];
    if(ssid){
        ssid = [NSString stringWithFormat:@"Wi-Fi：%@", ssid];
    }
    NSLog(@"检测到网络状态发生变化:%@", ssid);
    
    //调用代理方法,此方法为必须实现
    if ([(NSObject*)self.delegate respondsToSelector:@selector(netWorkStatusWillChange:)])
        [self.delegate netWorkStatusWillChange:status];
    
    //代理的可选方法
    switch (status){
        case NotReachable:{
            //网络不可达
            NSLog(@"提示：当前无网络连接");
            _isNetworkEnabled = NO;
            _curNetworkStatus = NotReachable;
            
            if ([(NSObject*)self.delegate respondsToSelector:@selector(netWorkStatusWillDisconnection)]){
                [self.delegate netWorkStatusWillDisconnection];
            }
            break;
        }
        case ReachableViaWiFi:{
            //网络可达
            NSLog(@"提示：当前为WiFi连接");
            _isNetworkEnabled = YES;
            _curNetworkStatus = ReachableViaWiFi;
            
            if ([(NSObject*)self.delegate respondsToSelector:@selector(netWorkStatusWillEnabledViaWifi)]){
                [self.delegate netWorkStatusWillEnabledViaWifi];
            }
            break;
        }
        case ReachableViaWWAN:{
            //网络可达
            NSLog(@"提示：当前为3G/GPRS连接");
            _isNetworkEnabled = YES;
            _curNetworkStatus = ReachableViaWWAN;
            
            if ([(NSObject*)self.delegate respondsToSelector:@selector(netWorkStatusWillEnabledViaWWAN)]){
                [self.delegate netWorkStatusWillEnabledViaWWAN];
            }
            break;
        }
        default:
            break;
    }
}


- (BOOL)isHasNetWork:(NSString*)address{
    NetworkStatus result= [self checkNowNetWorkStatus:address];
    return  result != NotReachable;
}

- (BOOL)isWiFiNetWork:(NSString*)address{
    NetworkStatus result= [self checkNowNetWorkStatus:address];
    return  result == ReachableViaWiFi;
}

- (BOOL)isWWANiNetWork:(NSString*)address{
    NetworkStatus result= [self checkNowNetWorkStatus:address];
    return  result == ReachableViaWWAN;
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

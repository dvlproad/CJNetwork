//
//  CommonASIInstance.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/10/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CommonASIInstance.h"
#import "NetworkManager.h"

static CommonASIInstance *_shareCommonASIInstance;

@implementation CommonASIInstance

+ (CommonASIInstance *)shareCommonASIInstance{
    /*
    static CommonASIInstance *_shareCommonASIInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareCommonASIInstance = [[self alloc] init];
        [[NetworkManager sharedInstance] startNetworkeWatch:nil];
    });
    return _shareCommonASIInstance;
    */
    
    @synchronized([CommonASIInstance class]){ //为了只去一个实例，也为了能取到同一个实例来取消之前的请求
        if (_shareCommonASIInstance == nil) {
            _shareCommonASIInstance = [[CommonASIInstance alloc]init];
        }
        
        if (_shareCommonASIInstance.requestCurrent) {
            [_shareCommonASIInstance.requestCurrent clearDelegatesAndCancel];
        }
    }
    return _shareCommonASIInstance;
}



- (void)request:(ASIHTTPRequest *)request delegate:(id<WebServiceASIDelegate>)delegate userInfo:(NSDictionary *)userInfo{
    [CommonASIUtil request:request delegate:delegate userInfo:userInfo];
}

@end

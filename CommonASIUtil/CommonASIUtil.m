//
//  CommonASIUtil.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CommonASIUtil.h"
#import "ResponseASIHandler.h"
#import "CommonHUD.h"
#import "CurrentASIRequest.h"
#import "NetworkManager.h"


#define kWebServiceDelegate @"WebServiceDelegate"

@implementation CommonASIUtil


#pragma mark - CommonUtil
//使用callback delegate的时候
+ (void)request:(ASIHTTPRequest *)request delegate:(id<WebServiceASIDelegate>)delegate userInfo:(NSDictionary *)userInfo{
    BOOL isNetworkEnabled = [NetworkManager sharedInstance].isNetworkEnabled;
    if (isNetworkEnabled == NO) {
        NSLog(@"提示：这里之前未缓存，无法读取缓存，提示网络不给力");
        [CommonHUD hud_showNoNetwork];
        return;
    }
    
    UIProgressView *progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    //[request setDownloadProgressDelegate:self];
    [request setShowAccurateProgress:YES];
    
//    NSMutableDictionary *newUserInfo = [NSMutableDictionary dictionaryWithDictionary:request.userInfo];
    NSMutableDictionary *newUserInfo = [[NSMutableDictionary alloc]initWithDictionary:userInfo];
    [newUserInfo setObject:delegate forKey:kWebServiceDelegate];
    [newUserInfo setObject:progressView forKey:@"progressView"];
    [request setUserInfo:newUserInfo];//用来返回的时候判断是哪个请求，一个页面有多个请求时候可用。
    
    
    [request setDelegate:self]; //使用setDidFinishSelector时候，记得加上setDelegate:self//异步需添加ASIHTTPRequestDelegate甚至再加上ASIProgressDelegate
    //由于[request setDelegate:self];是实例方法，所以写该行代码的方法也应该是实例方法，而不应该是类方法，否则即使添加并设置了协议，也不会走到协议里面去。这点在其他类似的委托中也应该注意。
    //但如果写[request setDelegate:self]; 的方法就一定是类方法呢？此时我们就应该通过setDidFailSelector等来让它执行对应的回调方法。
    [request setDidStartSelector:@selector(didStartRequest:)];
    [request setDidFailSelector:@selector(didFailRequest:)];
    [request setDidFinishSelector:@selector(didFinishedRequest:)];
    
    
    
    [request startAsynchronous];
}


#pragma mark - 获取request
+ (ASIHTTPRequest *)request_URL:(NSURL *)URL params:(NSDictionary *)params method:(ASIRequestType)requestType{
    
    //isValidJSONObject判断对象是否可以构建成json对象
    if (params != nil && [NSJSONSerialization isValidJSONObject:params] == NO) {
        NSLog(@"error: isNotValidJSONObject and will return request = nil");
        return nil;
    }
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    NSString *method = @"GET";
    switch (requestType) {
        case ASIRequestType_POST:
            method = @"POST";
            break;
        case ASIRequestType_PUT:
            method = @"PUT";
            break;
        default:
            break;
    }
    [request setRequestMethod:method];//@"POST"等
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    //[request addRequestHeader:@"Accept" value:@"application/json"];//不用写
    
    NSLog(@"Register URL:%@", URL);
    if (params != nil && [NSJSONSerialization isValidJSONObject:params]) {
        NSError *error;
        
        //创建一个jsonData
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];//NSJSONWritingPrettyPrinted指定的JSON数据产的空白，使输出更具可读性
        
        
        //NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];// 返回一个JSON对象
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Register JSON:%@", jsonString);
        
        [request setPostBody:[NSMutableData dataWithData:jsonData]];
    }
    
    
    return request;
}




//请求开始的时候调用
+ (void)didStartRequest:(ASIHTTPRequest *)request{
    
}

//请求失败的时候调用
+ (void)didFailRequest:(ASIHTTPRequest *)request{
    id<WebServiceASIDelegate> delegate=[request.userInfo objectForKey:kWebServiceDelegate];
    [ResponseASIHandler onFailure:request callback:delegate]; //ResponseHandler是为了更好的封装
}

//请求成功完成的时候调用
+ (void)didFinishedRequest:(ASIHTTPRequest *)request{
    id<WebServiceASIDelegate> delegate=[request.userInfo objectForKey:kWebServiceDelegate];
    [ResponseASIHandler onSuccess:request callback:delegate];
}



/*
 //其他方法
 - (void)requestRedirected:(ASIHTTPRequest *)request{//TODO这个重定向是干嘛的
 
 }
 
 - (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
 //    NSLog(@"Value: %f", [myProgressIndicator progress]//重写这个方法的时候，如果不对data数据做处理的话，会导致requestFinished中回传的数据为空。所以一般不要去重写
 }
 
 
 downloadProgressDelegates方法
 request:didReceiveBytes: 每次request下载了更多数据时，这个函数会被调用（注意，这个函数与一般的代理实现的 request:didReceiveData:函数不同）。
 request:incrementDownloadSizeBy: 当下载的大小发生改变时，这个函数会被调用，传入的参数是你需要增加的大小。这通常发生在request收到响应头并且找到下载大小时。
 uploadProgressDelegates方法
 request:didSendBytes: 每次request可以发送更多数据时，这个函数会被调用。注意：当一个request需要消除上传进度时（通常是该request发送了一段数据，但是因为授权失败或者其他什么原因导致这段数据需要重发）这个函数会被传入一个小于零的数字。
 - (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes{
 UIProgressView *progressView = [request.userInfo objectForKey:@"progressView"];
 NSLog(@"didReceiveBytes Value: %f %lld", [progressView progress], bytes);
 }
 
 - (void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength{
 UIProgressView *progressView = [request.userInfo objectForKey:@"progressView"];
 NSLog(@"incrementUploadSizeBy Value: %f %lld", [progressView progress], newLength);
 }
 */




+ (void)checkVersionWithAPPID:(NSString *)appid success:(void(^)(BOOL isLastest, NSString *app_trackViewUrl))success failure:(void(^)(void))failure{
    
//    NSString *Url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appid];//你的应用程序的ID,如587767923
//    NSURL *URL = [NSURL URLWithString:Url];
    
    NSLog(@"未提供ASI版本检查");
    return;
    
    /* //使用 ASIHTTPRequest
     ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
     [request addRequestHeader:@"Content-Type" value:@"multipart/form-data;boundary=*****"]; //不能漏
     [request setRequestMethod:@"POST"];
     [request startSynchronous];//同步
     */
    
    /*
    //使用 NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    //[request setHTTPBody:[@"type=focus-c" dataUsingEncoding:NSUTF8StringEncoding]];//设置参数
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    //方法一：同步POST的请求以及请求所得的数据
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];//data转string方法一:优先使用此方法
    //NSString *results = [[NSString alloc]initWithData:recervedData encoding:NSUTF8StringEncoding];//data转string方法二
    
    
    
    NSDictionary *dic = [results JSONValue];
    
    NSArray *infoArray = [dic objectForKey:@"results"];
    if ([infoArray count]) {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];//获取appstore最新的版本号
        
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *curVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        //NSString *curVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
        
        NSLog(@"appStore最新版本号为:%@，本地版本号为:%@",lastVersion, curVersion);
        
        if (![lastVersion isEqualToString:curVersion]) {
            NSString *trackViewUrl = [releaseInfo objectForKey:@"trackViewUrl"];//获取应用程序的地址:即应用程序在appstore中的介绍页面
            success(NO, trackViewUrl);
        }else{
            success(YES, nil);
        }
    }
    */
    
    /*
    //方法二：异步POST：委托方法略，即这里没写
    //NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    */
}


@end

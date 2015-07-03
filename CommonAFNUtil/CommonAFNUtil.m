//
//  CommonAFNUtil.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CommonAFNUtil.h"
#import "ResponseAFNHandler.h"

@implementation CommonAFNUtil

#pragma mark - magager定义
+ (AFHTTPRequestOperationManager *)manager
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //即manager的requestSerializer和responseSerializer默认都是AFJSON。。。请求的结果可以为json、xml、http。
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];  //申明请求的数据是json类型，都不加也可以
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; //申明返回的结果是json类型，都不加也可以
    //manager.responseSerializer = [AFXMLParserResponseSerializer serializer];    //xml方式获取数据
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];         //http
    //manager.requestSerializer.stringEncoding =
    //manager.responseSerializer.stringEncoding =
    //manager.requestSerializer setValue:<#(NSString *)#> forHTTPHeaderField:<#(NSString *)#>
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    return manager;
}


#pragma mark - GET方式获取数据
+ (AFHTTPRequestOperation *)getRequestUrl:(NSString *)Url params:(NSDictionary *)params delegate:(id<WebServiceAFNDelegate>)delegate{
    return [CommonAFNUtil getRequestUrl:Url params:params delegate:delegate tag:0];
}

+ (AFHTTPRequestOperation *)getRequestUrl:(NSString *)Url params:(NSDictionary *)params delegate:(id<WebServiceAFNDelegate>)delegate tag:(NSInteger)tag{
    AFHTTPRequestOperationManager *manager = [self manager];
    
    AFHTTPRequestOperation *operation =
    [manager GET:Url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ResponseAFNHandler onSuccess:operation callback:delegate tag:tag];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ResponseAFNHandler onFailure:operation callback:delegate tag:tag];
        
    }];
    return operation;
}


#pragma mark - POST方式获取数据
+ (AFHTTPRequestOperation *)postRequestUrl:(NSString *)Url params:(NSDictionary *)params delegate:(id<WebServiceAFNDelegate>)delegate{
    return [CommonAFNUtil postRequestUrl:Url params:params delegate:delegate tag:0];
}

+ (AFHTTPRequestOperation *)postRequestUrl:(NSString *)Url params:(NSDictionary *)params delegate:(id<WebServiceAFNDelegate>)delegate tag:(NSInteger)tag{
    AFHTTPRequestOperationManager *manager = [self manager];
    
    AFHTTPRequestOperation *operation =
    [manager POST:Url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ResponseAFNHandler onSuccess:operation callback:delegate tag:tag];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ResponseAFNHandler onFailure:operation callback:delegate tag:tag];
        
    }];
    return operation;
}


@end

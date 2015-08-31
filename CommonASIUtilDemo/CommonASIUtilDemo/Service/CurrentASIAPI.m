//
//  CurrentASIAPI.m
//  CommonASIUtilDemo
//
//  Created by lichq on 8/10/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CurrentASIAPI.h"

@implementation CurrentASIAPI

+ (void)requestLogin_name:(NSString *)name pasd:(NSString *)pasd delegate:(id<WebServiceASIDelegate>)delegate userInfo:(NSDictionary *)userInfo{
    NSURL *URL = API_BASE_Url_Health(@"login");
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:name forKey:@"username"];
    [params setValue:pasd forKey:@"password"];
    
    ASIHTTPRequest *request = [CurrentASIRequest request_URL:URL params:params method:ASIRequestType_POST isNeedToken:NO];
    [[CommonASIInstance shareCommonASIInstance] request:request delegate:delegate userInfo:userInfo];
    //[CommonASIUtil request:request delegate:delegate userInfo:userInfo];
}


@end

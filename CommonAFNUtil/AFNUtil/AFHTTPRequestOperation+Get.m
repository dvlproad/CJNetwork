//
//  AFHTTPRequestOperation+Get.m
//  CommonAFNUtilDemo
//
//  Created by 李超前 on 15/11/22.
//  Copyright © 2015年 ciyouzen. All rights reserved.
//

#import "AFHTTPRequestOperation+Get.h"

@implementation AFHTTPRequestOperation (Get)

//400 (语法错误)　　401 (未通过验证)　　403 (拒绝请求)　　404 (找不到请求的页面)　　500 (服务器内部错误)
- (NSString *)failMesg:(AFHTTPRequestOperation *)operation{
    NSString *failMesg = @"";
    NSInteger statusCode = operation.response.statusCode;//参照服务器状态码大全
    if (statusCode == 400){
        failMesg = NSLocalizedString(@"语法错误", nil);
    }else if (statusCode == 401){
        failMesg = NSLocalizedString(@"未通过验证", nil);
    }else if (statusCode == 403){
        failMesg = NSLocalizedString(@"拒绝请求", nil);
    }else if (statusCode == 404){
        failMesg = NSLocalizedString(@"找不到请求的页面", nil);
    }else if (statusCode == 500){
        failMesg = NSLocalizedString(@"服务器内部错误", nil);
    }else{
        failMesg = operation.responseString;
    }
    
    return failMesg;
}

- (NSMutableDictionary *)responseObject_dic:(AFHTTPRequestOperation *)operation{
    //id responseObject = operation.responseObject;
    NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *responseObject_dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
    //NSLog(@"responseObject_dic = %@", responseObject_dic);
    
    /*
     //NSJSONReadingMutableContainers的作用: http://blog.csdn.net/chenyong05314/article/details/45691041
     NSJSONReadingMutableContainers：返回可变容器，NSMutableDictionary或NSMutableArray。
     NSJSONReadingMutableLeaves：返回的JSON对象中字符串的值为NSMutableString
     NSJSONReadingAllowFragments：允许JSON字符串最外层既不是NSArray也不是NSDictionary，但必须是有效的JSON Fragment。例如使用这个选项可以解析 @“123” 这样的字符串。
     */
    return responseObject_dic;
}


@end

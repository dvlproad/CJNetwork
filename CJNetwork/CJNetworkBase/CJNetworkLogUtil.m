//
//  CJNetworkLogUtil.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJNetworkLogUtil.h"
#import "CJNetworkErrorUtil.h"
#import "CJNetworkInfoModel.h"

@implementation CJNetworkLogUtil

///successNetworkLog
+ (id)printSuccessNetworkLogWithUrl:(NSString *)Url params:(id)params request:(NSURLRequest *)request responseObject:(id)responseObject
{
    NSString *bodyString = [self getBodyStringForRequest:request];
    
    NSString *responseJsonString = [CJNetworkLogUtil formattedStringFromObject:responseObject];
    
    CJNetworkInfoModel *networkInfoModel = [[CJNetworkInfoModel alloc] init];
    networkInfoModel.Url = Url;
    networkInfoModel.params = params;
    networkInfoModel.bodyString = bodyString;
    networkInfoModel.responseString = responseJsonString;
    
    NSMutableString *networkLogString = [CJNetworkLogUtil networkLogStringWithNetworkInfoModel:networkInfoModel];
    [CJNetworkLogUtil printConsoleNetworkLog:networkLogString];
    
    
    BOOL addNetworkLog = NO; //是否在增加cjNetworkLog字段给response，在调试时候有用
    if (addNetworkLog) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *mutableResponseObject = [NSMutableDictionary dictionaryWithDictionary:responseObject];
            [mutableResponseObject setObject:networkLogString forKey:@"cjNetworkLog"];
            
            return mutableResponseObject;
        } else {
            return responseObject;
        }
        
    } else {
        return responseObject;
    }
}

///errorNetworkLog
+ (NSError *)printErrorNetworkLogWithUrl:(NSString *)Url params:(id)params request:(NSURLRequest *)request error:(NSError *)error URLResponse:(NSURLResponse *)URLResponse
{
    NSString *bodyString = [self getBodyStringForRequest:request];
    
    NSString *cjErrorMeesage = [CJNetworkErrorUtil getErrorMessageFromURLResponse:URLResponse];
    NSString *responseJsonString = cjErrorMeesage;
    
    CJNetworkInfoModel *networkInfoModel = [[CJNetworkInfoModel alloc] init];
    networkInfoModel.Url = Url;
    networkInfoModel.params = params;
    networkInfoModel.bodyString = bodyString;
    networkInfoModel.responseString = responseJsonString;
    
    NSMutableString *networkLogString = [CJNetworkLogUtil networkLogStringWithNetworkInfoModel:networkInfoModel];
    [CJNetworkLogUtil printConsoleNetworkLog:networkLogString];
    
    NSMutableDictionary *moreUserInfo = [NSMutableDictionary dictionary];
    [moreUserInfo setObject:cjErrorMeesage forKey:@"cjNewErrorMeesage"];
    
    BOOL addNetworkLog = NO; //是否在增加cjNetworkLog字段给response，在调试时候有用
    if (addNetworkLog) {
        //[moreUserInfo setValue:cjErrorMeesage forKey:NSLocalizedDescriptionKey];
        [moreUserInfo setObject:networkLogString forKey:@"cjNetworkLog"];
    }
    
    NSError *newError = [CJNetworkErrorUtil getNewErrorWithError:error withMoreUserInfo:moreUserInfo];
    
    return newError;
}

///获取最后实际传到服务器的body
+ (NSString *)getBodyStringForRequest:(NSURLRequest *)request {
    NSData *bodyData = request.HTTPBody;
    if (bodyData == nil) {
        return nil;
    }
    
    NSString *bodyString = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    return bodyString;
}

#pragma mark - Private
+ (void)printConsoleNetworkLog:(NSString *)networkLog {
    NSMutableString *consoleLog = [NSMutableString string];
    [consoleLog appendFormat:@"\n\n"];
    [consoleLog appendFormat:@"  >>>>>>>>>>>>  网络请求Start  >>>>>>>>>>>>  \n"];
    [consoleLog appendFormat:@"%@\n", networkLog];
    [consoleLog appendFormat:@"  <<<<<<<<<<<<<  网络请求End  <<<<<<<<<<<<<  \n"];
    [consoleLog appendFormat:@"\n\n"];
    NSLog(@"%@", consoleLog);
}

+ (NSMutableString *)networkLogStringWithNetworkInfoModel:(CJNetworkInfoModel *)networkInfoModel {
    NSString *Url = networkInfoModel.Url;
    
    //将传给服务器的参数用字符串打印出来
    id params = networkInfoModel.params;
    NSString *allParamsJsonString = [CJNetworkLogUtil formattedStringFromObject:params];
    //NSLog(@"传给服务器的json参数:%@", allParamsJsonString);
    
    NSString *bodyString = networkInfoModel.bodyString;
    
    NSString *responseString = networkInfoModel.responseString;
    
    
    
    
    
    NSMutableString *networkLog = [NSMutableString string];
    [networkLog appendFormat:@"地址：%@ \n", Url];
    [networkLog appendFormat:@"原始参数：%@ \n", allParamsJsonString];
    [networkLog appendFormat:@"最终参数：%@ \n", bodyString];
    [networkLog appendFormat:@"结果：%@ \n", responseString];
    
    //[networkLog appendFormat:@"\n"];
    //[networkLog appendFormat:@"传给服务器的json参数：%@", allParamsJsonString];
    
    return networkLog;
}


+ (NSString *)formattedStringFromObject:(id)object
{
    if ([object isKindOfClass:[NSString class]]) {
        return object;
        
    } else if ([object isKindOfClass:[NSDictionary class]]) {
//        NSString *indentedString = [self fullFormattedStringFromDictionary:object];
//        return indentedString;
        
        NSString *JSONString = nil;
        if ([NSJSONSerialization isValidJSONObject:object]) {
            NSError *error;
            NSData *JSONData = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
            JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
        }
        return JSONString;
        
    } else if ([object isKindOfClass:[NSArray class]]) {
//        NSString *indentedString = [CJIndentedStringUtil easyFormattedStringFromArray:object];
//        return indentedString;
        
        NSString *JSONString = nil;
        if ([NSJSONSerialization isValidJSONObject:object]) {
            NSError *error;
            NSData *JSONData = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
            JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
        }
        return JSONString;
        
    } else {
        return nil;
    }
}


//以下方法来自：#import <CJBaseUtil/CJIndentedStringUtil.h>
///从服务器得到的JSON数据解析成NSDictionary后，通过递归遍历多维的NSDictionary可以方便的把字典中的所有键值输出出来方便测试检查。
+ (NSMutableString *)fullFormattedStringFromDictionary:(NSDictionary *)dictionary {
    NSMutableString *indentedString = [self fullFormattedStringFromDictionary:dictionary flagPrefix:@"" textPrefix:@"\t"];
    return indentedString;
}

+ (NSMutableString *)fullFormattedStringFromDictionary:(NSDictionary *)dictionary flagPrefix:(NSString *)flagPrefix textPrefix:(NSString *)textPrefix {
    NSMutableString *indentedString = [NSMutableString string];
    
    
    [indentedString appendFormat:@"%@{\n", flagPrefix]; // 开头有个{
    
    NSArray *keys = [dictionary allKeys];
    for (NSString *key in keys) {
        id currentObject = [dictionary objectForKey:key];
        if ([currentObject isKindOfClass:[NSDictionary class]]) {
            [indentedString appendFormat:@"%@", textPrefix];
            [indentedString appendFormat:@"%@:\n", key];
            
            NSDictionary *subDictionary = currentObject;
            NSString *newFlagPrefix = [NSString stringWithFormat:@"%@\t", flagPrefix];
            NSString *newTextPrefix = [NSString stringWithFormat:@"%@\t", textPrefix];
            NSString *formattedString = [self fullFormattedStringFromDictionary:subDictionary flagPrefix:newFlagPrefix textPrefix:newTextPrefix];
            [indentedString appendFormat:@"%@\n", formattedString];
            
            
        } else if ([currentObject isKindOfClass:[NSArray class]]) {
            [indentedString appendFormat:@"%@", textPrefix];
            [indentedString appendFormat:@"%@:[\n",key];// 开头有个[
            
            
            NSInteger keyLength = key.length + 2;
            NSMutableString *appendKonggeString = [NSMutableString string];
            for (NSInteger i = 0; i < keyLength; i++) {
                [appendKonggeString appendFormat:@" "];
            }
            NSString *newFlagPrefix = [NSString stringWithFormat:@"%@%@", textPrefix, appendKonggeString];
            NSString *newTextPrefix = [NSString stringWithFormat:@"%@\t", newFlagPrefix];
            for (id obj in currentObject) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    NSString *formattedString = [self fullFormattedStringFromDictionary:obj flagPrefix:newFlagPrefix textPrefix:newTextPrefix];
                    [indentedString appendFormat:@"%@\n", formattedString];
                } else {
                    [indentedString appendFormat:@"%@", newTextPrefix];
                    
                    NSString *formattedString = obj;
                    [indentedString appendFormat:@"%@,\n", formattedString];
                }
                
            }
            
            [indentedString appendFormat:@"%@]\n", textPrefix];   // 结尾有个]
            
        } else {
            id vaule = currentObject;
            [indentedString appendFormat:@"%@", textPrefix];
            [indentedString appendFormat:@"%@", key];
            [indentedString appendString:@": "];
            [indentedString appendFormat:@"%@,\n", vaule];
        }
    }
    
    
    [indentedString appendFormat:@"%@}", flagPrefix];   // 结尾有个}
    
    return indentedString;
}

@end

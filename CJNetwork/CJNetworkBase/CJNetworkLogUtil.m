//
//  CJNetworkLogUtil.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJNetworkLogUtil.h"
#import "CJNetworkErrorUtil.h"

@implementation CJNetworkLogUtil

///successNetworkLog
+ (id)printSuccessNetworkLogWithUrl:(NSString *)Url params:(id)params responseObject:(id)responseObject
{
    NSString *responseJsonString = [CJNetworkLogUtil formattedStringFromObject:responseObject];
    
    NSMutableString *networkLog = [CJNetworkLogUtil networkLogWithUrl:Url
                                                               params:params
                                                       responseString:responseJsonString];
    [CJNetworkLogUtil printConsoleNetworkLog:networkLog];
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableResponseObject = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        [mutableResponseObject setObject:networkLog forKey:@"cjNetworkLog"];
        
        return mutableResponseObject;
    } else {
        return responseObject;
    }
}

///errorNetworkLog
+ (NSError *)printErrorNetworkLogWithUrl:(NSString *)Url params:(id)params error:(NSError *)error URLResponse:(NSURLResponse *)URLResponse
{
    NSString *cjErrorMeesage = [CJNetworkErrorUtil getErrorMessageFromURLResponse:URLResponse];
    NSString *responseJsonString = cjErrorMeesage;
    
    NSMutableString *networkLog = [CJNetworkLogUtil networkLogWithUrl:Url
                                                               params:params
                                                       responseString:responseJsonString];
    [CJNetworkLogUtil printConsoleNetworkLog:networkLog];
    
    NSMutableDictionary *moreUserInfo = [NSMutableDictionary dictionary];
    [moreUserInfo setObject:cjErrorMeesage forKey:@"cjNewErrorMeesage"];
    //[moreUserInfo setValue:cjErrorMeesage forKey:NSLocalizedDescriptionKey];
    [moreUserInfo setObject:networkLog forKey:@"cjNetworkLog"];
    
    NSError *newError = [CJNetworkErrorUtil getNewErrorWithError:error withMoreUserInfo:moreUserInfo];
    
    return newError;
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

+ (NSMutableString *)networkLogWithUrl:(NSString *)Url params:(id)params responseString:(NSString *)responseString {
    //将传给服务器的参数用字符串打印出来
    NSString *allParamsJsonString = [CJNetworkLogUtil formattedStringFromObject:params];
    //NSLog(@"传给服务器的json参数:%@", allParamsJsonString);
    
    NSMutableString *networkLog = [NSMutableString string];
    [networkLog appendFormat:@"地址：%@ \n", Url];
    [networkLog appendFormat:@"参数：%@ \n", allParamsJsonString];
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

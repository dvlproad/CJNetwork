//
//  CJSimulateLocalUtil.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/4/8.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJSimulateLocalUtil.h"

@implementation CJSimulateLocalUtil

#pragma mark - Local请求模拟

/*
 *  开始本地模拟接口请求
 *
 *  @param apiSuffix        api文件的本地路径(可以不带.json，也可以带)
 *  @param completeBlock    获取到数据的回调
 */
+ (void)localSimulateApi:(NSString *)apiSuffix completeBlock:(void (^)(NSDictionary *responseDictionary))completeBlock
{
    if ([apiSuffix hasPrefix:@"/"]) {
        apiSuffix = [apiSuffix substringFromIndex:1];
    }
    NSString *jsonName = [apiSuffix stringByReplacingOccurrencesOfString:@"/" withString:@":"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:jsonName ofType:nil];
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (exists == NO) {
        jsonName = [jsonName stringByAppendingPathExtension:@"json"];
        filePath = [[NSBundle mainBundle] pathForResource:jsonName ofType:nil];
        exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    }
    
    NSData *responseObject = [NSData dataWithContentsOfFile:filePath];
    if (!responseObject) { //不设置会崩溃
        NSString *message = [NSString stringWithFormat:@"本地请求模拟：却未实现模拟的请求文件%@", apiSuffix];
        NSDictionary *lackOfLocalResponseDic =
        @{@"status" : @"0",
          @"message": message,
          @"result" : @""
          };
        responseObject = [NSJSONSerialization dataWithJSONObject:lackOfLocalResponseDic options:NSJSONWritingPrettyPrinted error:nil];
    }
    
    NSDictionary *recognizableResponseObject = nil;
    //if ([NSJSONSerialization isValidJSONObject:responseObject]) {
    //    recognizableResponseObject = responseObject;
    //} else {
    NSError *jsonError = nil;
    recognizableResponseObject = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&jsonError];
    //}
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *responseDictionary = recognizableResponseObject;
        if (completeBlock) {
            completeBlock(responseDictionary);
        }
        /* // responseDictionary --> responseModel
        CJResponseModel *responseModel = [[CJResponseModel alloc] init];
        responseModel.statusCode = [responseDictionary[@"status"] integerValue];
        responseModel.message = responseDictionary[@"message"];
        responseModel.result = responseDictionary[@"result"];
        responseModel.isCacheData = NO;
        if (success) {
            success(responseModel);
        }
        */
    });
}


@end

//
//  CJUploadMomentInfo.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/8/26.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJUploadMomentInfo.h"

@implementation CJUploadMomentInfo

#pragma mark - 测试用的Demo示例
/*
 *  从请求结果responseObject中获取上传请求的时刻信息momentInfo(提供给 getUploadMomentInfoFromResopnseBlock 使用)
 *
 *  @param responseObject   请求结果
 *
 *  @return 上传请求的时刻信息（已包括 CJUploadMomentState 和 responseModel）
 */
/*
+ (CJUploadMomentInfo *)getUploadMomentInfoFromResopnseObject:(id)responseObject {
    NSInteger responseModelstatus = [responseObject[@"status"] integerValue];
    NSString *responseModelmessage = responseObject[@"msg"];
    id responseModelresult = responseObject[@"result"];
    
    CJUploadMomentInfo *momentInfo = [[CJUploadMomentInfo alloc] init];
    momentInfo.responseModel = responseObject;
    if (responseModelstatus == 1) {
        NSMutableArray<NSDictionary *> *dictionarys = responseModelresult;
        
        if (dictionarys == nil || dictionarys.count == 0) {
            momentInfo.uploadState = CJUploadMomentStateFailure;
            momentInfo.uploadStatePromptText = @"点击重传";
            
        } else {
            BOOL findFailure = NO;
            for (NSDictionary *dictionary in dictionarys) {
                NSString *networkUrl = dictionary[@"url"];
                if (networkUrl == nil || [networkUrl length] == 0) {
                    NSLog(@"Failure:文件上传后返回的网络地址为空");
                    findFailure = YES;
                    
                }
            }
            
            if (findFailure) {
                momentInfo.uploadState = CJUploadMomentStateFailure;
                momentInfo.uploadStatePromptText = @"点击重传";
                
            } else {
                momentInfo.uploadState = CJUploadMomentStateSuccess;
                momentInfo.uploadStatePromptText = @"上传成功";
            }
        }
        
    } else if (responseModelstatus == 2) {
        momentInfo.uploadState = CJUploadMomentStateFailure;
        momentInfo.uploadStatePromptText = responseModelmessage;
        
    } else {
        momentInfo.uploadState = CJUploadMomentStateFailure;
        momentInfo.uploadStatePromptText = @"点击重传";
    }
    
    return momentInfo;
}
*/

@end

//
//  AFNUtil.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "AFNUtil.h"
#import "AFHTTPRequestOperation+Get.h"

@implementation AFNUtil

#pragma mark - 私有方法
+ (void)hud_showNoNetwork{
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"网络不给力", nil)];
}

#pragma mark - 公共方法
+ (AFHTTPRequestOperation *)useManager:(AFHTTPRequestOperationManager *)manager
                        postRequestUrl:(NSString *)Url
                                params:(NSDictionary *)params
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSString *failMesg))failure{
    
    BOOL isNetworkEnabled = [AFNetworkReachabilityManager sharedManager].isReachable;
    if (isNetworkEnabled == NO) {//网络不可用
        [self hud_showNoNetwork];
        return nil;
    }
        
    //网络可用
    AFHTTPRequestOperation *operation =
    [manager POST:Url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (success)
        {
            NSMutableDictionary *responseObject_dic = [operation responseObject_dic:operation];
            success(operation, responseObject_dic);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure)
        {
            NSString *failMesg = [operation failMesg:operation];
            failure(operation, failMesg);
        }
        
    }];
    return operation;
}




@end

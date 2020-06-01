//
//  TestNetworkClient.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CJNetwork/CJNetworkClient+SuccessFailure.h>

@interface TestNetworkClient : CJNetworkClient {
    
}

+ (TestNetworkClient *)sharedInstance;

#pragma mark - RealApi
- (NSURLSessionDataTask *)mycj2_postApi:(NSString *)apiSuffix
                                 params:(id)params
                           settingModel:(nullable CJRequestSettingModel *)settingModel
                                success:(void (^)(CJResponseModel *responseModel))success
                                failure:(void (^)(BOOL isRequestFailure, NSString *errorMessage))failure;

@end

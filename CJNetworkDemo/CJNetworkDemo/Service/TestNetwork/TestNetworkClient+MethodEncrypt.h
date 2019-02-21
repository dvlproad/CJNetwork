//
//  TestNetworkClient+MethodEncrypt.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TestNetworkClient.h"
#import <CJNetwork/AFHTTPSessionManager+CJMethodEncrypt.h>

@interface TestNetworkClient (MethodEncrypt)

- (NSURLSessionDataTask *)testMethodEncrypt_postApi:(NSString *)apiSuffix
                                             params:(id)params
                                       settingModel:(CJRequestSettingModel *)settingModel
                                      completeBlock:(void (^)(CJResponseModel *responseModel))completeBlock;

@end

//
//  TestNetworkClient.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJNetworkClient.h"
#import "CJNetworkClient+SuccessFailure.h"
#import "AFHTTPSessionManager+CJSerializerEncrypt.h"
#import "AFHTTPSessionManager+CJMethodEncrypt.h"
#import "CJResponseModel.h"

@interface TestNetworkClient : CJNetworkClient {
    
}
// 外界环境变化的时候要修改的值
@property (nonatomic, copy) NSString *baseUrl;  /**< 共有Url，形如@"http://xxx.xxx.xxx" */
@property (nonatomic, strong) NSDictionary *commonParams;

+ (TestNetworkClient *)sharedInstance;

@end

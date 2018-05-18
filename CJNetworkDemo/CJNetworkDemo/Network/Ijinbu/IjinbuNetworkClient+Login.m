//
//  IjinbuNetworkClient+Login.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/6.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "IjinbuNetworkClient+Login.h"
#import "NSString+MD5.h"

@implementation IjinbuNetworkClient (Login)

- (NSURLSessionDataTask *)requestijinbuLogin_name:(NSString *)name
                                             pasd:(NSString*)pasd
                                    completeBlock:(void (^)(IjinbuResponseModel *responseModel))completeBlock
{
    NSString *Url = API_BASE_Url_ijinbu(@"ijinbu/app/teacherLogin/login");
    NSDictionary *params = @{@"userAccount":name, //测试:name:18020721201 pasd:123456
                             @"userPwd":    [pasd MD5],
                             @"loginType":  @(0)
                             };
    
    return [self ijinbu_postUrl:Url params:params cache:YES completeBlock:^(IjinbuResponseModel *responseModel) {
        if (responseModel.status == 0) {
            NSLog(@"ijinbu_login_responseModel = %@", responseModel);
            
            IjinbuUser *user = [[IjinbuUser alloc] initWithHisDictionary:responseModel.result];
            IjinbuSession *session = [IjinbuSession current];
            session.user = user;
        }
        
        if (completeBlock) {
            completeBlock(responseModel);
        }
    }];
}

@end

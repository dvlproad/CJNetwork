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

@end

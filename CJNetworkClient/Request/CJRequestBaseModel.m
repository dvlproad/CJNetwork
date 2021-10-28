//
//  CJRequestBaseModel.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJRequestBaseModel.h"

@implementation CJRequestBaseModel

@synthesize requestType;

@synthesize ownBaseUrl;
@synthesize apiSuffix;
@synthesize customParams;
@synthesize requestMethod;

@synthesize requestEncrypt;

@synthesize settingModel;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ownBaseUrl     = nil;
        self.requestMethod  = CJRequestMethodPOST;
        self.requestEncrypt = CJRequestEncryptYES;
    }
    return self;
}

@end

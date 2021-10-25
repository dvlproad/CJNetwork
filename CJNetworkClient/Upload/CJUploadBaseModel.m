//
//  CJUploadBaseModel.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJUploadBaseModel.h"

@implementation CJUploadBaseModel

@synthesize ownBaseUrl;
@synthesize apiSuffix;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ownBaseUrl     = nil;
        self.requestEncrypt = CJRequestEncryptYES;
    }
    return self;
}

@end

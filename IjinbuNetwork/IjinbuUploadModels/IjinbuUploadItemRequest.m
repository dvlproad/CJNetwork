//
//  IjinbuUploadItemRequest.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/1/20.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "IjinbuUploadItemRequest.h"

@implementation IjinbuUploadItemRequest

- (instancetype)initWithHisDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.uploadItemToWhere = [dictionary[@"uploadType"] integerValue];
    }
    return self;
}

@end

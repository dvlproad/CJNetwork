//
//  AccountInfo.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 8/1/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "AccountInfo.h"

@implementation AccountInfo

- (instancetype)initWithHisDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.uid = dictionary[@"uid"];
        self.name = dictionary[@"name"];
        self.email = dictionary[@"phoneNumber"];
        self.pasd = dictionary[@"pasd"];
    }
    return self;
}

@end

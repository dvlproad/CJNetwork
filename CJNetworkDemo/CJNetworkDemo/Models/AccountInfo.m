//
//  AccountInfo.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 8/1/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "AccountInfo.h"

@implementation AccountInfo

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                      @"uid" : @"uid",
                                                      @"name" : @"name",
                                                      @"email" : @"phoneNumber",
                                                      @"pasd" : @"pasd"
                                                      }];
}

@end

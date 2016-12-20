//
//  AccountInfo.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/1/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
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

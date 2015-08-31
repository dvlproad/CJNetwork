//
//  AccountInfo.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/1/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "AccountInfo.h"

@implementation AccountInfo
//@synthesize uid;
//@synthesize name;
//@synthesize email;
//@synthesize pasd;

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                      @"uid" : @"uid",
                                                      @"name" : @"name",
                                                      @"email" : @"phoneNumber",
                                                      @"pasd" : @"pasd"
                                                      }];
}

@end

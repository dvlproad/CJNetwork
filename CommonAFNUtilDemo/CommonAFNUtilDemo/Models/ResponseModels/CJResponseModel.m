//
//  CJResponseModel.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/18.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "CJResponseModel.h"

@implementation CJResponseModel

+ (JSONKeyMapper *)keyMapper{
    NSDictionary *map = @{
                          @"status":    @"status",
                          @"message":   @"message",
                          @"result":    @"result"
                          };
    
    return [[JSONKeyMapper alloc]initWithDictionary:map];
}

@end

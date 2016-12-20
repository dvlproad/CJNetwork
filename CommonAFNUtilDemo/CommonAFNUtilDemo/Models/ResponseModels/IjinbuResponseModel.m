//
//  IjinbuResponseModel.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "IjinbuResponseModel.h"

@implementation IjinbuResponseModel

+ (JSONKeyMapper *)keyMapper{
    NSDictionary *map = @{
                          @"status":    @"status",
                          @"msg":       @"message",
                          @"result":    @"result"
                          };
    
    return [[JSONKeyMapper alloc]initWithDictionary:map];
}

@end

//
//  LoginShareInfo.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 8/1/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "LoginShareInfo.h"

static LoginShareInfo *loginShareInfo;

@implementation LoginShareInfo

+ (LoginShareInfo *)shared
{
    if (loginShareInfo == nil){
        @synchronized(self){
            loginShareInfo = [[LoginShareInfo alloc]init];
        }
    }
    return loginShareInfo;
}



@end

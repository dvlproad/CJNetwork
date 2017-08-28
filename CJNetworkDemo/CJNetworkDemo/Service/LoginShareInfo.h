//
//  LoginShareInfo.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 8/1/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountInfo.h"

@interface LoginShareInfo : NSObject{
    
}
@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *expires_in;
@property (nonatomic, strong) NSString *refresh_token;
@property (nonatomic, strong) NSString *scope;
@property (nonatomic, strong) NSString *token_type;
@property (nonatomic, strong) AccountInfo *uinfo;   //用户信息

+ (LoginShareInfo *)shared;

@end

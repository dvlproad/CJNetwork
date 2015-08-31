//
//  LoginHelper.h
//  LoginDemo
//
//  Created by lichq on 7/4/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginHelper : NSObject

+ (void)login_UID:(NSString *)uid;
+ (void)login_name:(NSString *)name pasd:(NSString *)pasd;
+ (void)logout;

+ (BOOL)isLogin;

+ (NSString *)loginUID;
+ (NSString *)loginName;
+ (NSString *)loginPasd;


@end

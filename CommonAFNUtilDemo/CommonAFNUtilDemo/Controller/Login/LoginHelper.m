//
//  LoginHelper.m
//  LoginDemo
//
//  Created by lichq on 7/4/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "LoginHelper.h"

//#define kLoginUID   @"uid"
#define kLoginName  @"name"
#define kLoginPasd  @"pasd"

#define kLogoutUID  @"0"    //没人登录的时候(即登出)，所用的用户ID
#define kLogoutName @""
#define kLogoutPasd @""

#define kTestUID    @"999"

@implementation LoginHelper


+ (void)login_name:(NSString *)name pasd:(NSString *)pasd{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:kLoginName];
    [[NSUserDefaults standardUserDefaults] setObject:pasd forKey:kLoginPasd];
}

+ (void)logout{
    [[NSUserDefaults standardUserDefaults] setObject:kLogoutName forKey:kLoginName];
    [[NSUserDefaults standardUserDefaults] setObject:kLogoutPasd forKey:kLoginPasd];
}

//是否登录
+ (BOOL)isLogin{
//    return [[self loginUID] isEqualToString:kLogoutUID] ? NO : YES;
    return [[self loginName] isEqualToString:kLogoutName] ? NO : YES;
}

+ (NSString *)loginName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLoginName];
}

+ (NSString *)loginPasd{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLoginPasd];
}

@end

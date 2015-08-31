//
//  CommonHUD.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/6/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonHUD : NSObject

+ (void)hud_dismiss;

+ (void)hud_showDoingText:(NSString *)text;
+ (void)hud_showLoading;

+ (void)hud_showErrorText:(NSString *)text;
+ (void)hud_showNoNetwork;

@end

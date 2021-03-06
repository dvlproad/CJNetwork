//
//  CurrentASIAPI.h
//  CommonASIUtilDemo
//
//  Created by lichq on 8/10/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonASIInstance.h"
#import "CurrentASIRequest.h"
#import "LoginHelper.h"
#import "LoginShareInfo.h"

@interface CurrentASIAPI : NSObject

+ (void)requestLogin_name:(NSString *)name
                     pasd:(NSString*)pasd
                 delegate:(id<WebServiceASIDelegate>)delegate
                 userInfo:(NSDictionary *)userInfo;

@end

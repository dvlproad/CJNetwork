//
//  CurrentAFNManager.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/6/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h> //使用CocoaPod的时候得用尖括号引用头文件

@interface CurrentAFNManager : NSObject

+ (AFHTTPSessionManager *)manager_health;
+ (AFHTTPSessionManager *)manager_dingdang;
+ (AFHTTPSessionManager *)manager_lookhouse;

@end

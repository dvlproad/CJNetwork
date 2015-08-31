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

+ (AFHTTPRequestOperationManager *)manager_health;
+ (AFHTTPRequestOperationManager *)manager_dingdang;
+ (AFHTTPRequestOperationManager *)manager_lookhouse;

@end

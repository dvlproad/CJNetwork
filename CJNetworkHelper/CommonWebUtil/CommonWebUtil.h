//
//  CommonWebUtil.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 8/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonWebUtil : NSObject

+ (NSString *)getUUID;      //获取UUID
+ (NSString *)getModified;  //获取修改时间
+ (NSString *)updateModified:(NSString *)modified;//修改(增删改)时候，更新修改时候的时间modified,有可能是特殊情况的在原来的modified上加1

@end

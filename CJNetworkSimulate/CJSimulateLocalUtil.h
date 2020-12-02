//
//  CJSimulateLocalUtil.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/4/8.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJSimulateLocalUtil : NSObject

#pragma mark - Local请求模拟
/*
 *  开始本地模拟接口请求
 *
 *  @param apiSuffix        api文件的本地路径(可以不带.json，也可以带)
 *  @param completeBlock    获取到数据的回调
 */
+ (void)localSimulateApi:(NSString *)apiSuffix completeBlock:(void (^)(NSDictionary *responseDictionary))completeBlock;

NS_ASSUME_NONNULL_END

@end

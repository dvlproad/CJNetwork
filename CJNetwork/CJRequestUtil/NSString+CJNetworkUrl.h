//
//  NSString+CJNetworkUrl.h
//  CJNetwork
//
//  Created by ciyouzen on 15/11/22.
//  Copyright © 2015年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CJNetworkUrl)

/// 提取 URL 中指定 key 的值
- (nullable NSString *)cjnetworkUrl_ValueForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

//
//  CQTSSandboxPathUtil.h
//  CQDemoKit
//
//  Created by lcQian on 2020/4/7.
//  Copyright © 2020 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 沙盒位置类型
typedef NS_ENUM(NSInteger, CQTSSandboxType) {
    CQTSSandboxTypeHome,
    CQTSSandboxTypeDocuments,
    CQTSSandboxTypeLibrary,
    CQTSSandboxTypeCaches,
    CQTSSandboxTypeTemporary
};


NS_ASSUME_NONNULL_BEGIN

@interface CQTSSandboxPathUtil : NSObject

/// 将相对路径补全为绝对路径
///
/// @param relativeFilePath                   要补全的相对路径
/// @param sandboxType                              在那个沙盒中补全
/// @param checkIfExist                            是否要检查存在
///
/// @return 补全后的绝对路径（补全失败则返回nil。如果要检查文件是否存在，则不存在文件时，则返回nil）
+ (nullable NSString *)makeupAbsoluteFilePath:(NSString *)relativeFilePath
                                toSandboxType:(CQTSSandboxType)sandboxType
                                 checkIfExist:(BOOL)checkIfExist;

/// 获取指定类型的沙盒目录路径
+ (NSString *)sandboxPath:(CQTSSandboxType)sandboxType;

/// 获取沙盒主目录路径
+ (NSString *)homeDirectory;

/// 获取 Documents 目录路径
+ (NSString *)documentsDirectory;

/// 获取 Library 目录路径
+ (NSString *)libraryDirectory;

/// 获取 Library/Caches 目录路径
+ (NSString *)cachesDirectory;

/// 获取 tmp 目录路径
+ (NSString *)temporaryDirectory;

@end

NS_ASSUME_NONNULL_END

//
//  CQTSSandboxPathUtil.m
//  CQDemoKit
//
//  Created by lcQian on 2020/4/7.
//  Copyright © 2020 dvlproad. All rights reserved.
//

#import "CQTSSandboxPathUtil.h"

@implementation CQTSSandboxPathUtil

/// 将相对路径补全为绝对路径
///
/// @param relativeFilePath                   要补全的相对路径
/// @param sandboxType                              在那个沙盒中补全
/// @param checkIfExist                            是否要检查存在
///
/// @return 补全后的绝对路径（补全失败则返回nil。如果要检查文件是否存在，则不存在文件时，则返回nil）
+ (nullable NSString *)makeupAbsoluteFilePath:(NSString *)relativeFilePath
                                toSandboxType:(CQTSSandboxType)sandboxType
                                 checkIfExist:(BOOL)checkIfExist
{
    NSString *sandboxPath = [CQTSSandboxPathUtil sandboxPath:sandboxType];
    NSString *absoluteFilePath = [sandboxPath stringByAppendingPathComponent:relativeFilePath];
    
    if (checkIfExist) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:absoluteFilePath]) {
            return nil;
        }
    }
    
    return absoluteFilePath;
}

/// 获取指定类型的沙盒目录路径
+ (NSString *)sandboxPath:(CQTSSandboxType)sandboxType {
    NSString *sandboxPath;
    
    switch (sandboxType) {
        case CQTSSandboxTypeHome: {
            sandboxPath = NSHomeDirectory();
            break;
        }
        case CQTSSandboxTypeDocuments: {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            sandboxPath = paths.firstObject;
            break;
        }
        case CQTSSandboxTypeLibrary: {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            sandboxPath = paths.firstObject;
            break;
        }
        case CQTSSandboxTypeCaches: {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            sandboxPath = paths.firstObject;
            break;
        }
        case CQTSSandboxTypeTemporary: {
            sandboxPath = NSTemporaryDirectory();
            break;
        }
        default:
            break;
    }
    return NSHomeDirectory();
}

+ (NSString *)homeDirectory {
    return NSHomeDirectory();
}

+ (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths.firstObject;
}

+ (NSString *)libraryDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return paths.firstObject;
}

+ (NSString *)cachesDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return paths.firstObject;
}

+ (NSString *)temporaryDirectory {
    return NSTemporaryDirectory();
}

@end

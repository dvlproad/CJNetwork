//
//  NSFileManagerCJHelper.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManagerCJHelper : NSObject

/**
 *  保存文件到以home相对的相对路径下
 *
 *  @param data                         文件数据
 *  @param fileName                     文件以什么名字保存
 *  @param relativeDirectoryPath        文件保存的相对路径
 *
 *  return 是否保存成功
 */
+ (BOOL)saveFileData:(NSData *)data
        withFileName:(NSString *)fileName
toRelativeDirectoryPath:(NSString *)relativeDirectoryPath;

/**
 *  从磁盘读取数据
 *
 *  @param fileName                 文件的名字
 *  @param relativeDirectoryPath    文件的相对路径
 *
 *  return 读取到的数据
 */
+ (NSData *)readFileDataWithFileName:(NSString *)fileName
           fromRelativeDirectoryPath:(NSString *)relativeDirectoryPath;

@end

NS_ASSUME_NONNULL_END

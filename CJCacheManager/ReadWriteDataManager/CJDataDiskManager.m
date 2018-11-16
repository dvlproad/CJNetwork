//
//  CJDataDiskManager.m
//  CommonFMDBUtilDemo
//
//  Created by ciyouzen on 6/25/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "CJDataDiskManager.h"
#import "NSFileManagerCJHelper.h"

@interface CJDataDiskManager ()

@property (nonatomic, copy) NSString *relativeDirectoryPath;

@end

@implementation CJDataDiskManager

- (instancetype)initWithRelativeDirectoryPath:(NSString *)relativeDirectoryPath {
    self = [super init];
    if (self) {
        NSAssert(relativeDirectoryPath, @"要缓存到磁盘的文件目录不能为空");
        self.relativeDirectoryPath = relativeDirectoryPath;
    }
    return self;
}

/**
 *  保存文件到以home相对的相对路径下
 *
 *  @param data                         文件数据
 *  @param fileName                     文件以什么名字保存
 *
 *  return 是否保存成功
 */
- (BOOL)saveFileData:(NSData *)data withFileName:(NSString *)fileName {
    return [NSFileManagerCJHelper saveFileData:data withFileName:fileName toRelativeDirectoryPath:self.relativeDirectoryPath];
}


/**
 *  从磁盘读取数据
 *
 *  @param fileName                 文件的名字
 *
 *  return 读取到的数据
 */
- (NSData *)readFileDataWithFileName:(NSString *)fileName {
    return [NSFileManagerCJHelper readFileDataWithFileName:fileName fromRelativeDirectoryPath:self.relativeDirectoryPath];
}


@end

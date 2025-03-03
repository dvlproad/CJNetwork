//
//  CQDownloadRecordModel.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CQDownloadRecordModel.h"
#import "NSString+Hash.h"



// 参考 CJRequestBaseModel
@implementation CQDownloadRecordModel

// 使用 @synthesize 让编译器自动生成实例变量
@synthesize url = _url;
@synthesize downloadState = _downloadState;
- (instancetype)init {
    self = [super init];
    if (self) {
        _createId = [[NSUUID UUID] UUIDString];
//        self.url     = nil;
//        self.downloadState  = CJFileDownloadStateUnknown;
    }
    return self;
}

//void updateDownloadState(CJFileDownloadState downloadState, NSError * _Nullable error) {
//    
//}
//- (void)updateDownloadState:(CJFileDownloadState)downloadState error:(NSError * _Nullable)error {
//    _downloadState = downloadState;
//    if (self.stateBlock) {
//        self.stateBlock(downloadState, error);
//    }
//}

- (NSString *)saveWithFileName {
    NSString *fileName = [NSString stringWithFormat:@"%@_%@_%@", self.url.md5String, self.createId, [self.url lastPathComponent]];
    return fileName;
}

- (NSString *)saveToAbsPath {
    NSString *fileName = self.saveWithFileName;
    return [HSCachesDirectory stringByAppendingPathComponent:fileName];
}

- (NSInteger)hasDownloadedLength {
    return [[[NSFileManager defaultManager] attributesOfItemAtPath:self.saveToAbsPath error:nil][NSFileSize] integerValue];
}

#pragma mark - NSCoding
// 归档
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.createId forKey:@"createId"];
    [coder encodeObject:self.url forKey:@"url"]; // 遵循协议的属性
    [coder encodeInteger:(NSInteger)self.downloadState forKey:@"downloadState"]; // 确保类型匹配
    [coder encodeObject:self.name forKey:@"name"]; // 自定义属性
}

// 解档
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _createId = [[coder decodeObjectForKey:@"createId"] copy];
        _url = [[coder decodeObjectForKey:@"url"] copy]; // readonly 属性，使用 _url 赋值
        _downloadState = (CJFileDownloadState)[coder decodeIntegerForKey:@"downloadState"]; // 强制转换以匹配 NS_ENUM
        _name = [[coder decodeObjectForKey:@"name"] copy]; // 确保字符串安全性
    }
    return self;
}

#pragma mark - 自定义初始化
- (instancetype)initWithURL:(NSString *)url downloadState:(CJFileDownloadState)downloadState name:(NSString *)name {
    self = [super init];
    if (self) {
        _createId = [[NSUUID UUID] UUIDString];
        _url = [url copy]; // 直接赋值实例变量
        _downloadState = downloadState;
        self.name = [name copy];
    }
    return self;
}


@end

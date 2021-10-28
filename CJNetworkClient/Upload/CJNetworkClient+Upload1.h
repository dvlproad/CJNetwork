//
//  CJNetworkClient+Upload1.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  有两个回调，分别为 success + failure

#import "CJNetworkClient.h"
#import <CQNetworkPublic/CQNetworkUploadCompletionClientProtocal.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJNetworkClient (Upload1) <CQNetworkUploadCompletionClientProtocal>

#pragma mark - Other Helper Method
//NSMutableDictionary *imageKeyDataDicts = [[NSMutableDictionary alloc] init];
//if (image) {
//    NSData *imageData = UIImageJPEGRepresentation(image, 1);
//    [imageKeyDataDicts setObject:imageData forKey:@"upfile"];
//}
+ (NSMutableArray<CJUploadFileModel *> *)uploadFileModels:(NSDictionary *)imageKeyDataDicts;

@end

NS_ASSUME_NONNULL_END

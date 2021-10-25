//
//  CJNetworkClient+CJDemoApp.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//
//  below are the cjdemo app's upload image example, other app can refer to it
//  below are the cjdemo app's upload image example, other app can refer to it
//  below are the cjdemo app's upload image example, other app can refer to it

#import "CJNetworkClient.h"
#import "CJNetworkClient+Upload1.h"
#import "CJNetworkClient+Upload2.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJNetworkClient (CJDemoApp)

//NSMutableDictionary *imageKeyDataDicts = [[NSMutableDictionary alloc] init];
//if (image) {
//    NSData *imageData = UIImageJPEGRepresentation(image, 1);
//    [imageKeyDataDicts setObject:imageData forKey:@"upfile"];
//}
- (NSMutableArray<CJUploadFileModel *> *)__uploadFileModels:(NSDictionary *)imageKeyDataDicts;

@end

NS_ASSUME_NONNULL_END

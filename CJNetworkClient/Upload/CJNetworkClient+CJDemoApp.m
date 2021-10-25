//
//  CJNetworkClient+CJDemoApp.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/6/3.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJNetworkClient+CJDemoApp.h"

@implementation CJNetworkClient (CJDemoApp)

//NSMutableDictionary *imageKeyDataDicts = [[NSMutableDictionary alloc] init];
//if (image) {
//    NSData *imageData = UIImageJPEGRepresentation(image, 1);
//    [imageKeyDataDicts setObject:imageData forKey:@"upfile"];
//}
- (NSMutableArray<CJUploadFileModel *> *)__uploadFileModels:(NSDictionary *)imageKeyDataDicts {
    NSString *imagePrefixName = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]*1000];
    
    NSMutableArray<CJUploadFileModel *> *uploadFileModels = [[NSMutableArray alloc] init];
    NSInteger imageCount = imageKeyDataDicts.allKeys.count;
    for (NSInteger i = 0; i < imageCount; i++) {
        NSString *imageSuffixName = [NSString stringWithFormat:@"_%zd.jpg", i];
        NSString *imageName = [imagePrefixName stringByAppendingString:imageSuffixName];
        
        NSString *imageKey = imageKeyDataDicts.allKeys[i];
        NSData *imageData = [imageKeyDataDicts objectForKey:imageKey];
        
        CJUploadFileModel *imageUploadModel = [[CJUploadFileModel alloc] initWithItemType:CJUploadItemTypeImage itemName:imageName itemData:imageData itemKey:imageKey];
        [uploadFileModels addObject:imageUploadModel];
    }
    
    return uploadFileModels;
}

@end

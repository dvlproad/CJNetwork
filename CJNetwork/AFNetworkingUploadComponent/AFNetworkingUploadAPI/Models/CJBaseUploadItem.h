//
//  CJBaseUploadItem.h
//  FileChooseViewDemo
//
//  Created by ciyouzen on 2016/06/07.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

#import "CJUploadFileModel.h"
#import "CJUploadMomentInfo.h"

/**
 *  包含有以下三种消息的上传模型
 *  ①上传的上传模型组、
 *  ②上传时候生成的请求、
 *  ③整个上传过程中(上传中、上传成功、上传失败)各时刻的信息(进度以及上传结果)
 */
@interface CJBaseUploadItem : NSObject

@property (nonatomic, assign) BOOL isNetworkItem;   /**< (新增)是否是网络文件，如果是则不用进行上传 */

//必填参数
@property (nonatomic, strong) NSMutableArray<CJUploadFileModel *> *uploadFileModels;

@property (nonatomic, strong) NSURLSessionDataTask *operation;

@property (nonatomic, strong) CJUploadMomentInfo *momentInfo; /**< 整个上传过程中(上传中、上传成功、上传失败)各时刻的信息(进度以及上传结果) */

@end

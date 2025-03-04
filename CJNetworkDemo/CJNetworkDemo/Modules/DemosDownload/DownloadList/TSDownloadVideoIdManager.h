//
//  TSDownloadVideoIdManager.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/19.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CQDemoKit/CQDMSectionDataModel.h>
#import "CQDownloadRecordModel.h"

/**
 *  存储网络状态的类
 */
@interface TSDownloadVideoIdManager : NSObject {
    
}
@property (nonatomic, strong) NSArray<CQDMSectionDataModel *> *sectionDataModels;    /**< 每个section的数据 */


+ (TSDownloadVideoIdManager *)sharedInstance;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Event
- (NSArray<CQDownloadRecordModel *> *)getRecordsForVideoId:(NSString *)videoId;
- (void)addDownloadRecoredModels:(NSArray<CQDownloadRecordModel *> *)dataModels;

#pragma mark - 增删
- (void)deleteAllFiles;
- (void)deleteFileAtIndexPath:(NSIndexPath *)indexPath;


@end

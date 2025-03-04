//
//  TSDownloadVideoIdManager.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/19.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TSDownloadVideoIdManager.h"
#import <CQVideoUrlAnalyze_Swift/CQVideoUrlAnalyze_Swift-Swift.h>
#import "HSDownloadManager.h"

@interface TSDownloadVideoIdManager ()

@end


@implementation TSDownloadVideoIdManager

+ (TSDownloadVideoIdManager *)sharedInstance {
    static TSDownloadVideoIdManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self getSectionDataModelsFromUserDefault];
    }
    return self;
}

#pragma mark - Event
- (NSArray<CQDownloadRecordModel *> *)getRecordsForVideoId:(NSString *)videoId {
//    [self addVideoByVideoId:@"7465611957203160340"];
//    NSString *cover = [CQVideoUrlAnalyze_Tiktok getVideoInfoFor:CQAnalyzeVideoUrlTypeImageCover videoId:videoId];
    
    NSString *videoOriginal = [CQVideoUrlAnalyze_Tiktok getVideoInfoFor:CQAnalyzeVideoUrlTypeVideoOriginal videoId:videoId];
    NSString *videoWithoutWatermark = [CQVideoUrlAnalyze_Tiktok getVideoInfoFor:CQAnalyzeVideoUrlTypeVideoWithoutWatermark videoId:videoId];
    NSString *videoWithoutWatermarkHD = [CQVideoUrlAnalyze_Tiktok getVideoInfoFor:CQAnalyzeVideoUrlTypeVideoWithoutWatermarkHD videoId:videoId];
    
    
    NSMutableArray<CQDownloadRecordModel *> *dataModels = [[NSMutableArray alloc] init];
    /*
    {
        CQDownloadRecordModel *dataModel = [[CQDownloadRecordModel alloc] init];
        dataModel.name = [NSString stringWithFormat:@"videoOriginal %@", videoId];
        dataModel.imageName = videoOriginal;
        [dataModels addObject:dataModel];
    }
    {
        CQDownloadRecordModel *dataModel = [[CQDownloadRecordModel alloc] init];
        dataModel.name = [NSString stringWithFormat:@"videoWithoutWatermark %@", videoId];
        dataModel.imageName = videoWithoutWatermark;
        [dataModels addObject:dataModel];
    }
    */
    
        CQDownloadRecordModel *dataModel = [[CQDownloadRecordModel alloc] init];
        dataModel.name = [NSString stringWithFormat:@"videoWithoutWatermarkHD %@", videoId];
        dataModel.url = videoWithoutWatermarkHD;
        [dataModels addObject:dataModel];

        return dataModels;
 }


 - (void)addDownloadRecoredModels:(NSArray<CQDownloadRecordModel *> *)dataModels {
//    [self.sectionDataModels.firstObject.values addObjectsFromArray:dataModels];
    NSMutableArray *values = self.sectionDataModels.firstObject.values;
    for (CQDownloadRecordModel *dataModel in dataModels) {
        [values insertObject:dataModel atIndex:0];
    }
    
    // 保存 sectionDataModels 到 UserDefault
    [self saveSectionDataModelsToUserDefault];
}

- (void)saveSectionDataModelsToUserDefault {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.sectionDataModels];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"sectionDataModels_downloadVideoId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getSectionDataModelsFromUserDefault {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"sectionDataModels_downloadVideoId"];
    if (data == nil) {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = [NSString stringWithFormat:@"section %d", 0];
        sectionDataModel.values = [[NSMutableArray alloc] init];
        self.sectionDataModels = @[sectionDataModel];
    } else {
        self.sectionDataModels = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

#pragma mark - 增删
- (void)deleteAllFiles {
    [self.sectionDataModels.firstObject.values removeAllObjects];
    [[HSDownloadManager sharedInstance] deleteAllFile];
    
    [self saveSectionDataModelsToUserDefault];
}

- (void)deleteFileAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *dataModels = self.sectionDataModels.firstObject.values;
    
    
    CQDownloadRecordModel *downloadModel = [dataModels objectAtIndex:indexPath.item];
    //TODO: qian
    [[HSDownloadManager sharedInstance] deleteFile:downloadModel]; // 视频本身不删除，万一下次也是下载这个呢？而且外部可能重复下载
    [dataModels removeObjectAtIndex:indexPath.item];
    /*
    NSMutableArray *shouldRemoveDataModels = [[NSMutableArray alloc] init];
    for (CQDownloadRecordModel *model in dataModels) {
        NSString *iDownloadUrl = model.url;
        if ([iDownloadUrl isEqualToString:downloadUrl]) {
            [shouldRemoveDataModels addObject:model];
        }
    }
    [dataModels removeObjectsInArray:shouldRemoveDataModels];
    */
    
    [self saveSectionDataModelsToUserDefault];
}



@end

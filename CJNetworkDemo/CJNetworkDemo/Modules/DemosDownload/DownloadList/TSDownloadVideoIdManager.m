//
//  TSDownloadVideoIdManager.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2016/12/19.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TSDownloadVideoIdManager.h"
#import <CQVideoUrlAnalyze_Swift/CQVideoUrlAnalyze_Swift-Swift.h>

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
- (void)addVideoByVideoId:(NSString *)videoId {
//    [self addVideoByVideoId:@"7465611957203160340"];
//    NSString *cover = [CQVideoUrlAnalyze_Tiktok getVideoInfoFor:CQAnalyzeVideoUrlTypeImageCover videoId:videoId];
    
    NSString *videoOriginal = [CQVideoUrlAnalyze_Tiktok getVideoInfoFor:CQAnalyzeVideoUrlTypeVideoOriginal videoId:videoId];
    NSString *videoWithoutWatermark = [CQVideoUrlAnalyze_Tiktok getVideoInfoFor:CQAnalyzeVideoUrlTypeVideoWithoutWatermark videoId:videoId];
    NSString *videoWithoutWatermarkHD = [CQVideoUrlAnalyze_Tiktok getVideoInfoFor:CQAnalyzeVideoUrlTypeVideoWithoutWatermarkHD videoId:videoId];
    
    
    NSMutableArray<CQTSLocImageDataModel *> *dataModels = [[NSMutableArray alloc] init];
    /*
    {
        CQTSLocImageDataModel *dataModel = [[CQTSLocImageDataModel alloc] init];
        dataModel.name = [NSString stringWithFormat:@"videoOriginal %@", videoId];
        dataModel.imageName = videoOriginal;
        [dataModels addObject:dataModel];
    }
    {
        CQTSLocImageDataModel *dataModel = [[CQTSLocImageDataModel alloc] init];
        dataModel.name = [NSString stringWithFormat:@"videoWithoutWatermark %@", videoId];
        dataModel.imageName = videoWithoutWatermark;
        [dataModels addObject:dataModel];
    }
    */
    {
        CQTSLocImageDataModel *dataModel = [[CQTSLocImageDataModel alloc] init];
        dataModel.name = [NSString stringWithFormat:@"videoWithoutWatermarkHD %@", videoId];
        dataModel.imageName = videoWithoutWatermarkHD;
        [dataModels addObject:dataModel];
    }
    
//    [self.sectionDataModels.firstObject.values addObjectsFromArray:dataModels];
    NSMutableArray *values = self.sectionDataModels.firstObject.values;
    for (CQTSLocImageDataModel *dataModel in dataModels) {
        [values insertObject:dataModel atIndex:0];
    }
    
    // 保存 sectionDataModels 到 UserDefault
    [self saveSectionDataModelsToUserDefault];
}

- (void)saveSectionDataModelsToUserDefault {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.sectionDataModels];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"sectionDataModels_downloadVideoId"];
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
- (void)deleteAll {
    [self.sectionDataModels.firstObject.values removeAllObjects];
    
    [self saveSectionDataModelsToUserDefault];
}


@end

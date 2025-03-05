//
//  HSNSURLSession.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "HSSessionModel.h"

@implementation HSSessionModel
//void updateDownloadState(CJFileDownloadState downloadState, NSError * _Nullable error) {
//    
//}
- (void)updateDownloadState:(CJFileDownloadState)downloadState error:(NSError * _Nullable)error {
    _downloadState = downloadState;
//    _url.downloadState = downloadState;
    
    if (self.stateBlock) {
        self.stateBlock(downloadState, error);
    }
}

@end

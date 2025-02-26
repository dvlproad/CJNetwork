//
//  TSDownloadCollectionViewCell.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CJPlayer/CJAVPlayerView.h>
#import "TSDownloadCollectionViewCellOverlay.h"

@interface TSDownloadCollectionViewCell : UICollectionViewCell {
    
}
@property (nonatomic, strong) UIImageView *previewImageView;        /** 预览图 */
@property(nonatomic, strong) CJAVPlayerView *playerView;            /** 播放器 */
@property (nonatomic, strong) TSDownloadCollectionViewCellOverlay *downloadView;     /** 下载文件的视图 */

@end

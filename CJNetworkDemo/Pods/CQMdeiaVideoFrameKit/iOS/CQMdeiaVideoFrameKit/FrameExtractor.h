//
//  CJFrameUtil.h
//  CQMdeiaVideoFrameKit
//
//  Created by qian on 2024/12/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrameExtractor : NSObject

// 从长图中按指定尺寸提取各帧
- (NSArray<UIImage *> *)extractFramesFromImage:(UIImage *)image frameSize:(CGSize)frameSize;

// 从视频中提取帧
- (NSArray<UIImage *> *)extractFramesFromVideo:(NSURL *)videoURL interval:(CGFloat)interval;

@end

NS_ASSUME_NONNULL_END

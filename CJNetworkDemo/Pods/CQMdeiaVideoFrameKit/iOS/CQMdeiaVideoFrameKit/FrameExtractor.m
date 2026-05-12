//
//  CJFrameUtil.m
//  CQMdeiaVideoFrameKit
//
//  Created by qian on 2024/12/24.
//

#import "FrameExtractor.h"

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@implementation FrameExtractor

- (NSArray<UIImage *> *)extractFramesFromImage:(UIImage *)image frameSize:(CGSize)frameSize {
    NSMutableArray<UIImage *> *frames = [NSMutableArray array];
    CGImageRef cgImage = image.CGImage;
    CGFloat imageWidth = CGImageGetWidth(cgImage);
    CGFloat imageHeight = CGImageGetHeight(cgImage);

    // 按行列遍历裁剪图片
    for (CGFloat y = 0; y + frameSize.height <= imageHeight; y += frameSize.height) {
        for (CGFloat x = 0; x + frameSize.width <= imageWidth; x += frameSize.width) {
            CGRect cropRect = CGRectMake(x, y, frameSize.width, frameSize.height);
            CGImageRef croppedCGImage = CGImageCreateWithImageInRect(cgImage, cropRect);
            UIImage *croppedImage = [UIImage imageWithCGImage:croppedCGImage];
            [frames addObject:croppedImage];
            CGImageRelease(croppedCGImage);
        }
    }

    return frames;
}

- (NSArray<UIImage *> *)extractFramesFromVideo:(NSURL *)videoURL interval:(CGFloat)interval {
    NSMutableArray<UIImage *> *frames = [NSMutableArray array];
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;

    CMTime duration = asset.duration;
    CGFloat totalDuration = CMTimeGetSeconds(duration);

    // 从视频开始按间隔提取每帧
    for (CGFloat time = 0; time < totalDuration; time += interval) {
        CMTime cmTime = CMTimeMakeWithSeconds(time, 600); // 使用 600 为单位时间
        NSError *error = nil;
        CGImageRef cgImage = [imageGenerator copyCGImageAtTime:cmTime actualTime:nil error:&error];
        
        if (error) {
            NSLog(@"Error extracting frame: %@", error.localizedDescription);
        } else {
            UIImage *image = [UIImage imageWithCGImage:cgImage];
//            [frames addObject:image];
            CGImageRelease(cgImage);
            
            // 裁剪图片
//            CGRect cropRect = CGRectMake(0, 0, image.size.width, image.size.height);
            CGRect cropRect = CGRectMake(image.size.width/2, image.size.height/2, image.size.width/2, image.size.height/2);
            UIImage *croppedImage = [self cropImage:image toRect:cropRect];
            [frames addObject:croppedImage];
        }
    }

    return frames;
}


- (UIImage *)cropImage:(UIImage *)image toRect:(CGRect)rect {
    // 根据给定的 CGRect 裁剪图片
    CGImageRef croppedCGImage = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:croppedCGImage];
    CGImageRelease(croppedCGImage);
    return croppedImage;
}

@end

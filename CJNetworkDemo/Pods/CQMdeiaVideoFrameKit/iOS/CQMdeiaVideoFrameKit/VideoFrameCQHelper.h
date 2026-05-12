//
//  VideoFrameCQHelper.h
//  TSMdeiaVideoFrameDemo
//
//  Created by qian on 2022/9/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoFrameCQHelper : NSObject

// Get the video's center frame as video poster image
+ (UIImage *)frameImageFromVideoURL:(NSURL *)videoURL;

// 异步获取帧图片，可以一次获取多帧图片
+ (void)centerFrameImageWithVideoURL:(NSURL *)videoURL completion:(void (^)(UIImage *image))completion;

@end

NS_ASSUME_NONNULL_END

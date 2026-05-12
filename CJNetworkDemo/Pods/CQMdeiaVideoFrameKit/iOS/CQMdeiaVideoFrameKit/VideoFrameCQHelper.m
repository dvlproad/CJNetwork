//
//  VideoFrameCQHelper.m
//  TSMdeiaVideoFrameDemo
//
//  Created by qian on 2022/9/21.
//

#import "VideoFrameCQHelper.h"

#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>
//#import <SDWebImage/SDImageCache.h>


@implementation VideoFrameCQHelper

//+ (void)getVideoPreViewImageURL:(NSString *)videoURL forImageView:(BaseImageView *)imageView placeHolderImage:(UIImage *)placeHolder
//{
//    [[SDImageCache sharedImageCache] queryCacheOperationForKey:videoURL done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
//        是否有缓存图片
//        if(image){
//            imageView.image = image;
//        }else{
//            //获取视频第一帧
//            [self getVideoFirstViewImage:videoURL forImageView:imageView placeHolderImage:placeHolder];
//        }
//    }];
//}

// 获取视频第一帧
+ (void)getVideoFrameByUrl:(NSString *)videoUrl {
    NSString *url = [NSString stringWithFormat:@"%@?flag=2", videoUrl];
    __block UIImage *videoImage;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:url] options:nil];
        NSParameterAssert(asset);
        AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetImageGenerator.appliesPreferredTrackTransform = YES;
        assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
        CGImageRef thumbnailImageRef = NULL;
        NSError *thumbnailImageGenerationError = nil;
        thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(0, 60)actualTime:NULL error:&thumbnailImageGenerationError];
        if(!thumbnailImageRef)
            NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
        videoImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage:thumbnailImageRef]: nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //主线程更新UI
//            if(videoImage){
//                imageView.image = videoImage;
//                //缓存图片
//                [[SDImageCache sharedImageCache] storeImage:videoImage forKey:videoURL toDisk:NO completion:^{
//
//                }];
//
//            }else{
//                //如果不是视频就设置图片
//                [imageView setImageUrl:videoURL placeholderImage:placeHolder];
//            }
        });
        
    });
    
}


// Get the video's center frame as video poster image
+ (UIImage *)frameImageFromVideoURL:(NSURL *)videoURL {
  // result
  UIImage *image = nil;
  
  // AVAssetImageGenerator
  AVAsset *asset = [AVAsset assetWithURL:videoURL];
  AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
  imageGenerator.appliesPreferredTrackTransform = YES;
  
  // calculate the midpoint time of video
  Float64 duration = CMTimeGetSeconds([asset duration]);
  // 取某个帧的时间，参数一表示哪个时间（秒），参数二表示每秒多少帧
  // 通常来说，600是一个常用的公共参数，苹果有说明:
  // 24 frames per second (fps) for film, 30 fps for NTSC (used for TV in North America and
  // Japan), and 25 fps for PAL (used for TV in Europe).
  // Using a timescale of 600, you can exactly represent any number of frames in these systems
  CMTime midpoint = CMTimeMakeWithSeconds(duration / 2.0, 600);
  
  // get the image from
  NSError *error = nil;
  CMTime actualTime;
  // Returns a CFRetained CGImageRef for an asset at or near the specified time.
  // So we should mannully release it
  CGImageRef centerFrameImage = [imageGenerator copyCGImageAtTime:midpoint
                                                       actualTime:&actualTime
                                                            error:&error];
  
  if (centerFrameImage != NULL) {
    image = [[UIImage alloc] initWithCGImage:centerFrameImage];
    // Release the CFRetained image
    CGImageRelease(centerFrameImage);
  }
  
  return image;
}

// 异步获取帧图片，可以一次获取多帧图片
+ (void)centerFrameImageWithVideoURL:(NSURL *)videoURL completion:(void (^)(UIImage *image))completion {
  // AVAssetImageGenerator
  AVAsset *asset = [AVAsset assetWithURL:videoURL];
  AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
  imageGenerator.appliesPreferredTrackTransform = YES;
  
  // calculate the midpoint time of video
  Float64 duration = CMTimeGetSeconds([asset duration]);
  // 取某个帧的时间，参数一表示哪个时间（秒），参数二表示每秒多少帧
  // 通常来说，600是一个常用的公共参数，苹果有说明:
  // 24 frames per second (fps) for film, 30 fps for NTSC (used for TV in North America and
  // Japan), and 25 fps for PAL (used for TV in Europe).
  // Using a timescale of 600, you can exactly represent any number of frames in these systems
  CMTime midpoint = CMTimeMakeWithSeconds(duration / 2.0, 600);
  
  // 异步获取多帧图片
  NSValue *midTime = [NSValue valueWithCMTime:midpoint];
  [imageGenerator generateCGImagesAsynchronouslyForTimes:@[midTime] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
    if (result == AVAssetImageGeneratorSucceeded && image != NULL) {
      UIImage *centerFrameImage = [[UIImage alloc] initWithCGImage:image];
      dispatch_async(dispatch_get_main_queue(), ^{
        if (completion) {
          completion(centerFrameImage);
        }
      });
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        if (completion) {
          completion(nil);
        }
      });
    }
  }];
}

@end

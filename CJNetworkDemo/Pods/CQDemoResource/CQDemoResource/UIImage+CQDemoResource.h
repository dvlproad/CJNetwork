//
//  UIImage+CQDemoResource.h
//  CQDemoResource
//
//  Created by ciyouzen on 2017/2/25.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 资源 Bundle 枚举，对应 podspec 中各 subspec 的 resource_bundle 名称
typedef NS_ENUM(NSInteger, CQDemoResourceBundleType) {
    CQDemoResourceBundleTypeImages = 0,   // CQDemoResource
    CQDemoResourceBundleTypeImagesBig,    // CQDemoResource_Images_Big
    CQDemoResourceBundleTypeGIF,          // CQDemoResource_GIF
    CQDemoResourceBundleTypeSVG,          // CQDemoResource_SVG
    CQDemoResourceBundleTypeVideos,       // CQDemoResource_Videos
    CQDemoResourceBundleTypeZip,          // CQDemoResource_Zip
    CQDemoResourceBundleTypeIcon,         // CQDemoResource_icon
    CQDemoResourceBundleTypePlist,        // CQDemoResource_plist
};

@interface UIImage (CQDemoResource)

//+ (nullable UIImage *)cqdemokit_imageNamed:(NSString *)name __attribute((deprecated("已废弃，请使用doraemon_xcassetImageNamed")));

#pragma mark - CQDemoResource
// cqresource_imageNamed        只能取 CQDemoResource 这个 bundle 里的图片(placeholder/jpg/png/bmp/webp/heic/xcassets)
+ (nullable UIImage *)cqresource_imageNamed:(NSString *)name;

// 不进行缓存，仅限获取 非xcasset内 的图片
+ (nullable UIImage *)cqresource_noCache_imageNamed:(NSString *)name;

#pragma mark - CQDemoResource_Images_Big
+ (nullable UIImage *)cqresource_imageBigNamed:(NSString *)name;

@end



@interface NSBundle (CQDemoResource)

/// 根据枚举值获取对应的 resource bundle
///
/// @param  bundleType      用来处理这个 pod 里有多个 bundle 需要获取的情况
///
///@return resourceBundle
+ (nullable NSBundle *)cqresource_resourceBundle:(CQDemoResourceBundleType)bundleType;

@end

NS_ASSUME_NONNULL_END

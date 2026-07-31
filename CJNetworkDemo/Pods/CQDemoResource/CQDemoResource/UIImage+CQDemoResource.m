//
//  UIImage+CQDemoResource.m
//  CQDemoResource
//
//  Created by ciyouzen on 2017/2/25.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "UIImage+CQDemoResource.h"
#import <CQDemoKit/UIImage+CQTSInFramework.h>

@implementation UIImage (CQDemoResource)
/*
+ (nullable UIImage *)cqdemokit_imageNamed:(NSString *)name {
    NSString *imageName = [NSString stringWithFormat:@"CQDemoKit.bundle/%@", name];
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}
*/

#pragma mark - CQDemoResource
// cqresource_imageNamed        只能取 CQDemoResource 这个 bundle 里的图片(placeholder/jpg/png/bmp/webp/heic/xcassets)
+ (nullable UIImage *)cqresource_imageNamed:(NSString *)name {
    // bundle 获取
    /*
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"CQTSAssetSourceUtil")];
    if (bundle == nil) {
        return nil;
    }
    NSURL *url = [bundle URLForResource:@"CQDemoResource" withExtension:@"bundle"];
    if (url == nil) {
        return nil;
    }
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    */
    NSBundle *imageBundle = [NSBundle cqresource_resourceBundle:CQDemoResourceBundleTypeImages];
    
    UIImage *image = [UIImage imageNamed:name inBundle:imageBundle compatibleWithTraitCollection:nil];
    return image;
}

// 不进行缓存，仅限获取 非xcasset内 的图片
+ (nullable UIImage *)cqresource_noCache_imageNamed:(NSString *)name {
    NSBundle *imageBundle = [NSBundle cqresource_resourceBundle:CQDemoResourceBundleTypeImages];
    
    // 来源于 CQDemoKit 的 UIImage *image = [self cqts_noCache_imageNamed:name inBundle:imageBundle];
    NSString *fileExtension = [name pathExtension];
    NSString *fileNameWithoutExtension = [[name lastPathComponent] stringByDeletingPathExtension];
    NSString *imagePath = [imageBundle pathForResource:fileNameWithoutExtension ofType:fileExtension];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    return image;
}

#pragma mark - CQDemoResource_Images_Big
+ (nullable UIImage *)cqresource_imageBigNamed:(NSString *)name {
    NSBundle *imageBundle = [NSBundle cqresource_resourceBundle:CQDemoResourceBundleTypeImagesBig];
    UIImage *image = [UIImage imageNamed:name inBundle:imageBundle compatibleWithTraitCollection:nil];
    return image;
}

@end



@implementation NSBundle (CQDemoResource)

/// 根据枚举值获取对应的 resource bundle
///
/// @param  bundleType      用来处理这个 pod 里有多个 bundle 需要获取的情况
///
///@return resourceBundle
+ (nullable NSBundle *)cqresource_resourceBundle:(CQDemoResourceBundleType)bundleType {
    NSString *bundleName = nil;
    switch (bundleType) {
        case CQDemoResourceBundleTypeImages:
            bundleName = @"CQDemoResource";
            break;
        case CQDemoResourceBundleTypeImagesBig:
            bundleName = @"CQDemoResource_Images_Big";
            break;
        case CQDemoResourceBundleTypeIcon:
            bundleName = @"CQDemoResource_icon";
            break;
        case CQDemoResourceBundleTypeGIF:
            bundleName = @"CQDemoResource_GIF";
            break;
        case CQDemoResourceBundleTypeSVG:
            bundleName = @"CQDemoResource_SVG";
            break;
        case CQDemoResourceBundleTypeVideos:
            bundleName = @"CQDemoResource_Videos";
            break;
        case CQDemoResourceBundleTypeZip:
            bundleName = @"CQDemoResource_Zip";
            break;
        case CQDemoResourceBundleTypePlist:
            bundleName = @"CQDemoResource_plist";
            break;
    }
    return [NSBundle cqts_framework_resourceBundle:bundleName ocClassName:@"CQTSAssetSourceUtil"];
}

@end

//
//  CQTSAssetSourceUtil.m
//  CQDemoResource
//
//  Created by ciyouzen on 2020/4/7.
//  Copyright © 2020 dvlproad. All rights reserved.
//

#import "CQTSAssetSourceUtil.h"
#import <CQDemoKit/CQTSGitUtil.h>   // 在 subspec:Demo_Resource 下

@implementation CQTSAssetSourceUtil

#pragma mark 本地资源文件名
/// 本地资源图片数组
+ (NSArray<NSString *> *)localFileNames:(NSArray<NSString *> *)folderNames {
    NSArray *resultDictionarys = [CQTSAssetSourceUtil assetDictsWithFolderNames:folderNames];
    
    // 创建可变数组存放结果
    NSMutableArray<NSString *> *resultImagesNames = [NSMutableArray array];
    for (NSDictionary *resultDictionary in resultDictionarys) {
        NSString *imageName = resultDictionary[@"assetName"];
        if (imageName && imageName.length > 0) {
            [resultImagesNames addObject:imageName];
        }
    }
    return resultImagesNames;
}


/*
 *  获取指定文件夹下的所有图片
 *
 *  @param folderNames  图片源的位置(NSArray<NSString *> *folderNames = @[@"png", @"jpg", @"webp", @"svg"];)
 *
 *  @return 本地图片数组
 */
+ (NSArray<UIImage *> *)localImagesInFolderNames:(NSArray<NSString *> *)folderNames {
    NSMutableArray<UIImage *> *images = [[NSMutableArray alloc] init];
    
    NSArray<NSString *> *imageNames = [CQTSAssetSourceUtil localFileNames:folderNames];
    NSInteger imageCount = [imageNames count];
    for (int i = 0; i < imageCount; i++) {
        NSString *imageName = [imageNames objectAtIndex:i];
        UIImage *image = [UIImage cqresource_imageNamed:imageName];
        if (image == nil) {
            image = [[UIImage alloc] init];
        }
        [images addObject:image];
    }
    
    return images;
}


/*
NSInteger trySelIndex = random();
NSArray<NSString *> *folderNames = @[@"png", @"jpg", @"webp", @"svg"];
UIImage *localImageRandom = [CQTSAssetSourceUtil localImageAtIndex:trySelIndex folderNames:folderNames];
*/
/*
 *  获取指定位置的本地图片(为了cell显示的图片不会一直变化)
 *
 *  @param trySelIndex  指定位置(随机位置 NSInteger trySelIndex = random();)
 *  @param folderNames  图片源的位置(NSArray<NSString *> *folderNames = @[@"png", @"jpg", @"webp", @"svg"];)
 *
 *  @return 本地图片
 */
+ (UIImage *)localImageAtIndex:(NSInteger)trySelIndex folderNames:(NSArray<NSString *> *)folderNames {
    NSArray<NSString *> *imageNames = [CQTSAssetSourceUtil localFileNames:folderNames];
    NSInteger selIndex = trySelIndex % imageNames.count;    //位置太大的时候，从头循环使用图片
    NSString *imageName = [imageNames objectAtIndex:selIndex];
    
    UIImage *image = [UIImage cqresource_imageNamed:imageName];
    if (image == nil) {
        NSLog(@"[%@]:CQDemoResource 加载本地图片失败 image == nil", imageName);
    }
    return image;
}









#pragma mark 网络资源文件Url
/// 我自己 github 上的 资源图片
+ (NSArray<NSString *> *)networkFileUrls:(NSArray<NSString *> *)folderNames {
    NSString *githubUrl = @"https://github.com/dvlproad/001-UIKit-CQDemo-iOS/blob/master/CQDemoResource/Resources";
    
    NSArray *resultDictionarys = [CQTSAssetSourceUtil assetDictsWithFolderNames:folderNames];
    
    // 创建可变数组存放结果
    NSMutableArray<NSString *> *imageUrls = [NSMutableArray array];
    for (NSDictionary *resultDictionary in resultDictionarys) {
        NSString *folderName = resultDictionary[@"folderName"];
        NSString *imageName = resultDictionary[@"assetName"];
        NSString *fullUrl = [CQTSGitUtil githubAssetUrlFromBaseUrl:githubUrl
                                                        folderName:folderName
                                                         imageName:imageName];
        [imageUrls addObject:fullUrl];
    }
    
    [imageUrls addObjectsFromArray:@[
        #pragma mark 以下网络图片从 https://stock.tuchong.com 中获取
        @"https://cdn6-banquan.ituchong.com/weili/l/1113166746308968471.jpeg",
        @"https://cdn6-banquan.ituchong.com/weili/l/966827220441759777.jpeg",
        @"https://cdn6-banquan.ituchong.com/weili/l/919795258271596547.jpeg",
        @"https://cdn6-banquan.ituchong.com/weili/l/57461353849430061.jpeg",
        
        #pragma mark 以下网络图片从 https://www.droitstock.com/ 中获取
        
        #pragma mark 以下网络图片从 https://www.veer.com 中获取
    ]];
    
    return imageUrls;
}

/*
NSInteger trySelIndex = random();
NSArray<NSString *> *folderNames = @[@"png", @"jpg", @"webp", @"svg"];
UIImage *imageUrlRandom = [CQTSAssetSourceUtil imageUrlAtIndex:trySelIndex folderNames:folderNames];
*/
/*
 *  获取指定位置的网络图片(为了cell显示的图片不会一直变化)
 *
 *  @param trySelIndex  指定位置(随机位置 NSInteger trySelIndex = random();)
 *  @param folderNames  图片源的位置(NSArray<NSString *> *folderNames = @[@"png", @"jpg", @"webp", @"svg"];)
 *
 *  @return 网络图片
 */
+ (NSString *)imageUrlAtIndex:(NSInteger)trySelIndex folderNames:(NSArray<NSString *> *)folderNames {
    NSArray<NSString *> *imageUrls = [self networkFileUrls:folderNames];
    NSInteger selIndex = trySelIndex % imageUrls.count;    //位置太大的时候，从头循环使用图片
    NSString *imageUrl = [imageUrls objectAtIndex:selIndex];
    
    return imageUrl;
}

+ (NSArray<NSDictionary *> *)assetDictsWithFolderNames:(NSArray<NSString *> *)folderNames {
    NSMutableArray *resultDictionarys = [[NSMutableArray alloc] init];
    
    if ([folderNames containsObject:@"placeholder"]) {
        NSArray *sourceImageNames = @[
            @"cqts_placeholder_jpg_01.jpeg",
            @"cqts_placeholder_jpg_02.jpeg",
            @"cqts_placeholder_png_01.png",
        ];
        for (NSString *sourceImageName in sourceImageNames) {
            NSDictionary *dict = @{
                @"folderName": @"placeholder",
                @"assetName": sourceImageName
            };
            [resultDictionarys addObject:dict];
        }
    }
    
    if ([folderNames containsObject:@"icon"]) {
        NSArray *sourceImageNames = @[
            @"cqts_arrowDown_dark.png",
            
            @"cqts_backBarButtonItem_blue.png",
            @"cqts_backBarButtonItem_gray.png",
            
            @"cqts_icon_check_blue01_yes.png",
            @"cqts_icon_check_blue02_no.png",
            @"cqts_icon_check_blue02_yes.png",
            @"cqts_icon_check_white01_yes.png",
            
            @"cqts_icon_knock.png",
            @"cqts_icon_nodata_01.png",
            
            // arrow
            @"cqts_arrow_back_red.png",
            @"cqts_arrow_go_blue_L.png",
            @"cqts_arrow_go_blue_R.png",
            @"cqts_arrow_go_white_L.png",
            @"cqts_arrow_go_white_R.png",
            @"cqts_arrow_tip_red.png",
            @"cqts_arrowUD_red_down.png",
            @"cqts_arrowUD_red_up.png",
        ];
        for (NSString *sourceImageName in sourceImageNames) {
            NSDictionary *dict = @{
                @"folderName": @"icon",
                @"assetName": sourceImageName
            };
            [resultDictionarys addObject:dict];
        }
    }
    
    if ([folderNames containsObject:@"jpg"]) {
        NSArray *sourceImageNames = @[
            @"cqts_jpg_bg_01.jpg",
            @"cqts_jpg_bg_02.jpg",
            @"cqts_jpg_bg_03.jpg",
            @"cqts_jpg_bg_04.jpg",
            @"cqts_jpg_bg_05.jpg",
            
            @"cqts_jpg_01.jpg",
            @"cqts_jpg_02.jpg",
            @"cqts_jpg_03.jpg",
            @"cqts_jpg_04.jpg",
            
            @"cqts_jpg_avatar_01.jpg",
            @"cqts_jpg_avatar_02.jpg",
            @"cqts_jpg_avatar_03.jpg",
            @"cqts_jpg_avatar_04.jpg",
            @"cqts_jpg_avatar_05.jpg",
            @"cqts_jpg_avatar_06.jpg",
            @"cqts_jpg_avatar_07.jpg",
            @"cqts_jpg_avatar_08.jpg",
            
            @"cqts_jpg_long_horizontal_1.jpg",
            @"cqts_jpg_long_vertical_1.jpg",
        ];
        for (NSString *sourceImageName in sourceImageNames) {
            NSDictionary *dict = @{
                @"folderName": @"jpg",
                @"assetName": sourceImageName
            };
            [resultDictionarys addObject:dict];
        }
    }
    
    if ([folderNames containsObject:@"jpg_big"]) {
        NSArray *sourceImageNames = @[
            @"cqts_big_15M.jpg",
            @"cqts_big_22M.jpg",
        ];
        for (NSString *sourceImageName in sourceImageNames) {
            NSDictionary *dict = @{
                @"folderName": @"jpg_big",
                @"assetName": sourceImageName
            };
            [resultDictionarys addObject:dict];
        }
    }
    
    if ([folderNames containsObject:@"png"]) {
        NSArray *sourceImageNames = @[
            @"cqts_png_01.png",
            
            @"cqts_png_avatar_01.png",
        ];
        for (NSString *sourceImageName in sourceImageNames) {
            NSDictionary *dict = @{
                @"folderName": @"png",
                @"assetName": sourceImageName
            };
            [resultDictionarys addObject:dict];
        }
    }
    
    if ([folderNames containsObject:@"bmp"]) {
        NSArray *sourceImageNames = @[
            @"cqts_bmp_01.bmp",
            @"cqts_bmp_02.bmp",
        ];
        for (NSString *sourceImageName in sourceImageNames) {
            NSDictionary *dict = @{
                @"folderName": @"bmp",
                @"assetName": sourceImageName
            };
            [resultDictionarys addObject:dict];
        }
    }
    
    if ([folderNames containsObject:@"gif"]) {
        NSArray *sourceImageNames = @[
            @"cqts_gif_01.gif",
            @"cqts_gif_02.gif",
            @"cqts_gif_03.gif",
            @"cqts_gif_04.gif",
        ];
        for (NSString *sourceImageName in sourceImageNames) {
            NSDictionary *dict = @{
                @"folderName": @"GIF",
                @"assetName": sourceImageName
            };
            [resultDictionarys addObject:dict];
        }
    }
    
    if ([folderNames containsObject:@"webp"]) {
        NSArray *sourceImageNames = @[
            @"cqts_wp_01.webp",
        ];
        for (NSString *sourceImageName in sourceImageNames) {
            NSDictionary *dict = @{
                @"folderName": @"webp",
                @"assetName": sourceImageName
            };
            [resultDictionarys addObject:dict];
        }
    }
    
    if ([folderNames containsObject:@"heic"]) {
        NSArray *sourceImageNames = @[
            @"cqts_heic_01.HEIC",
        ];
        for (NSString *sourceImageName in sourceImageNames) {
            NSDictionary *dict = @{
                @"folderName": @"heic",
                @"assetName": sourceImageName
            };
            [resultDictionarys addObject:dict];
        }
    }
    
    if ([folderNames containsObject:@"svg"]) {
        NSArray *sourceImageNames = @[
            @"cqts_normal_svg_01.svg",
            @"cqts_normal_svg_02.svg",
            @"cqts_normal_animation_svg_01.svg",
            @"cqts_symbol_svg_01.svg",              // symbol 图标
        ];
        for (NSString *sourceImageName in sourceImageNames) {
            NSDictionary *dict = @{
                @"folderName": @"SVG",
                @"assetName": sourceImageName
            };
            [resultDictionarys addObject:dict];
        }
    }
    /*
    if ([folderNames containsObject:@"mp3"]) {
        NSArray *sourceImageNames = @[
//            @"cqts_normal_audio_01.mp3",
//            @"cqts_normal_audio_02.mp3",
        ];
        for (NSString *sourceImageName in sourceImageNames) {
            NSDictionary *dict = @{
                @"folderName": @"mp3",
                @"assetName": sourceImageName
            };
            [resultDictionarys addObject:dict];
        }
    }
    */
    if ([folderNames containsObject:@"mp4"]) {
        NSArray *sourceImageNames = @[
            @"cqts_video_mp4_01.mp4",
            @"cqts_vap_mp4_01.mp4",
            @"cqts_wallpaper_mp4_01.mp4",
        ];
        for (NSString *sourceImageName in sourceImageNames) {
            NSDictionary *dict = @{
                @"folderName": @"mp4",
                @"assetName": sourceImageName
            };
            [resultDictionarys addObject:dict];
        }
    }
    
    if ([folderNames containsObject:@"mov"]) {
        NSArray *sourceImageNames = @[
            @"cqts_mov_wallpaper_01.mov",
        ];
        for (NSString *sourceImageName in sourceImageNames) {
            NSDictionary *dict = @{
                @"folderName": @"mov",
                @"assetName": sourceImageName
            };
            [resultDictionarys addObject:dict];
        }
    }
    
    if ([folderNames containsObject:@"zip"]) {
        NSArray *sourceImageNames = @[
            @"cqts_zip_01.zip"
        ];
        for (NSString *sourceImageName in sourceImageNames) {
            NSDictionary *dict = @{
                @"folderName": @"zip",
                @"assetName": sourceImageName
            };
            [resultDictionarys addObject:dict];
        }
    }
    
    if ([folderNames containsObject:@"plist"]) {
        NSArray *sourceImageNames = @[
            @"cqts_area.plist",
            @"cqts_city.plist"
        ];
        for (NSString *sourceImageName in sourceImageNames) {
            NSDictionary *dict = @{
                @"folderName": @"plist",
                @"assetName": sourceImageName
            };
            [resultDictionarys addObject:dict];
        }
    }
    
    return resultDictionarys;
}




#pragma mark Icon资源文件 Url
/// 所有的网络测试icon图片地址
+ (NSArray<NSString *> *)iconUrls {
    NSArray<NSString *> *imageUrls = @[
        #pragma mark 以下网络图片从 https://image.baidu.com 中获取
        @"https://img2.baidu.com/it/u=248809548,2992510422&fm=253&fmt=auto&app=138&f=PNG?w=500&h=500",
        @"https://img0.baidu.com/it/u=3087067444,242345469&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500",
        @"https://img0.baidu.com/it/u=2142566046,3495686177&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500",
        @"https://img2.baidu.com/it/u=3935222850,2993881202&fm=253&fmt=auto&app=138&f=JPEG?w=707&h=500",
        @"https://img1.baidu.com/it/u=1110022854,3922459600&fm=253&fmt=auto&app=138&f=PNG?w=500&h=500",
        @"https://img0.baidu.com/it/u=2618490059,1120160608&fm=253&fmt=auto&app=138&f=JPEG?w=560&h=500",
    ];
    return imageUrls;
}

/*
NSInteger trySelIndex = random();
UIImage *iconUrlRandom = [CQTSAssetSourceUtil iconUrlAtIndex:trySelIndex];
*/
/*
 *  获取指定位置的Icon图片Url(为了cell显示的图片不会一直变化)
 *
 *  @param trySelIndex  指定位置(随机位置 NSInteger trySelIndex = random();)
 *
 *  @return 网络图片
 */
+ (NSString *)iconUrlAtIndex:(NSInteger)trySelIndex {
    NSArray<NSString *> *imageUrls = [self iconUrls];
    NSInteger selIndex = trySelIndex % imageUrls.count;    //位置太大的时候，从头循环使用图片
    NSString *imageUrl = [imageUrls objectAtIndex:selIndex];
    
    return imageUrl;
}


@end

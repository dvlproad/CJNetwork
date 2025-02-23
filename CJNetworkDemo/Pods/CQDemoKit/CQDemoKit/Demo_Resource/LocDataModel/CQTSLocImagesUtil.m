//
//  CQTSLocImagesUtil.m
//  CJComplexUIKitDemo
//
//  Created by lcQian on 2020/4/7.
//  Copyright © 2020 dvlproad. All rights reserved.
//

#import "CQTSLocImagesUtil.h"

@implementation CQTSLocImagesUtil

#pragma mark - placeholder Image
+ (UIImage *)cjts_placeholderImage01 {
    return [UIImage cqdemokit_xcassetImageNamed:@"cqts_placeholder01.jpg"];
}

#pragma mark - local BGImage
+ (UIImage *)cjts_localImageBG1 {
    return [UIImage cqdemokit_xcassetImageNamed:@"cqts_bgSky.jpg"];
}

+ (UIImage *)cjts_localImageBG2 {
    return [UIImage cqdemokit_xcassetImageNamed:@"cqts_bgCar.jpg"];
}

#pragma mark - High Scale
/// 水平长图
+ (UIImage *)longHorizontal01 {
    return [UIImage cqdemokit_xcassetImageNamed:@"cqts_long_horizontal_1.jpg"];
}

/// 竖直长图
+ (UIImage *)longVertical01 {
    return [UIImage cqdemokit_xcassetImageNamed:@"cqts_long_vertical_1.jpg"];
}



#pragma mark - local Image

/// 所有的本地测试图片
+ (NSArray<UIImage *> *)cjts_localImages {
    NSMutableArray<UIImage *> *images = [[NSMutableArray alloc] init];
    
    NSArray<NSString *> *imageNames = [self cjts_localImageNames:CQTSLocImageCategoryJPG];
    NSInteger imageCount = [imageNames count];
    for (int i = 0; i < imageCount; i++) {
        NSString *imageName = [imageNames objectAtIndex:i];
        UIImage *image = [UIImage cqdemokit_xcassetImageNamed:imageName];
        if (image == nil) {
            image = [[UIImage alloc] init];
        }
        [images addObject:image];
    }
    
    return images;
}

/// 所有的本地测试图片的名称
+ (NSArray<NSString *> *)cjts_localImageNames {
    return [self cjts_localImageNames:CQTSLocImageCategoryAll];
}

/// 随机的本地测试图片
+ (UIImage *)cjts_localImageRandom {
    NSArray<NSString *> *imageNames = [self cjts_localImageNames];
    NSInteger selIndex = random()%imageNames.count;
    NSString *imageName = [imageNames objectAtIndex:selIndex];
    
    UIImage *image = [UIImage cqdemokit_xcassetImageNamed:imageName];
    return image;
}

/// 获取指定位置的图片(为了cell显示的图片不会一直变化)
+ (UIImage *)cjts_localImageAtIndex:(NSInteger)selIndex {
    NSArray<NSString *> *imageNames = [self cjts_localImageNames];
    if (selIndex >= imageNames.count) { //位置太大的时候，固定使用第一张图片
        selIndex = 0;
    }
    NSString *imageName = [imageNames objectAtIndex:selIndex];
    
    UIImage *image = [UIImage cqdemokit_xcassetImageNamed:imageName];
    return image;
}

#pragma mark - test Images
/// 获取测试用的数据
/// （为本地图片名时候，UIImage *image = [UIImage cqdemokit_xcassetImageNamed:imageName]; ）
///
/// @param count                                                        图片个数
/// @param randomOrder                                          顺序是否随机
/// @param changeImageNameToNetworkUrl      是否将本地图片名转为其所在的网络地址
///
/// @return 返回图片数据
+ (NSMutableArray<CQTSLocImageDataModel *> *)dataModelsWithCount:(NSInteger)count
                                                     randomOrder:(BOOL)randomOrder
                                     changeImageNameToNetworkUrl:(BOOL)changeImageNameToNetworkUrl
{
    NSArray<NSString *> *imageNames = [self cjts_localImageNames];
    
    NSMutableArray<CQTSLocImageDataModel *> *dataModels = [[NSMutableArray alloc] init];
    NSArray<NSString *> *titles = @[@"X透社", @"新鲜事", @"XX信", @"X角信", @"蓝精灵", @"年轻范", @"XX福", @"X之语"];
    
    for (NSInteger i = 0; i < count; i++) {
        CQTSLocImageDataModel *dataModel = [[CQTSLocImageDataModel alloc] init];
        NSInteger maySelIndex = randomOrder ? random() : i;
        NSInteger lastImageSelIndex = maySelIndex%imageNames.count;
        NSInteger lastTitleSelIndex = maySelIndex%titles.count;
        
        NSString *imageName = [imageNames objectAtIndex:lastImageSelIndex];
        
        
//        UIImage *image = [UIImage cqdemokit_xcassetImageNamed:imageName];
//        if (image == nil) {
//            image = [[UIImage alloc] init];
//        }
        
        if (changeImageNameToNetworkUrl) {
            NSString *imageUrl = [NSString stringWithFormat:@"https://github.com/dvlproad/001-UIKit-CQDemo-iOS/blob/616ceb45522fd6c11d03237d5e2eb24a5d3a85d5/CQDemoKit/Demo_Resource/LocDataModel/Resources/%@?raw=true", imageName];
            dataModel.name = [NSString stringWithFormat:@"%02zd %@", i+1, imageName];
            dataModel.imageName = imageUrl;
        } else {
            //NSString *title = [NSString stringWithFormat:@"%zd:第index=%zd张", i, lastImageSelIndex];
            NSString *title = [titles objectAtIndex:lastTitleSelIndex];
            dataModel.name = [NSString stringWithFormat:@"%02zd %@", i+1, title];
            dataModel.imageName = imageName;
        }
        
        [dataModels addObject:dataModel];
    }
    
    return dataModels;
}


+ (NSArray<NSString *> *)cjts_localImageNames:(CQTSLocImageCategory)category {
    NSArray<NSString *> *imagesNames_jpg = @[
        @"cqts_1.jpg",
        @"cqts_2.jpg",
        @"cqts_3.jpg",
        @"cqts_4.jpg",
        @"cqts_5.jpg",
        @"cqts_6.jpg",
        @"cqts_7.jpg",
        @"cqts_8.jpg",
        @"cqts_9.jpg",
        @"cqts_10.jpg",
        @"cqts_long_horizontal_1.jpg",
        @"cqts_long_vertical_1.jpg",
        @"cqts_bgCar@2x.jpg",
        @"cqts_bgSky@2x.jpg",
        @"cqts_big_15M.jpg",
        @"cqts_big_22M.jpg",
    ];
    
    NSArray<NSString *> *imagesNames_gif = @[
        @"cqts_wp_1.webp",
        @"cqts_01.gif",
        @"cqts_02.gif",
        @"cqts_03.gif",
        @"cqts_04.gif",
    ];
    
    NSMutableArray *imagesNames_all = [[NSMutableArray alloc] init];
    [imagesNames_all addObjectsFromArray:imagesNames_jpg];
    [imagesNames_all addObjectsFromArray:imagesNames_gif];
    
    NSArray<NSString *> *resultImagesNames = nil;
    switch (category) {
        case CQTSLocImageCategoryJPG:
            resultImagesNames = imagesNames_jpg;
            break;
        case CQTSLocImageCategoryGIF:
            resultImagesNames = imagesNames_gif;
            break;
        default:
            resultImagesNames = imagesNames_all;
            break;
    }
    
    return resultImagesNames;
}

@end

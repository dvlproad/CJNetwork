//
//  CQTSLocImagesUtil.h
//  CJComplexUIKitDemo
//
//  Created by lcQian on 2020/4/7.
//  Copyright © 2020 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQTSLocImageDataModel.h"
#import "UIImage+CQDemoKit.h"

NS_ASSUME_NONNULL_BEGIN

// 辅助文本的移除顺序（当有多个相同tag的辅助文本的时候需要）
typedef NS_ENUM(NSInteger, CQTSLocImageCategory) {
    CQTSLocImageCategoryAll,    // 所有
    CQTSLocImageCategoryJPG,    // jpg
    CQTSLocImageCategoryGIF,    // gif
    CQTSLocImageCategoryWebP,   // webp
};

@interface CQTSLocImagesUtil : NSObject

#pragma mark - placeholder Image
+ (UIImage *)cjts_placeholderImage01;

#pragma mark - local BGImage
+ (UIImage *)cjts_localImageBG1;
+ (UIImage *)cjts_localImageBG2;

#pragma mark - High Scale
/// 水平长图
+ (UIImage *)longHorizontal01;
/// 竖直长图
+ (UIImage *)longVertical01;


#pragma mark - local Image
/// 所有的本地测试图片
+ (NSArray<UIImage *> *)cjts_localImages;
/// 所有的本地测试图片的名称
+ (NSArray<NSString *> *)cjts_localImageNames;
/// 随机的本地测试图片
+ (UIImage *)cjts_localImageRandom;
/// 获取指定位置的图片(为了cell显示的图片不会一直变化)
+ (UIImage *)cjts_localImageAtIndex:(NSInteger)selIndex;


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
                                     changeImageNameToNetworkUrl:(BOOL)changeImageNameToNetworkUrl;

@end

NS_ASSUME_NONNULL_END

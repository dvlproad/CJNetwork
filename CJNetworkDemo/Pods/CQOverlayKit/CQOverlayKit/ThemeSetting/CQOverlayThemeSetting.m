//
//  CQOverlayThemeSetting.m
//  AppCommonUICollect
//
//  Created by ciyouzen on 2019/3/15.
//  Copyright © 2019 dvlproad. All rights reserved.
//

#import "CQOverlayThemeSetting.h"

// overlay
#import "CQOverlayTheme.h"
#import <CJOverlayView/CJBaseOverlayThemeManager.h>
#import <CJOverlayView/CJActionSheetTableViewCell.h>

@implementation CQOverlayThemeSetting

#pragma mark - Theme UI Setting
/// UI common
+ (CJOverlayCommonThemeModel *)serviceUI_commonThemeModel {
    return [CJBaseOverlayThemeManager serviceThemeModel].commonThemeModel;
}

/// UI Toast
+ (CQToastThemeModel *)serviceUI_toastThemeModel {
    return [CJBaseOverlayThemeManager serviceThemeModel].toastThemeModel;
}

/// UI Alert
+ (CJAlertThemeModel *)serviceUI_alertThemeModel {
    return [CJBaseOverlayThemeManager serviceThemeModel].alertThemeModel;
}

/// UI HUD
+ (CQHUDThemeModel *)serviceUI_hudThemeModel {
    return [CJBaseOverlayThemeManager serviceThemeModel].hudThemeModel;
}


//+ (void)configHUDAnimationNamed:(NSString *)animationNamed {
//    CQHUDThemeModel *hudThemeModel = [CJBaseOverlayThemeManager serviceThemeModel].hudThemeModel;
//    hudThemeModel.animationNamed = animationNamed;
//}


//- (CQOverlayThemeSetting *(^)(NSString *animationNamed))configAnimationNamed {
//    return ^(NSString *animationNamed) {
//        CQHUDThemeModel *hudThemeModel = [CJBaseOverlayThemeManager serviceThemeModel].hudThemeModel;
//        hudThemeModel.animationNamed = animationNamed;
//
//        return self;
//    };
//}


#pragma mark - Theme Text Setting
/// 设置 全局默认 的 弹窗文本
+ (CQOverlayTextModel *)serviceText_allTextModel {
    return [CJBaseOverlayThemeManager serviceThemeModel].overlayTextModel;
}


/*
/// alert common
+ (void)overlayText_alertCommon_IKonwText:(NSString *)alertIKonwText
                               cancelText:(NSString *)alertCancelText
                                   okText:(NSString *)alertOKText
{
    [[self serviceText_allTextModel] updateText_alertCommon_IKonwText:alertIKonwText cancelText:alertCancelText okText:alertOKText];
}

/// alert callPhone
+ (void)overlayText_alertCallPhone_callPhoneText:(NSString *)callPhoneText
{
    CQOverlayTextModel *overlayTextModel = [self serviceText_allTextModel];
    overlayTextModel.alertCallPhoneText = callPhoneText;
}

/// alert network
+ (void)overlayText_alertNetwork_noOpenText:(NSString *)networkNoOpenText goOpenText:(NSString *)networkGoOpenText {
    CQOverlayTextModel *overlayTextModel = [self serviceText_allTextModel];
    overlayTextModel.networkNoOpenText = networkNoOpenText;
    overlayTextModel.networkGoOpenText = networkGoOpenText;
}

/// alert location
+ (void)overlayText_alertNetwork_noOpenText:(NSString *)locationNoOpenText
                                 goOpenText:(NSString *)locationGoOpenText
                               abnormalText:(NSString *)locationAbnormalText
{
    CQOverlayTextModel *overlayTextModel = [self serviceText_allTextModel];
    overlayTextModel.locationNoOpenText = locationNoOpenText;
    overlayTextModel.locationGoOpenText = locationGoOpenText;
    overlayTextModel.locationAbnormalText = locationAbnormalText;
}

/// sheet common
+ (void)overlayText_sheetCommon_cancelText:(NSString *)sheetCancelText {
    CQOverlayTextModel *overlayTextModel = [self serviceText_allTextModel];
    overlayTextModel.sheetCancelText = sheetCancelText;
}

/// sheet image choose
+ (void)overlayText_sheetImageChoose_takPhotoText:(NSString *)sheetTakPhotoText pickImageText:(NSString *)sheetPickImageText {
    CQOverlayTextModel *overlayTextModel = [self serviceText_allTextModel];
    overlayTextModel.sheetTakPhotoText = sheetTakPhotoText;
    overlayTextModel.sheetPickImageText = sheetPickImageText;
}

/// sheet map choose
+ (void)overlayText_sheetMapChoose_baiduMapText:(NSString *)sheetBaiduMapText
                                       amapText:(NSString *)sheetAmapText
                                   appleMapText:(NSString *)sheetAppleMapText
                               noInstallMapText:(NSString *)sheetNoInstallMapText
{
    CQOverlayTextModel *overlayTextModel = [self serviceText_allTextModel];
    overlayTextModel.sheetBaiduMapText = sheetBaiduMapText;
    overlayTextModel.sheetAmapText = sheetAmapText;
    overlayTextModel.sheetAppleMapText = sheetAppleMapText;
    overlayTextModel.sheetNoInstallMapText = sheetNoInstallMapText;
}
/*/


#pragma mark - Quick Use
/// 设置 全局默认 的 主题风格
+ (void)useThemeType:(OverlayThemeType)themeType {
    switch (themeType) {
        case OverlayThemeTypeCoffee:
        {
            [self _useThemeCoffee];
            break;
        }
        case OverlayThemeTypeTea:
        {
            [self _useThemeTea];
            break;
        }
        case OverlayThemeTypeEmployee:
        {
            [self _useThemeEmployee];
            break;
        }
        case OverlayThemeTypeBiaoli:
        {
            [self _useThemeBiaoli];
            break;
        }
        default:
        {
            break;
        }
    }
}


#pragma mark Theme Coffee
/// 设置 全局默认 的 主题 为 Coffee 主题
+ (void)_useThemeCoffee {
    // 设置 全局默认 的 进度加载
    CQHUDThemeModel *hudThemeModel = [CJBaseOverlayThemeManager serviceThemeModel].hudThemeModel;
    [hudThemeModel updateAnimationNamed:@"loading_coffee"
                        animationBundle:[CQHUDThemeModel currentHUDBundle]];
    
    
    // overlay
    CJBaseOverlayThemeModel *overlayThemeModel = [CJBaseOverlayThemeManager serviceThemeModel];
    // alert common
    overlayThemeModel.overlayTextModel.alertIKonwText = NSLocalizedString(@"我知道了", nil);
    overlayThemeModel.overlayTextModel.alertCancelText = NSLocalizedString(@"取消", nil);
    overlayThemeModel.overlayTextModel.alertOKText = NSLocalizedString(@"确定", nil);
    
    CJOverlayCommonThemeModel *commonThemeModel = overlayThemeModel.commonThemeModel;
    commonThemeModel.textDangerColor = [UIColor redColor];
    
    CJOverlaySheetThemeModel *sheetThemeModel = overlayThemeModel.sheetThemeModel;
    sheetThemeModel.iconHeight = 40;
    sheetThemeModel.iconTitleSpacing = 10;
    sheetThemeModel.topViewMinHeight_ifExsitTitle = 44;
    // view 生成的时候调用的block
    sheetThemeModel.sheetConfigBlock = ^(UIView * _Nonnull bSheetView) {
        bSheetView.backgroundColor = [UIColor whiteColor];
        bSheetView.layer.cornerRadius = 0;
        bSheetView.layer.masksToBounds = YES;
    };
    sheetThemeModel.topTitleLabelConfigBlock = ^(UILabel * _Nonnull bTopTitleLable) { // sheet顶部标题字体、颜色等
        bTopTitleLable.numberOfLines = 0;
        bTopTitleLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        bTopTitleLable.textColor = commonThemeModel.text666Color;
    };
    sheetThemeModel.mainTitleLabelConfigBlock = ^(UILabel * _Nonnull bMainTitleLable, BOOL isCancelItem) {  // cell上主标题的字体、颜色等
        bMainTitleLable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        bMainTitleLable.textColor = commonThemeModel.textMainColor;
    };
    sheetThemeModel.subTitleLabelConfigBlock = ^(UILabel * _Nonnull bSubTitleLable) {
        bSubTitleLable.textColor = overlayThemeModel.commonThemeModel.textAssistColor;
    };
    sheetThemeModel.bottomLineHeight = 1;
    sheetThemeModel.bottomLineColor = overlayThemeModel.commonThemeModel.separateLineColor;
    sheetThemeModel.cellRowHeight = 0;
    sheetThemeModel.section0FooterHeight = 10;
    //view 根据数据更新的时候调用的block
    sheetThemeModel.dangerCellConfigBlock = ^(UITableViewCell *bSheetCell, BOOL bIsDangerCell) {
        CJActionSheetTableViewCell *sheetCell = (CJActionSheetTableViewCell *)bSheetCell;
        UIColor *safeTextColor = commonThemeModel.textMainColor;
        UIColor *dangerTextColor = commonThemeModel.textDangerColor;
        if (bIsDangerCell) {
            sheetCell.mainTitleLabel.textColor = dangerTextColor;
        } else {
            sheetCell.mainTitleLabel.textColor = safeTextColor;
        }
    };
}


#pragma mark Theme Tea
/// 设置 全局默认 的 主题 为 Tea 主题
+ (void)_useThemeTea {
    // 设置 全局默认 的 进度加载
    CQHUDThemeModel *hudThemeModel = [CJBaseOverlayThemeManager serviceThemeModel].hudThemeModel;
    [hudThemeModel updateAnimationNamed:@"loading_tea"
                        animationBundle:[CQHUDThemeModel currentHUDBundle]];
}


#pragma mark Theme Employee
/// 设置 全局默认 的 主题 为 Employee 主题
+ (void)_useThemeEmployee {
    // 设置 全局默认 的 进度加载
    CQHUDThemeModel *hudThemeModel = [CJBaseOverlayThemeManager serviceThemeModel].hudThemeModel;
    [hudThemeModel updateAnimationNamed:@"loading_coffee"
                        animationBundle:[CQHUDThemeModel currentHUDBundle]];
}


#pragma mark Theme Biaoli
/// 设置 全局默认 的 主题 为 Biaoli 主题
+ (void)_useThemeBiaoli {
    // 设置 全局默认 的 进度加载
    CQHUDThemeModel *hudThemeModel = [CJBaseOverlayThemeManager serviceThemeModel].hudThemeModel;
    [hudThemeModel updateAnimationNamed:@"loading_tea"
                        animationBundle:[CQHUDThemeModel currentHUDBundle]];
    
    // overlay
    CJBaseOverlayThemeModel *overlayThemeModel = [CJBaseOverlayThemeManager serviceThemeModel];
    // alert common
    overlayThemeModel.overlayTextModel.alertIKonwText = NSLocalizedString(@"我知道了", nil);
    overlayThemeModel.overlayTextModel.alertCancelText = NSLocalizedString(@"取消", nil);
    overlayThemeModel.overlayTextModel.alertOKText = NSLocalizedString(@"确定", nil);
    
    CJOverlayCommonThemeModel *commonThemeModel = overlayThemeModel.commonThemeModel; // commonThemeModel一般在外部设置app主题时候设置，内部只使用
    commonThemeModel.textDangerColor = [UIColor colorWithRed:251/255.0 green:88/255.0 blue:88/255.0 alpha:1.0]; // #FB5858
    
    CJOverlaySheetThemeModel *sheetThemeModel = overlayThemeModel.sheetThemeModel;
    sheetThemeModel.iconHeight = 22;
    sheetThemeModel.iconTitleSpacing = 6;
    sheetThemeModel.topViewMinHeight_ifExsitTitle = 66;
    // view 生成的时候调用的block
    sheetThemeModel.sheetConfigBlock = ^(UIView * _Nonnull bSheetView) {
        bSheetView.backgroundColor = [UIColor whiteColor];
        bSheetView.layer.cornerRadius = 30;
        bSheetView.layer.masksToBounds = YES;
    };
    sheetThemeModel.topTitleLabelConfigBlock = ^(UILabel * _Nonnull bTopTitleLable) { // sheet顶部标题字体、颜色等
        bTopTitleLable.numberOfLines = 0;
        bTopTitleLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        bTopTitleLable.textColor = commonThemeModel.text666Color;
    };
    sheetThemeModel.mainTitleLabelConfigBlock = ^(UILabel * _Nonnull bMainTitleLable, BOOL isCancelItem) {  // cell上主标题的字体、颜色等
        bMainTitleLable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        bMainTitleLable.textColor = commonThemeModel.textMainColor;
    };
    sheetThemeModel.subTitleLabelConfigBlock = ^(UILabel * _Nonnull bSubTitleLable) {
        bSubTitleLable.textColor = overlayThemeModel.commonThemeModel.textAssistColor;
    };
    sheetThemeModel.bottomLineHeight = 0;
    //sheetThemeModel.bottomLineColor = overlayThemeModel.commonThemeModel.separateLineColor;
    sheetThemeModel.cellRowHeight = 58;
    sheetThemeModel.section0FooterHeight = 0;
    //view 根据数据更新的时候调用的block
    sheetThemeModel.dangerCellConfigBlock = ^(UITableViewCell *bSheetCell, BOOL bIsDangerCell) {
        CJActionSheetTableViewCell *sheetCell = (CJActionSheetTableViewCell *)bSheetCell;
        UIColor *safeTextColor = commonThemeModel.textMainColor;
        UIColor *dangerTextColor = commonThemeModel.textDangerColor;
        if (bIsDangerCell) {
            sheetCell.mainTitleLabel.textColor = dangerTextColor;
        } else {
            sheetCell.mainTitleLabel.textColor = safeTextColor;
        }
    };
}

@end

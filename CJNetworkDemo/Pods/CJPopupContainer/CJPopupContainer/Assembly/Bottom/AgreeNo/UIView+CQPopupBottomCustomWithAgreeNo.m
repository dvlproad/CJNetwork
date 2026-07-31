//
//  UIView+CQPopupBottomCustomWithAgreeNo.m
//  TSPopupDemo
//
//  Created by ciyouzen on 2021/9/26.
//

#import "UIView+CQPopupBottomCustomWithAgreeNo.h"
#import "CJBottomBlankView.h"
#import "CQEffectAndCornerHelper.h"

#import "CJBottomAgreeNoPopupView.h"

@implementation UIView (CQPopupBottomCustomWithAgreeNo)


+ (CJBottomBlankView *)cqBottomAgreeNoBlankViewWithCustomView:(UIView *)customView
                                             customViewHeight:(CGFloat)customViewHeight
                                                  cancelBlock:(void(^)(CJBottomBlankView *bBlankView))cancelBlock
                                                      okBlock:(void(^)(CJBottomBlankView *bBlankView))okBlock
{
    CJBottomAgreeNoPopupView *popupView = [[CJBottomAgreeNoPopupView alloc] initWithPopupContentView:customView cancelBlock:^(CJBottomAgreeNoPopupView * _Nonnull bPopupView) {
        CJBottomBlankView *bBlankView = [CJBottomBlankView blankViewFromPopupView:bPopupView];
        !cancelBlock ?: cancelBlock(bBlankView);
        
    } okBlock:^(CJBottomAgreeNoPopupView * _Nonnull bPopupView) {
        CJBottomBlankView *bBlankView = [CJBottomBlankView blankViewFromPopupView:bPopupView];
        !okBlock ?: okBlock(bBlankView);
    }];
    CGFloat popupViewHeight = [popupView viewHeightWithContentHeight:customViewHeight];
    
    
    CJBottomBlankView *blankView = [[CJBottomBlankView alloc] initWithPopupView:popupView popupViewHeight:popupViewHeight tapBlankHandle:nil];
    // 2.其他 添加效果
    [CQEffectAndCornerHelper createEffectViewWithEffectStyle:CQEffectStyleBGColor
                                                    newEffectViewAddToView:blankView
                                           newEffectViewCloseToViewSubView:blankView];
    
    return blankView;
}

@end

//
//  UIView+CQBottomCustomWithClose.m
//  TSPopupDemo
//
//  Created by ciyouzen on 2019/8/27.
//  Copyright © 2019 dvlproad. All rights reserved.
//

#import "UIView+CQBottomCustomWithClose.h"
#import "CQBottomPanlineBlankView.h"


#import "CJBottomTRClosePopupView.h"

@implementation UIView (CQBottomCustomWithClose)

+ (CQBottomPanlineBlankView *)cqBottomCloseBlankViewWithCustomView:(UIView *)customView
                                                   customViewHeight:(CGFloat)customViewHeight
                                                         closeBlock:(void(^ _Nullable)(CQBottomPanlineBlankView *bBlankView))closeBlock
                                                   tapBlankDismiss:(void(^ _Nullable)(CQBottomPanlineBlankView *bBlankView))tapBlankDismiss
{
    CJBottomTRClosePopupView *popupView = [[CJBottomTRClosePopupView alloc] initWithPopupContentView:customView closeButtonCompleteBlock:^(CJBottomTRClosePopupView * _Nonnull bPopupView) {
        CQBottomPanlineBlankView *bBlankView = [CQBottomPanlineBlankView blankViewFromCustomViewWithoutPanline:bPopupView];
        !closeBlock ?: closeBlock(bBlankView);
    }];
    CQBottomPanlineBlankView *blankView = [[CQBottomPanlineBlankView alloc] initWithShowPanLine:NO customViewWithoutPanline:popupView customViewWithoutPanlineHeight:customViewHeight panCompleteDismissBlock:nil tapBlankHandle:^(CQBottomPanlineBlankView * _Nonnull bBlankView) {
        !tapBlankDismiss ?: tapBlankDismiss(bBlankView);
    }];
    [blankView effectAndCornerWithEffectViewPart:CQBottomBlankAndPanlinePopupPartBlankView
                                     effectStyle:CQEffectStyleBGColor
                                  cornerViewPart:CQBottomBlankAndPanlinePopupPartPopupView];
    return blankView;
}

@end

//
//  UIView+CQPopupBottomPanlineSelf.m
//  CJPopupContainer
//
//  Created by ciyouzen on 2019/10/22.
//

#import "UIView+CQPopupBottomPanlineSelf.h"

@implementation UIView (CQPopupBottomPanlineSelf)

+ (CQBottomPanlineBlankView *)cqBottomPanlineBlankViewWithPopupView:(UIView *)popupView
                                                   popupViewHeight:(CGFloat)popupViewHeight
                                                    cornerViewPart:(CQBottomBlankAndPanlinePopupPart)cornerViewPart
                                                    effectViewPart:(CQBottomBlankAndPanlinePopupPart)effectViewPart
                                                       effectStyle:(CQEffectStyle)effectStyle
                                              shouldEnableTapBlank:(BOOL)shouldEnableTapBlank
                                                 tapBlankComplete:(void(^ _Nullable)(CQBottomPanlineBlankView *bBlankView))tapBlankComplete
                                              shouldAddPanAction:(BOOL)shouldAddPanAction
                                         panCompleteDismissBlock:(void(^ _Nullable)(CQBottomPanlineBlankView *bBlankView))panCompleteDismissBlock
{
    CQBottomPanlineBlankView *blankView = [[CQBottomPanlineBlankView alloc] initWithShowPanLine:shouldAddPanAction
                                                                      customViewWithoutPanline:popupView
                                                                customViewWithoutPanlineHeight:popupViewHeight
                                                                       panCompleteDismissBlock:^(CQBottomPanlineBlankView *bBlankView) {
        if (panCompleteDismissBlock) {
            panCompleteDismissBlock(bBlankView);
        } else {
            [bBlankView hideBlankView];
        }
    } tapBlankHandle:^(CQBottomPanlineBlankView *bBlankView) {
        if (shouldEnableTapBlank == NO) {
            return;
        }
        if (tapBlankComplete) {
            tapBlankComplete(bBlankView);
        } else {
            [bBlankView hideBlankView];
        }
    }];
    
    [blankView effectAndCornerWithEffectViewPart:effectViewPart
                                     effectStyle:effectStyle
                                  cornerViewPart:cornerViewPart];
    
    return blankView;
}

@end

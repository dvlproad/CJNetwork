//
//  UIView+CQPopupBottomSelf.m
//  CJPopupContainer
//
//  Created by ciyouzen on 2019/10/22.
//

#import "UIView+CQPopupBottomSelf.h"
#import <CJPopupContainer/CQEffectAndCornerHelper.h>

@implementation UIView (CQPopupBottomSelf)

+ (CJBottomBlankView *)cqBottomBlankViewWithPopupView:(UIView *)popupView
                                     popupViewHeight:(CGFloat)popupViewHeight
                                        effectStyle:(CQEffectStyle)effectStyle
                               shouldEnableTapBlank:(BOOL)shouldEnableTapBlank
                                  tapBlankComplete:(void(^ _Nullable)(CJBottomBlankView *bBlankView))tapBlankComplete
                               shouldAddPanAction:(BOOL)shouldAddPanAction
                          panCompleteDismissBlock:(void(^ _Nullable)(CJBottomBlankView *bBlankView))panCompleteDismissBlock
{
    CJBottomBlankView *blankView = [[CJBottomBlankView alloc] initWithPopupView:popupView
                                                                 popupViewHeight:popupViewHeight
                                                                  tapBlankHandle:^(CJBottomBlankView *bSelf) {
        if (shouldEnableTapBlank == NO) {
            return;
        }
        if (tapBlankComplete) {
            tapBlankComplete(bSelf);
        } else {
            [bSelf hideBlankView];
        }
    }];
    
    [CQEffectAndCornerHelper createEffectViewWithEffectStyle:effectStyle
                                      newEffectViewAddToView:blankView
                             newEffectViewCloseToViewSubView:blankView];
    
    if (shouldAddPanAction) {
        [blankView addPanWithPanCompleteDismissBlock:^(CJBottomBlankView *bSelf) {
            if (panCompleteDismissBlock) {
                panCompleteDismissBlock(bSelf);
            } else {
                [bSelf hideBlankView];
            }
        }];
    }
    
    return blankView;
}

@end

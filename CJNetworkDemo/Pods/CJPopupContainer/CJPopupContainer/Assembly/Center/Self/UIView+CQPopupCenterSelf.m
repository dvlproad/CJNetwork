//
//  UIView+CQPopupCenterSelf.m
//  CJPopupContainer
//
//  Created by ciyouzen on 2019/10/22.
//

#import "UIView+CQPopupCenterSelf.h"
#import <CJPopupContainer/CQEffectAndCornerHelper.h>

@implementation UIView (CQPopupCenterSelf)

+ (CJCenterBlankView *)cqCenterBlankViewWithPopupView:(UIView *)popupView
                                      popupViewSize:(CGSize)popupViewSize
                                  popupCenterOffset:(CGPoint)popupCenterOffset
                                       effectStyle:(CQEffectStyle)effectStyle
                                    tapBlankDismiss:(void(^ _Nullable)(CJCenterBlankView *bSelf))tapBlankDismiss
{
    CJCenterBlankView *blankView = [[CJCenterBlankView alloc] initWithPopupView:popupView
                                                                  popupViewSize:popupViewSize
                                                              popupCenterOffset:popupCenterOffset
                                                                 tapBlankHandle:^(CJCenterBlankView *bSelf) {
        !tapBlankDismiss ?: tapBlankDismiss(bSelf);
    }];
    
    [CQEffectAndCornerHelper createEffectViewWithEffectStyle:effectStyle
                                      newEffectViewAddToView:blankView
                             newEffectViewCloseToViewSubView:blankView];
    
    return blankView;
}

@end

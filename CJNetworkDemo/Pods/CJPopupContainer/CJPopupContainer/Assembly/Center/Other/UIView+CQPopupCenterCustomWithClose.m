//
//  UIView+CQPopupCenterCustomWithClose.m
//  TSPopupDemo
//
//  Created by ciyouzen on 2019/10/22.
//  Copyright © 2019 dvlproad. All rights reserved.
//

#import "UIView+CQPopupCenterCustomWithClose.h"
#import "CJCenterBCIKnowPopupView.h"
#import "CJCenterBCClosePopupView.h"

#import "CJCenterBlankView.h"
#import "CQEffectAndCornerHelper.h"


@implementation UIView (CQPopupCenterCustomWithClose)

+ (CJCenterBlankView *)cqCenterIKnowBlankViewWithCustomView:(UIView *)customView
                                        withClickIKnowBlock:(void(^)(void))clickIKnowBlock
                                            tapBlankDismiss:(void(^ _Nullable)(CJCenterBlankView *bSelf))tapBlankDismiss
{
    CJCenterBCIKnowPopupView *popupView = [[CJCenterBCIKnowPopupView alloc] initWithPopupContentView:customView clickConfirmButtonBlock:clickIKnowBlock];
    CGSize popupViewSize = CGSizeMake(290, 261);
    CGPoint centerOffset = CGPointMake(0, 0);
    
    CJCenterBlankView *blankView = [[CJCenterBlankView alloc] initWithPopupView:popupView popupViewSize:popupViewSize popupCenterOffset:centerOffset tapBlankHandle:^(CJCenterBlankView * _Nonnull bSelf) {
        !tapBlankDismiss ?: tapBlankDismiss(bSelf);
    }];
    [CQEffectAndCornerHelper createEffectViewWithEffectStyle:CQEffectStyleNone
                                      newEffectViewAddToView:blankView
                             newEffectViewCloseToViewSubView:blankView];
    
    return blankView;
}

+ (CJCenterBlankView *)cqCenterCloseBlankViewWithCustomView:(UIView *)customView
                                            tapBlankDismiss:(void(^ _Nullable)(CJCenterBlankView *bSelf))tapBlankDismiss
                                               closeDismiss:(void(^ _Nullable)(CJCenterBlankView *blankView))closeDismiss
{
    CJCenterBCClosePopupView *popupView = [[CJCenterBCClosePopupView alloc] initWithPopupContentView:customView closeButtonCompleteBlock:^(CJCenterBCClosePopupView * _Nonnull bPopupView) {
        CJCenterBlankView *blankView = (CJCenterBlankView *)bPopupView.superview;
        !closeDismiss ?: closeDismiss(blankView);
    }];
    CGSize popupViewSize = CGSizeMake(290, 348);
    CJCenterBlankView *blankView = [[CJCenterBlankView alloc] initWithPopupView:popupView popupViewSize:popupViewSize popupCenterOffset:CGPointZero tapBlankHandle:^(CJCenterBlankView * _Nonnull bSelf) {
        !tapBlankDismiss ?: tapBlankDismiss(bSelf);
    }];
    return blankView;
}

@end

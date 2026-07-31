//
//  CQBottomPanlineAndToolbarBlankView.m
//  CJBlankPresenter
//
//  Created by ciyouzen on 2021/10/13.
//

#import "CQBottomPanlineAndToolbarBlankView.h"
#import "CQBottomCustomWithPanlineView.h"
#import "CQBottomCustomWithToolbarView.h"


@interface CQBottomPanlineAndToolbarBlankView () {
    
}

@end


@implementation CQBottomPanlineAndToolbarBlankView

#pragma mark - Init
/*
 *  初始化包含popupView的【底部完整弹出框视图】
 *
 *  @param showPanLine                      是否显示下拉线
 *  @param customViewWithoutPanline         下拉线panline视图和toolbar视图都除外的其他视图
 *  @param customViewWithoutPanlineHeight   下拉线panline视图和toolbar视图都除外的其他视图的高度
 *  @param tapBlankHandle                   点击视图的回调（每一个弹窗的背景点击回调都不一样）
 *  @param panCompleteDismissBlock          拖动结束需要执行dimiss的回调(showPanLine为NO的时候，此值无效，相当于设为nil)
 *
 *  @return 包含popupView的【底部完整弹出框视图】
 */
- (instancetype)initWithShowPanLine:(BOOL)showPanLine
 customViewWithoutPanlineAndToolbar:(UIView *)customViewWithoutPanlineAndToolbar
customViewWithoutPanlineAndToolbarHeight:(CGFloat)customViewWithoutPanlineAndToolbarHeight
            panCompleteDismissBlock:(void(^ _Nullable)(CQBottomPanlineBlankView *bBlankView))panCompleteDismissBlock
                     tapBlankHandle:(void(^ _Nullable)(CQBottomPanlineBlankView *bBlankView, BOOL bToolbarOKEnable))tapBlankHandle
{
    // 1、创建自定义的视图【该视图包含着toolbar，后面作为除下拉线外的视图来使用】
    CQBottomCustomWithToolbarView *customViewWithToolbar = [[CQBottomCustomWithToolbarView alloc] initWithCustomView:customViewWithoutPanlineAndToolbar];
    CGFloat customViewWithToolbarHeight = [CQBottomCustomWithToolbarView contentViewHeightWithCustomViewHeight:customViewWithoutPanlineAndToolbarHeight];
    
    // 2、通过上述创建的视图创建【包含着有下拉线panline视图的popupView弹出视图的blankView空白视图】
    self = [super initWithShowPanLine:showPanLine customViewWithoutPanline:customViewWithToolbar customViewWithoutPanlineHeight:customViewWithToolbarHeight panCompleteDismissBlock:panCompleteDismissBlock tapBlankHandle:^(CQBottomPanlineBlankView * _Nonnull bBlankView) {
        CQBottomCustomWithToolbarView *customViewWithToolbar = ((CQBottomPanlineAndToolbarBlankView *)bBlankView).customViewWithToolbar;
        CQBottomToolbarView *toolbar = customViewWithToolbar.toolbar;
        BOOL toolbarOKEnable = toolbar.okButton.enabled;
        !tapBlankHandle ?: tapBlankHandle(bBlankView, toolbarOKEnable);
    }];
    
    return self;
}


#pragma mark - Get SubView
/// 获取包含着 自定义视图+toolbar视图 的视图整体（实际上就是扣除下拉线以外的视图）
- (CQBottomCustomWithToolbarView *)customViewWithToolbar {
    CQBottomCustomWithPanlineView *popupView = self.popupView;
    CQBottomCustomWithToolbarView *customViewWithToolbar = popupView.customView;
    
    return customViewWithToolbar;
}

#pragma mark - Get Method
/// 通过 customViewWithoutPanlineAndToolbar 获取到其所在的 blankView ，常用于 toolbar的点击需要让 blankView 执行隐藏等动作时候使用
+ (CQBottomPanlineAndToolbarBlankView *)blankViewFromCustomViewWithoutPanlineAndToolbar:(UIView *)customViewWithoutPanlineAndToolbar {
    for (UIView *superview = customViewWithoutPanlineAndToolbar.superview;
         superview != nil;
         superview = superview.superview) {
        if ([superview isKindOfClass:[CQBottomPanlineAndToolbarBlankView class]]) {
            return (CQBottomPanlineAndToolbarBlankView *)superview;
        }
    }
    return nil;
}

#pragma mark - Update SelfHeight(比较少用)
/*
 *  更新popupView视图的高度
 *  使用场景：带有输入文本框的弹出视图，随着输入内容的长度变化，高度会变化）
 *
 *  @param customViewWithoutPanlineAndToolbarHeight     下拉线panline视图和toolbar视图都除外的其他视图的高度
 */
- (void)updateHeightWithWithoutPanlineAndToolbarHeight:(CGFloat)customViewWithoutPanlineAndToolbarHeight {
    CQBottomCustomWithPanlineView *popupView = self.popupView;
    CQBottomCustomWithToolbarView *customViewWithToolbar = popupView.customView;
    CGFloat customViewWithToolbarHeight = [CQBottomCustomWithToolbarView contentViewHeightWithCustomViewHeight:customViewWithoutPanlineAndToolbarHeight];
    
    CGFloat popupViewHeight = [popupView viewHeightWithCustomViewHeight:customViewWithToolbarHeight];
    
    [self updatePopupViewHeight:popupViewHeight];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

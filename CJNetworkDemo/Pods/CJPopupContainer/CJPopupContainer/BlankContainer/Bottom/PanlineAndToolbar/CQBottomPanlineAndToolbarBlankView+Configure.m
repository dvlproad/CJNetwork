#import "CQBottomPanlineAndToolbarBlankView+Configure.h"

@implementation CQBottomPanlineAndToolbarBlankView (Configure)

- (instancetype)initWithShowPanLine:(BOOL)showPanLine
 customViewWithoutPanlineAndToolbar:(UIView *)customViewWithoutPanlineAndToolbar
customViewWithoutPanlineAndToolbarHeight:(CGFloat)customViewWithoutPanlineAndToolbarHeight
                       toolbarTitle:(NSString *)title
                           oKHandle:(nullable CQOKResult(^)(BOOL toolbarOKEnable, CQOKOperation okOperation))okHandle
               shouldEnableTapBlank:(BOOL)shouldEnableTapBlank
                 shouldAddPanAction:(BOOL)shouldAddPanAction
                 tapBlankFirstTryOK:(BOOL)tapBlankOrPandissmissFirstTryOK
                    popupHideHandle:(void(^ _Nonnull)(void))popupHideHandle
{
    self = [self initWithShowPanLine:showPanLine
          customViewWithoutPanlineAndToolbar:customViewWithoutPanlineAndToolbar
    customViewWithoutPanlineAndToolbarHeight:customViewWithoutPanlineAndToolbarHeight
                   panCompleteDismissBlock:^(CQBottomPanlineBlankView *bBlankView) {
        CQBottomToolbarView *toolbar = ((CQBottomPanlineAndToolbarBlankView *)bBlankView).customViewWithToolbar.toolbar;
        if (okHandle && tapBlankOrPandissmissFirstTryOK) {
            okHandle(toolbar.okButton.enabled, CQOKOperationPanDismiss);
        }
        !popupHideHandle ?: popupHideHandle();
    } tapBlankHandle:^(CQBottomPanlineBlankView *bBlankView, BOOL bToolbarOKEnable) {
        if (shouldEnableTapBlank == NO) {
            return;
        }
        if (okHandle && tapBlankOrPandissmissFirstTryOK) {
            CQOKResult okActionResult = okHandle(bToolbarOKEnable, CQOKOperationTapBlank);
            if (okActionResult == CQOKResultSuccessAndHide || okActionResult == CQOKResultFailureAndHide) {
                !popupHideHandle ?: popupHideHandle();
            }
        } else {
            !popupHideHandle ?: popupHideHandle();
        }
    }];

    CQBottomToolbarView *toolbar = self.customViewWithToolbar.toolbar;
    [toolbar configToolTitle:title];
    [toolbar configCancelButtonTitle:NSLocalizedString(@"取消", nil) cancelButtonHandle:^{
        !popupHideHandle ?: popupHideHandle();
    }];
    if (okHandle) {
        [toolbar configOKButtonTitle:NSLocalizedString(@"完成", nil) okButtonHandle:^{
            CQOKResult okActionResult = okHandle(YES, CQOKOperationToolbarOK);
            if (okActionResult == CQOKResultSuccessAndHide || okActionResult == CQOKResultFailureAndHide) {
                !popupHideHandle ?: popupHideHandle();
            }
        }];
    } else {
        [toolbar configOKButtonTitle:nil okButtonHandle:nil];
    }

    return self;
}

@end

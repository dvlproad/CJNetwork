#import "CQBottomPanlineAndToolbarBlankView.h"
#import "CQPopupBottomPanlineToolbarActionEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface CQBottomPanlineAndToolbarBlankView (Configure)

/*
 *  初始化【带 toolbar 的完整配置版】底部弹窗
 *  相比基类 CQBottomPanlineAndToolbarBlankView 的 initWithShowPanLine:...:
 *    - 多出 toolbarTitle/oKHandle：设置 toolbar 标题 + 完成/取消按钮
 *    - 多出 shouldEnableTapBlank：控制点击空白是否可关闭
 *    - 多出 tapBlankFirstTryOK：先执行 okHandle 再决定是否关闭
 *    - 多出 popupHideHandle：统一关闭回调
 */
- (instancetype)initWithShowPanLine:(BOOL)showPanLine
 customViewWithoutPanlineAndToolbar:(UIView *)customViewWithoutPanlineAndToolbar
customViewWithoutPanlineAndToolbarHeight:(CGFloat)customViewWithoutPanlineAndToolbarHeight
                       toolbarTitle:(NSString *)title
                           oKHandle:(nullable CQOKResult(^)(BOOL toolbarOKEnable, CQOKOperation okOperation))okHandle
               shouldEnableTapBlank:(BOOL)shouldEnableTapBlank
                 shouldAddPanAction:(BOOL)shouldAddPanAction
                 tapBlankFirstTryOK:(BOOL)tapBlankOrPandissmissFirstTryOK
                    popupHideHandle:(void(^ _Nonnull)(void))popupHideHandle;

@end

NS_ASSUME_NONNULL_END

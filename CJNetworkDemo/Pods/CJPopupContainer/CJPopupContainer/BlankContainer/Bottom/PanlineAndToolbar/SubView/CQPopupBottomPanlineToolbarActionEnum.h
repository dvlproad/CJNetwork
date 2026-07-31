//
//  CQPopupBottomPanlineToolbarActionEnum.h
//  AppCommonUICollect
//
//  Created by ciyouzen on 2019/8/13.
//  Copyright © 2019 dvlproad. All rights reserved.
//

#ifndef CQPopupBottomPanlineToolbarActionEnum_h
#define CQPopupBottomPanlineToolbarActionEnum_h

typedef NS_ENUM(NSUInteger, CQOKOperation) {
    CQOKOperationToolbarOK,     /**< toolbar上的确认点击 */
    CQOKOperationTapBlank,      /**< 点击空白区域 */
    CQOKOperationPanDismiss,    /**< 拖动消失 */
};

/// ok事件执行后所得结果及要对弹窗所做的动作
typedef NS_ENUM(NSUInteger, CQOKResult) {
    CQOKResultSuccessAndHide,   /**< 事件执行成功并隐藏弹窗 */
    CQOKResultFailureAndHide,   /**< 事件执行失败但执行隐藏弹窗 */
    CQOKResultFailureAndOpen,   /**< 事件执行失败同时保持显示弹窗 */
};



typedef NS_ENUM(NSUInteger, CQBottomPopupViewEdgeInsetsType) {
    CQBottomPopupViewEdgeInsetsTypeDefault = 0,                 /**< 紧贴屏幕底部 */
    CQBottomPopupViewEdgeInsetsTypeFloatingUp1,                 /**< 底部离开安全区域，并内缩(下左右内缩)10 */
    CQBottomPopupViewEdgeInsetsTypeFloatingUp2,                 /**< 底部离开安全区域，无内缩 */
};



#endif /* CQPopupBottomPanlineToolbarActionEnum_h */

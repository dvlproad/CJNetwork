#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CJLogModel.h"
#import "CJLogSuspendWindow.h"
#import "CJLogUtil.h"
#import "CJLogView.h"
#import "CJLogViewWindow.h"

FOUNDATION_EXPORT double CJMonitorVersionNumber;
FOUNDATION_EXPORT const unsigned char CJMonitorVersionString[];


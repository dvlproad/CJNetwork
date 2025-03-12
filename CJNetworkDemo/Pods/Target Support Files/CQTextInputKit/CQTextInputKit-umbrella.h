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

#import "CQScheduleTextField.h"
#import "CQTextFieldFactory.h"
#import "UITextField+CQThemeAndText.h"
#import "CJVerticalCenterTextView.h"
#import "CQShouldChangeBlockTextView.h"
#import "CQVerticalCenterTextView.h"
#import "CJTextView+ThemeAndText.h"
#import "UIVerticalCenterTextView.h"
#import "CQSubStringUtil.h"
#import "NSString+CJTextLength.h"
#import "CQBlockTextField.h"
#import "CQBlockTextView.h"
#import "UITextViewCQHelper.h"

FOUNDATION_EXPORT double CQTextInputKitVersionNumber;
FOUNDATION_EXPORT const unsigned char CQTextInputKitVersionString[];


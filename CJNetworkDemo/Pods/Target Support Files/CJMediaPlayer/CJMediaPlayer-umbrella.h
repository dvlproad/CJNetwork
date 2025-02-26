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

#import "CJMediaPlayer.h"
#import "CJMediaPlayerDefine.h"
#import "CJVideoView.h"
#import "CJPlayerController.h"
#import "CJLoadingProgressView.h"
#import "CJPlayerMaskView.h"
#import "CJPlayerProgressView.h"
#import "CJPlayerView.h"
#import "CJPlayerViewController.h"
#import "CJPlayerManager.h"

FOUNDATION_EXPORT double CJMediaPlayerVersionNumber;
FOUNDATION_EXPORT const unsigned char CJMediaPlayerVersionString[];


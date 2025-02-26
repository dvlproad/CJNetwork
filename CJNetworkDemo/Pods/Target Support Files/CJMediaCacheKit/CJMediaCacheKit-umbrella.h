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

#import "CJAVResourceCache.h"
#import "CJAVResourceDataBlock.h"
#import "CJAVResourceInfo.h"
#import "CJAVAssetResourceLoaderManager.h"
#import "CJAVCacheKit.h"
#import "CJAVUtil.h"
#import "CJAVResourceLoaderTask.h"
#import "CJAVResourceRequest.h"

FOUNDATION_EXPORT double CJMediaCacheKitVersionNumber;
FOUNDATION_EXPORT const unsigned char CJMediaCacheKitVersionString[];


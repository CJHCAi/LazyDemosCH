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

#import "NSValue+PlatformIndependence.h"
#import "RBBAnimation.h"
#import "RBBBlockBasedArray.h"
#import "RBBCubicBezier.h"
#import "RBBCustomAnimation.h"
#import "RBBEasingFunction.h"
#import "RBBLinearInterpolation.h"
#import "RBBSpringAnimation.h"
#import "RBBTweenAnimation.h"
#import "UIColor+PlatformIndependence.h"

FOUNDATION_EXPORT double RBBAnimationVersionNumber;
FOUNDATION_EXPORT const unsigned char RBBAnimationVersionString[];


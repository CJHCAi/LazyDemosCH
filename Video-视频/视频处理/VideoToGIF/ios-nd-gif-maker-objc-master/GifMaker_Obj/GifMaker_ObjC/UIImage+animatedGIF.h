//
//  UIImage+animatedGIF.h
//  GifMaker_ObjC
//
//  Modified by Gabrielle Miller-Messner on 3/1/16.
//  Author: Rob Mayoff 2012-01-27
//  The contents of the source repository for these files are dedicated to the public domain, in accordance with the CC0 1.0 Universal Public Domain Dedication, which is reproduced in the file COPYRIGHT.

@import Foundation;
@import UIKit;

/**
 UIImage (animatedGIF)
 
 This category adds class methods to `UIImage` to create an animated `UIImage` from an animated GIF.
 */

@interface UIImage(animatedGIF)
/*
 UIImage *animation = [UIImage animatedImageWithAnimatedGIFData:theData];
 
 I interpret `theData` as a GIF.  I create an animated `UIImage` using the source images in the GIF.
 
 The GIF stores a separate duration for each frame, in units of centiseconds (hundredths of a second).  However, a `UIImage` only has a single, total `duration` property, which is a floating-point number.
 
 To handle this mismatch, I add each source image (from the GIF) to `animation` a varying number of times to match the ratios between the frame durations in the GIF.
 
 For example, suppose the GIF contains three frames.  Frame 0 has duration 3.  Frame 1 has duration 9.  Frame 2 has duration 15.  I divide each duration by the greatest common denominator of all the durations, which is 3, and add each frame the resulting number of times.  Thus `animation` will contain frame 0 3/3 = 1 time, then frame 1 9/3 = 3 times, then frame 2 15/3 = 5 times.  I set `animation.duration` to (3+9+15)/100 = 0.27 seconds.
 */
+ (UIImage * _Nullable)animatedImageWithAnimatedGIFData:(NSData * _Nonnull)theData;

/*
 UIImage *image = [UIImage animatedImageWithAnimatedGIFURL:theURL];
 
 I interpret the contents of `theURL` as a GIF.  I create an animated `UIImage` using the source images in the GIF.
 
 I operate exactly like `+[UIImage animatedImageWithAnimatedGIFData:]`, except that I read the data from `theURL`.  If `theURL` is not a `file:` URL, you probably want to call me on a background thread or GCD queue to avoid blocking the main thread.
 */
+ (UIImage * _Nullable)animatedImageWithAnimatedGIFURL:(NSURL * _Nonnull)url;

+ (UIImage * _Nullable)animatedImageWithAnimatedGIFName:(NSString * _Nonnull)name;

+ (UIImage * _Nullable)drawText:(NSString * _Nonnull)text inImage:(UIImage * _Nonnull)image atPoint:(CGPoint)point;

@end


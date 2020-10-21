//
//  NSGIF.h
//
//  Created by Sebastian Dobrincu
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>

#if TARGET_OS_IPHONE
    #import <MobileCoreServices/MobileCoreServices.h>
    #import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
    #import <CoreServices/CoreServices.h>
    #import <WebKit/WebKit.h>
#endif

@interface NSGIF : NSObject
/**videoURL生成GIFURL 是否循环*/
+ (void)optimalGIFfromURL:(NSURL*)videoURL loopCount:(int)loopCount completion:(void(^)(NSURL *GifURL))completionBlock;
/**videoURL生成GIFURL  多少帧每秒 时间间隔 是否循环 */
+ (void)createGIFfromURL:(NSURL*)videoURL withFrameCount:(int)frameCount delayTime:(float)delayTime loopCount:(int)loopCount completion:(void(^)(NSURL *GifURL))completionBlock;

@end

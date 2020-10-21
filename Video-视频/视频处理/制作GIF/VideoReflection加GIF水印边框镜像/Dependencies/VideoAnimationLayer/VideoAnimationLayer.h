//
//  VideoAnimationLayer
//  VideoReflection
//
//  Created by Johnny Xu(徐景周) on 5/22/15.
//  Copyright (c) 2015 Future Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface VideoAnimationLayer : CALayer
{
}

@property (nonatomic,strong) NSString *videoFilePath;

+ (VideoAnimationLayer *)sharedInstance;

+ (id)layerWithVideoFilePath:(NSString *)filePath withFrame:(CGRect)frame;
- (void)startAnimation;

- (CGFloat)captureVideoSample:(NSURL *)videoURL saveToCGImage:(BOOL)saveToCGImage;
- (NSMutableArray *)getImageVideoFrames;
- (CGFloat)getVideoDuration;

@end


#import <QuartzCore/QuartzCore.h>

@interface GifAnimationLayer : CALayer

+ (id)layerWithGifFilePath:(NSString *)filePath withFrame:(CGRect)frame;

- (void)startAnimating;
- (void)stopAnimating;
- (void)pauseAnimating;
- (void)resumeAnimating;

@property (nonatomic,strong) NSString *gifFilePath;

@end

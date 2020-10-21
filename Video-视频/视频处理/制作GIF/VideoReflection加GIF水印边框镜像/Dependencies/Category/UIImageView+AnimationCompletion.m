
#import "UIImageView+AnimationCompletion.h"
#import <objc/runtime.h>

#define BLOCK_KEY @"BLOCK_KEY"
#define CONTENTS  @"contents"

#define DEFAULT_FRAME_INTERVAL 6  // 60/DEFAULT_FRAME_INTERVAL frames/sec

static size_t frameIndex, frameCount;

@implementation UIImageView (AnimationCompletion)

- (void)setblock:(Block)block
{
    objc_setAssociatedObject(self, (__bridge const void *)(BLOCK_KEY), block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (Block)block
{
    return objc_getAssociatedObject(self, (__bridge const void *)(BLOCK_KEY));
}

- (void)setupTimer
{
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startPlay)];
    displayLink.frameInterval = DEFAULT_FRAME_INTERVAL;
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)startAnimatingWithCompletionBlock:(Block)block
{
//    self.layer.cornerRadius = CGRectGetWidth(self.frame)/2;
    self.layer.borderWidth = 3.0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.masksToBounds = YES;
    
    [self setblock:block];
    frameCount = [self.animationImages count];
    [self initDisplay];
    [self setupTimer];
    
//    [self startAnimatingWithCGImages:getCGImagesArray(self.animationImages) CompletionBlock:block];
}

- (void)initDisplay
{
    self.layer.contents = (id)[self.animationImages[0] CGImage];
}

- (void)startPlay
{
    frameIndex++;
    if (frameIndex > frameCount)
    {
        frameIndex = 0;
    }
    
    frameIndex = frameIndex % frameCount;
    self.layer.contents = (id)[self.animationImages[frameIndex] CGImage];
}

- (void)startAnimatingWithCGImages:(NSArray*)cgImages CompletionBlock:(Block)block
{
    [self setblock:block];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    [anim setKeyPath:CONTENTS];
    [anim setValues:cgImages];
    [anim setRepeatCount:self.animationRepeatCount];
    [anim setDuration:self.animationDuration];
    anim.delegate = self;
    
    CALayer *ImageLayer = self.layer;
    [ImageLayer addAnimation:anim forKey:nil];
}

NSArray* getCGImagesArray(NSArray* UIImagesArray)
{
    NSMutableArray* cgImages;
    @autoreleasepool
    {
        cgImages = [[NSMutableArray alloc] init];
        for (UIImage* image in UIImagesArray)
            [cgImages addObject:(id)image.CGImage];
    }
    
    return cgImages;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
   Block block_ = [self block];
    if (block_)
        block_(flag);
}

@end

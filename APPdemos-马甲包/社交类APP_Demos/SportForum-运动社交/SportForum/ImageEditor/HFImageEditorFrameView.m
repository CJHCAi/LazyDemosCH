#import "HFImageEditorFrameView.h"
#import "QuartzCore/QuartzCore.h"


@interface HFImageEditorFrameView ()
@property (nonatomic,retain) UIImageView *imageView;
@end

@implementation HFImageEditorFrameView

@synthesize cropRect = _cropRect;
@synthesize imageView  = _imageView;


- (void) initialize
{
    self.opaque = NO;
    self.layer.opacity = 0.7;
    self.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:imageView];
    self.imageView = imageView;
    [imageView release];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initialize];
    }
    return self;
}

- (void)dealloc
{
    [_imageView release];
    [super dealloc];
}


- (void)setCropRect:(CGRect)cropRect
{
    if(!CGRectEqualToRect(_cropRect,cropRect)){
        _cropRect = cropRect;
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor blackColor] setFill];
        UIRectFill(self.bounds);
        CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor);
        CGContextStrokeRect(context, _cropRect);
        [[UIColor clearColor] setFill];
        UIRectFill(CGRectInset(_cropRect, 1, 1));
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();
    }
}

/*
- (void)drawRect:(CGRect)rect
{
   CGContextRef context = UIGraphicsGetCurrentContext();

    [[UIColor blackColor] setFill];
    UIRectFill(rect);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor);
    CGContextStrokeRect(context, self.cropRect);
    [[UIColor clearColor] setFill];
    UIRectFill(CGRectInset(self.cropRect, 1, 1));

}
*/

@end

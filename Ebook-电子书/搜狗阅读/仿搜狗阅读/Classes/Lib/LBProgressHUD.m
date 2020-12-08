//
//  LBProgressHUD.m
//  LuckyBuy
//
//  Created by huangtie on 16/3/9.
//  Copyright © 2016年 Qihoo. All rights reserved.
//

#import "LBProgressHUD.h"
#import <CoreText/CoreText.h>

#define SIZE_RADIUS_WIDTH 12
#define SIZE_FONT_TIP 12

#define TIP_DEFULT_TEXT  @""

#define KEY_ANIMATION_ROTATE @"KEY_ANIMATION_ROTATE"
#define KEY_ANIMATION_TEXT @"KEY_ANIMATION_TEXT"

@interface LBProgressHUD()

@property (nonatomic , strong) UIView *toast;

@property (nonatomic , strong) UIView *rotateView;

@property (nonatomic , strong) CAShapeLayer *rotateLayer;

@property (nonatomic , strong) CAShapeLayer *textLayer;
@end

@implementation LBProgressHUD

+ (instancetype)showHUDto:(UIView *)view animated:(BOOL)animated
{
    LBProgressHUD *hud = [[self alloc] initWithView:view];
    [view addSubview:hud];
    [hud show:animated];
    return hud;
}

+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated
{
    NSMutableArray *huds = [NSMutableArray array];
    NSArray *subviews = view.subviews;
    for (UIView *aView in subviews)
    {
        if ([aView isKindOfClass:[LBProgressHUD class]])
        {
            [huds addObject:aView];
        }
    }
    
    for (LBProgressHUD *hud in huds)
    {
        [hud hide:animated];
    }
    return [huds count];
}

- (void)dealloc
{
    
}

static CGFloat toastWidth = 70;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.tipText = TIP_DEFULT_TEXT;
        
        _toast = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - toastWidth) / 2, (self.frame.size.height - toastWidth) / 2 , toastWidth, toastWidth)];
        _toast.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8];
        _toast.layer.cornerRadius = 10;
        _toast.hidden = YES;
        [self addSubview:_toast];
        
        _rotateView = [[UIView alloc] initWithFrame:CGRectMake((_toast.frame.size.width - 2 * SIZE_RADIUS_WIDTH) / 2, (_toast.frame.size.height - 2 * SIZE_RADIUS_WIDTH) / 2 - 5, 2 * SIZE_RADIUS_WIDTH, 2 * SIZE_RADIUS_WIDTH)];
        _rotateView.backgroundColor = [UIColor clearColor];
        [_toast addSubview:_rotateView];
        
        UIBezierPath *pathRotate= [UIBezierPath bezierPathWithArcCenter:CGPointMake(SIZE_RADIUS_WIDTH, SIZE_RADIUS_WIDTH) radius:SIZE_RADIUS_WIDTH startAngle:- M_PI_2 endAngle:(M_PI * 2) * .5 - M_PI_2 clockwise:YES];
        _rotateLayer = [CAShapeLayer layer];
        _rotateLayer.path = pathRotate.CGPath;
        _rotateLayer.fillColor = [UIColor clearColor].CGColor;
        _rotateLayer.strokeColor = [UIColor whiteColor].CGColor;
        _rotateLayer.lineWidth = 3;
        _rotateLayer.lineCap = kCALineCapRound;
        [_rotateView.layer addSublayer:_rotateLayer];
        
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        rotateAnimation.fromValue = @0;
        rotateAnimation.toValue = @(2*M_PI);
        rotateAnimation.duration = 1.3;
        rotateAnimation.repeatCount = HUGE;
        rotateAnimation.removedOnCompletion = NO;
        [_rotateView.layer addAnimation:rotateAnimation forKey:KEY_ANIMATION_ROTATE];
        
        _textLayer = [CAShapeLayer layer];
        _textLayer.fillColor   = [UIColor clearColor].CGColor;
        _textLayer.strokeColor = [UIColor whiteColor].CGColor;
        _textLayer.lineWidth   = 1;
        _textLayer.lineCap = kCALineCapButt;
        [_toast.layer addSublayer:_textLayer];
        
        CABasicAnimation *textAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        textAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        textAnimation.fromValue = @(0);
        textAnimation.toValue = @1;
        textAnimation.duration = 2;
        textAnimation.repeatCount = HUGE;
        textAnimation.removedOnCompletion = NO;
        [_textLayer addAnimation:textAnimation forKey:nil];
        
        self.tipText = TIP_DEFULT_TEXT;
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view
{
    return [self initWithFrame:view.bounds];
}

- (instancetype)initWithWindow:(UIWindow *)window
{
    return [self initWithView:window];
}

#pragma mark SETORGET
- (void)setTipText:(NSString *)tipText
{
    _tipText = tipText;
    
    [self textLayerPath:tipText];
}

- (void)setToastColor:(UIColor *)toastColor
{
    _toastColor = toastColor;
    _toast.backgroundColor = toastColor;
}

- (void)setContentColor:(UIColor *)contentColor
{
    _rotateLayer.strokeColor = contentColor.CGColor;
    _textLayer.strokeColor = contentColor.CGColor;
}

- (void)setShowMask:(BOOL)showMask
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:showMask - .5];
}

- (void)show:(BOOL)animated
{
    self.toast.hidden = NO;
    if (animated)
    {
        self.toast.transform = CGAffineTransformScale(self.transform,0.2,0.2);
        
        [UIView animateWithDuration:.3 animations:^{
            self.toast.transform = CGAffineTransformScale(self.transform,1.05,1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.3 animations:^{
                self.toast.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (void)hide:(BOOL)animated
{
    [UIView animateWithDuration:animated ? .3 : 0 delay:.1 options:UIViewAnimationOptionCurveEaseOut  animations:^{
        self.toast.transform = CGAffineTransformScale(self.transform,1.05,1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:animated ? .3 : 0 animations:^{
            self.toast.transform = CGAffineTransformScale(self.transform,0.2,0.2);
        } completion:^(BOOL finished) {
            [self.rotateView.layer removeAnimationForKey:KEY_ANIMATION_ROTATE];
            [self.textLayer removeAnimationForKey:KEY_ANIMATION_TEXT];
            [self removeFromSuperview];
        }];
    }];
}

#pragma mark Methods
- (UIBezierPath *)textPath:(NSMutableAttributedString *)text
{
    CGMutablePathRef letters = CGPathCreateMutable();
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)text);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
            CGPathAddPath(letters, &t, letter);
            CGPathRelease(letter);
        }
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:letters];
    CGRect boundingBox = CGPathGetBoundingBox(letters);
    CGPathRelease(letters);
    CFRelease(line);
    
    [path applyTransform:CGAffineTransformMakeScale(1.0, -1.0)];
    [path applyTransform:CGAffineTransformMakeTranslation(0.0, boundingBox.size.height)];
    
    return path;
}

- (void)textLayerPath:(NSString *)text
{
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:text];
    [attributed addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SIZE_FONT_TIP] range:NSMakeRange(0, attributed.length)];
    _textLayer.path = [self textPath:attributed].CGPath;
    
    CGFloat width = attributed.size.width + 10;
    CGFloat maxWidth = self.frame.size.width - 100;
    if (width >= _toast.frame.size.width)
    {
        CGRect frame = _toast.frame;
        if (width <= maxWidth)
        {
            frame.size.width = width;
        }
        else
        {
            frame.size.width = maxWidth;
        }
        _toast.frame = frame;
    }
    else
    {
        CGRect frame = _toast.frame;
        frame.size.width = toastWidth;
        _toast.frame = frame;
    }
    _toast.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    _rotateView.center = CGPointMake(_toast.frame.size.width / 2, _rotateView.center.y);
    _textLayer.position = CGPointMake((_toast.frame.size.width - attributed.size.width) / 2, toastWidth - 20);
}


@end

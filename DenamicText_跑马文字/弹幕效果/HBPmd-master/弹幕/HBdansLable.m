//
//  HBdansLable.m
//  弹幕
//
//  Created by 伍宏彬 on 15/10/14.
//  Copyright (c) 2015年 伍宏彬. All rights reserved.
//

#import "HBdansLable.h"

@interface HBdansLable()
{
    HBdansLable *_randomLable;
}

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) BOOL isStar;

@end

@implementation HBdansLable



+ (instancetype)dansLableFrame:(CGRect)frame
{
    HBdansLable *dansLable = [[HBdansLable alloc] initWithFrame:frame];
    return dansLable;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        
        //        self.layer.cornerRadius = self.roundVaule;
        //        self.layer.masksToBounds = YES;
        //
        //        self.layer.borderColor = self.lineColor.CGColor;
        //        self.layer.borderWidth = self.lineWidth;
        
        
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    HBdansLable *dansLable = (HBdansLable *)object;
    
    if ([self.delegate respondsToSelector:@selector(dansLable:isOutScreen:)]) {
        [self.delegate dansLable:dansLable isOutScreen:[self isOutScreen]];
    }
    
    
}
- (void)updateFrame
{
    if (self.isStar)
        self.x -= 1;
}
- (void)starDans
{
    
    self.displayLink.paused = NO;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    self.isStar = YES;
    
}
- (void)stopDans
{
    if (self.displayLink.isPaused) return;
    self.displayLink.paused = YES;
    self.isStar = NO;
    [self.displayLink invalidate];
    self.displayLink = nil;
    
}

- (BOOL)isOutScreen
{
    if (self.x < 0 && ABS(self.x) >= self.width) {
        
        [self stopDans];
        
        return YES;
    }
    
    return NO;
}

#pragma mark - getter
- (CADisplayLink *)displayLink
{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateFrame)];
        _displayLink.frameInterval = 1;
    }
    return _displayLink;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    CGRect contextFrame = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.height)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}
                                             context:nil];
    NSString *str = [NSString stringWithFormat:@"%.f",contextFrame.size.width + 10];
    self.width = [str floatValue];
    self.height = contextFrame.size.height + 6;
    
    [self starDans];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame" context:nil];
}

@end

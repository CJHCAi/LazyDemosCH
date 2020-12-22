//
//  GXFLeftRightReverse.m
//  065-- DouDiZhu
//
//  Created by 顾雪飞 on 17/6/1.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "GXFLeftRightReverse.h"

@interface GXFLeftRightReverse ()

@property (strong, nonatomic) CALayer *reflectedLayer;

@end

@implementation GXFLeftRightReverse

- (id)initWithLayer:(CALayer *)aLayer
{
    self = [super init];
    
    if (self)
    {
        self.needsDisplayOnBoundsChange = YES;
        self.contentsScale = aLayer.contentsScale;
        
        _reflectedLayer = aLayer;
        self.name = [NSString stringWithFormat:@"reflectionLayer%@", aLayer.name];
        
        [self udpateFrame];
    }
    
    return self;
}

- (void)udpateFrame {
    CGRect frame = _reflectedLayer.bounds;
    self.frame = frame;
}


- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
    CGContextTranslateCTM(ctx, self.reflectedLayer.frame.size.width, 0);
    CGContextScaleCTM(ctx, -1.f, 1.f);
    
    [self.reflectedLayer renderInContext:ctx];
    
    CGContextRestoreGState(ctx);
}

@end

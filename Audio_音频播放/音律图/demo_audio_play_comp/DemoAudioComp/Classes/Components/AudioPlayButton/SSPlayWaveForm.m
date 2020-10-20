//
//  SSPlayWaveForm.m
//  AllSoundHere
//
//  Created by SHEN on 2018/9/3.
//  Copyright © 2018年 shj. All rights reserved.
//

#import "SSPlayWaveForm.h"
#import "UIColor+hex.h"

#define MaxPower 20
#define MinPower -30
#define NumCount 10

@interface SSPlayWaveForm()
@property (strong, nonatomic) NSMutableArray *valueList;
@property (strong, nonatomic) CAShapeLayer *drawLayer;
@end

@implementation SSPlayWaveForm

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateLayout];
}

- (void)initData {
    self.valueList = [NSMutableArray array];
    [self clearDraw];
}

- (void)initView {
    [self.layer addSublayer:self.drawLayer];
    self.layer.masksToBounds = YES;
}

- (void)updateLayout {
    self.drawLayer.frame = self.bounds;
}

#pragma mark - Public

- (void)addPower:(CGFloat)power {
    if (self.valueList.count >= NumCount) {
        [self.valueList removeObjectAtIndex:0];
        [self.valueList addObject:[NSNumber numberWithFloat:power]];
    } else {
        [self.valueList addObject:[NSNumber numberWithFloat:power]];
    }
    
    if (self.valueList.count > 2) {
        [self drawBarNow];
    } 
}

- (void)clearDraw {
    [self.valueList removeAllObjects];
    for (int i = 0; i < NumCount; i++) {
        [self.valueList addObject:@(MinPower)];
    }
}

#pragma mark - Private

- (CGFloat)maxValue {
    return  [[self.valueList valueForKeyPath:@"@max.floatValue"] floatValue];
}

- (CGFloat)minValue {
    return  [[self.valueList valueForKeyPath:@"@min.floatValue"] floatValue];
}

- (CGFloat)valuePercentage:(NSNumber *)value max:(CGFloat)max min:(CGFloat)min {
    return  (value.floatValue - min) / (max - min);
}

- (void)drawBarNow {
    CGFloat fullWidth = self.frame.size.width;
    CGFloat fullHeight = self.frame.size.height;
    CGFloat step = fullWidth / NumCount;
    CGFloat max = MaxPower;
    CGFloat min = MinPower;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 第一个值
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat per = [self valuePercentage:self.valueList.firstObject max:max min:min];
    y = fullHeight - fullHeight * per;
    UIBezierPath *barPath = [self barPathAtX:x y:y with:step height:fullHeight * per];
    [path appendPath:barPath];
    
    for (int i = 1; i < self.valueList.count; i++) {
        CGFloat per = [self valuePercentage:self.valueList[i] max:max min:min];
        x = step * i;
        y = MIN(fullHeight - fullHeight * per, fullHeight);
        barPath = [self barPathAtX:x y:y with:step height:fullHeight * per];
        [path appendPath:barPath];
    }
    self.drawLayer.path = path.CGPath;
    self.drawLayer.strokeColor = [UIColor colorWithHex:0xBBDEFB].CGColor;
    self.drawLayer.fillColor = [UIColor colorWithHex:0xBBDEFB].CGColor;
}

- (UIBezierPath *)barPathAtX:(CGFloat)x y:(CGFloat)y with:(CGFloat)width height:(CGFloat)height {
    CGFloat barWidth = width / 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x + barWidth / 2, y, barWidth, height)];
    return path;
}

#pragma mark - Object

- (CAShapeLayer *)drawLayer {
    if (_drawLayer) {
        return _drawLayer;
    }
    _drawLayer = [CAShapeLayer layer];
    return _drawLayer;
}


@end










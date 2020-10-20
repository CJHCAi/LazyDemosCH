//
//  MMImageClipper.m
//  MMImageClipperDemo
//
//  Created by LEA on 2017/7/13.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMImageClipper.h"

@interface MMImageClipper ()
{
    CGPoint lastPoint;
}

@property (nonatomic, strong) NSArray *points;
@property (nonatomic, strong) UIView *activePoint;

@end

@implementation MMImageClipper

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _pointColor = [UIColor whiteColor];
        _sideLineColor = [UIColor clearColor];
        _fillColor = RGBColor(255.0, 255.0, 255.0, 0.4);
    }
    return self;
}

#pragma mark - setter
- (void)setPointNumber:(NSInteger)pointNumber
{
    _pointNumber = pointNumber;
    [self addSidePoint];
}

#pragma mark - 加边界可拖动点
- (void)addSidePoint
{
    if (_pointNumber == 0) {
        return;
    }
    
    NSMutableArray *tmp = [NSMutableArray array];
    float pointsPerSide = 0.0;
    
    if (_pointNumber > 4) {
        pointsPerSide = (_pointNumber-4) /4.0;
    }
    
    // Corner 1
    UIView *point = [self getPointViewAtPoint:CGPointMake(20, 20)];
    [tmp addObject:point];
    [self addSubview:point];
    
    // Upper side
    if (pointsPerSide - (int)pointsPerSide >= 0.25) {
        pointsPerSide ++;
    }
    for (uint i = 0; i < (int)pointsPerSide; i ++)  {
        float x = ((self.frame.size.width - 40) / ((int)pointsPerSide +1)) * (i+1);
        point = [self getPointViewAtPoint:CGPointMake(x + 20, 20)];
        [tmp addObject:point];
        [self addSubview:point];
    }
    if (pointsPerSide - (int)pointsPerSide >= 0.25) {
        pointsPerSide --;
    }
    
    //Corner 2
    point = [self getPointViewAtPoint:CGPointMake(self.frame.size.width - 20, 20)];
    [tmp addObject:point];
    [self addSubview:point];
    
    //Right side
    if (pointsPerSide - (int)pointsPerSide >= 0.5) {
        pointsPerSide ++;
    }
    for (uint i = 0; i < (int)pointsPerSide; i ++) {
        float y = (self.frame.size.height - 40) / ((int)pointsPerSide +1) * (i+1);
        point = [self getPointViewAtPoint:CGPointMake(self.frame.size.width - 20, 20 + y)];
        [tmp addObject:point];
        [self addSubview:point];
    }
    if (pointsPerSide - (int)pointsPerSide >= 0.5) {
        pointsPerSide --;
    }
    
    //Corner 3
    point = [self getPointViewAtPoint:CGPointMake(self.frame.size.width - 20, self.frame.size.height - 20)];
    [tmp addObject:point];
    [self addSubview:point];
    
    //Bottom side
    if (pointsPerSide - (int)pointsPerSide >= 0.75){
        pointsPerSide ++;
    }
    for (uint i = (int)pointsPerSide; i > 0; i -- )  {
        float x = (self.frame.size.width -40) / ((int)pointsPerSide +1) * i;
        point = [self getPointViewAtPoint:CGPointMake(x + 20, self.frame.size.height - 20)];
        [tmp addObject:point];
        [self addSubview:point];
    }
    if (pointsPerSide - (int)pointsPerSide >= 0.75) {
        pointsPerSide --;
    }
    
    //Corner 4
    point = [self getPointViewAtPoint:CGPointMake(20, self.frame.size.height - 20)];
    [tmp addObject:point];
    [self addSubview:point];
    
    //Left side
    for (uint i = pointsPerSide; i > 0; i --)  {
        float y = (self.frame.size.height - 40) / (pointsPerSide +1) * i;
        point = [self getPointViewAtPoint:CGPointMake(20, 20+y)];
        [tmp addObject:point];
        [self addSubview:point];
    }
    self.points = tmp;
}

- (UIView *)getPointViewAtPoint:(CGPoint)point
{
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(point.x - k_POINT_WIDTH/2, point.y - k_POINT_WIDTH/2, k_POINT_WIDTH, k_POINT_WIDTH)];
    pointView.backgroundColor = _pointColor;
    pointView.layer.cornerRadius = k_POINT_WIDTH/2;
    return pointView;
}

#pragma mark - 获取裁剪后的图片
- (UIImage *)getClippedImage:(UIImageView *)imageView
{
    if (self.points.count <= 0)
        return nil;
    
    CGFloat scale = [UIScreen mainScreen].scale;

    NSArray *points = [self getCGPointValues];
    CGRect rect = CGRectZero;
    rect.size = imageView.image.size;
    
    UIBezierPath *aPath;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, scale);
    {
        [[UIColor blackColor] setFill];
        UIRectFill(rect);
        [[UIColor whiteColor] setFill];
        
        aPath = [UIBezierPath bezierPath];
        CGPoint p = [self convertCGPoint:[[points objectAtIndex:0] CGPointValue]
                                fromSize:imageView.frame.size
                                  toSize:imageView.image.size];
        [aPath moveToPoint:CGPointMake(p.x, p.y)];
        for (uint i = 1; i < points.count; i ++)  {
            p = [self convertCGPoint:[[points objectAtIndex:i] CGPointValue]
                            fromSize:imageView.frame.size
                              toSize:imageView.image.size];
            [aPath addLineToPoint:CGPointMake(p.x, p.y)];
        }
        [aPath closePath];
        [aPath fill];
    }
    
    UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale); {
        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage);
        [imageView.image drawAtPoint:CGPointZero];
    }
    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect croppedRect = aPath.bounds;
    croppedRect.origin.y = rect.size.height - CGRectGetMaxY(aPath.bounds);
    croppedRect.origin.x = croppedRect.origin.x*scale;
    croppedRect.origin.y = croppedRect.origin.y*scale;
    croppedRect.size.width = croppedRect.size.width*scale;
    croppedRect.size.height = croppedRect.size.height*scale;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(maskedImage.CGImage, croppedRect);
    maskedImage = [UIImage imageWithCGImage:imageRef];
    return maskedImage;
}

- (NSArray *)getCGPointValues
{
    NSMutableArray *values = [NSMutableArray array];
    for (NSInteger i = 0; i < self.points.count; i ++) {
        UIView *pointView = [self.points objectAtIndex:i];
        CGPoint point = CGPointMake(pointView.frame.origin.x + k_POINT_WIDTH/2, pointView.frame.origin.y + k_POINT_WIDTH/2);
        [values addObject:[NSValue valueWithCGPoint:point]];
    }
    return values;
}

#pragma mark - 重绘
- (void)drawRect:(CGRect)rect
{
    if (!self.points.count) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.frame);
    
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [_sideLineColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, _fillColor.CGColor);
    CGContextBeginPath(context);
    
    UIView *firstPoint = [self.points objectAtIndex:0];
    CGContextMoveToPoint(context, firstPoint.frame.origin.x +k_POINT_WIDTH/2, firstPoint.frame.origin.y +k_POINT_WIDTH/2);
    for (uint i = 1; i < self.points.count; i ++) {
        UIView *point = [self.points objectAtIndex:i];
        CGContextAddLineToPoint(context, point.frame.origin.x + k_POINT_WIDTH/2, point.frame.origin.y + k_POINT_WIDTH/2);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark - 拖动
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationPoint = [[touches anyObject] locationInView:self];
    for (UIView *point in self.points)  {
        CGPoint viewPoint = [point convertPoint:locationPoint fromView:self];
        if ([point pointInside:viewPoint withEvent:event]) {
            self.activePoint = point;
            break;
        }
    }
    lastPoint = locationPoint;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationPoint = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(CGRectMake(k_POINT_WIDTH/2, k_POINT_WIDTH/2, self.width-k_POINT_WIDTH, self.height-k_POINT_WIDTH), locationPoint) == NO) {
        return;
    }
    if (self.activePoint) {
        self.activePoint.frame = CGRectMake(locationPoint.x -k_POINT_WIDTH/2, locationPoint.y -k_POINT_WIDTH/2, k_POINT_WIDTH, k_POINT_WIDTH);
        [self setNeedsDisplay];
    }
    lastPoint = locationPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.activePoint = nil;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.activePoint = nil;
}

#pragma mark - 转换>>支撑方法
+ (CGSize)scaleAspectFromSize:(CGSize)fromSize toSize:(CGSize)toSize
{
    CGFloat scaleFactor = 1.0;
    CGSize scaledSize = toSize;
    CGFloat widthFactor  = toSize.width / fromSize.width;
    CGFloat heightFactor = toSize.height / fromSize.width;
    if (widthFactor < heightFactor) {
        scaleFactor = widthFactor;
    } else {
        scaleFactor = heightFactor;
    }
    scaledSize.height = fromSize.height * scaleFactor;
    scaledSize.width  = fromSize.width * scaleFactor;
    CGFloat temp = 0;
    if (scaledSize.height > toSize.height) {
        temp = scaledSize.height;
        scaledSize.height = toSize.height;
        scaledSize.width = scaledSize.width * toSize.height/temp;
    }
    if (scaledSize.width > toSize.width) {
        temp = scaledSize.width;
        scaledSize.width = toSize.width;
        scaledSize.height =  scaledSize.height * toSize.width/temp;
    }
    return scaledSize;
}

- (CGPoint)convertPoint:(CGPoint)point fromSize:(CGSize)fromSize toSize:(CGSize)toSize;
{
    CGPoint result = CGPointMake((point.x * toSize.width)/fromSize.width, (point.y * toSize.height)/fromSize.height);
    return result;
}

- (CGPoint)convertCGPoint:(CGPoint)point fromSize:(CGSize)fromSize toSize:(CGSize)toSize
{
    point.y = fromSize.height - point.y + _margin;
    point.x -= _margin;
    CGPoint result = CGPointMake((point.x * toSize.width)/fromSize.width, (point.y * toSize.height)/fromSize.height);
    return result;
}

@end

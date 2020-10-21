//
//  CPJClippingPanel.m
//  IOSTestFramework
//
//  Created by shuaizhai on 11/27/15.
//  Copyright © 2015 com.shuaizhai. All rights reserved.
//

#import "CPJClippingPanel.h"

#define CPJ_CLIPPING_LENGTH 100

@interface CPJClippingPanel ()

@end

@implementation CPJClippingPanel

- (instancetype)initWithFrame:(CGRect)frame withGridLayer:(CPJGridLayar *)gridLayer{
    self = [super initWithFrame:frame];
    if(self){
        self.gridLayer = gridLayer;
        self.clipsToBounds = YES;
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initialize];
    }
    return self;
}

- (instancetype)init{
    self = [self init];
    if(self){
        [self initialize];
    }
    return self;
}


- (void)initialize{
    [self addSubview:self.imageView];
    [self.layer addSublayer:self.gridLayer];
    
}


#pragma mark - CPJClippingPanelProtocol

- (void)show{
    [self.gridLayer setNeedsDisplay];
}

- (void)initializeImageViewSize{
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    self.imageView.center = self.center;
}

- (CGRect)handleScaleOverflowWithPoint:(CGPoint)point{
    
    CGRect clippingRect = self.gridLayer.clippingRect;
    UIView *view = self.imageView;
    CGRect frame = view.frame;
    
//    point = CGPointMake((clippingRect.origin.x + clippingRect.size.width)/2, (clippingRect.origin.y + clippingRect.size.height)/2);
    //图片的尺寸小于裁剪框的尺寸
    //
    if(view.frame.size.width <= view.frame.size.height && frame.size.width < clippingRect.size.width){
        float scale = clippingRect.size.width / frame.size.width;
        CGFloat vectorX,vectorY;

        vectorX = (point.x - view.center.x)*scale;
        vectorY = (point.y - view.center.y)*scale;
        view.transform = CGAffineTransformScale(view.transform, scale, scale);
        
        [view setCenter:(CGPoint){(point.x - vectorX) , (point.y - vectorY)}];
    }
    if(view.frame.size.width > view.frame.size.height && frame.size.height < clippingRect.size.height){
        float scale = clippingRect.size.height / frame.size.height;
        CGFloat vectorX,vectorY;
        
        vectorX = (point.x - view.center.x)*scale;
        vectorY = (point.y - view.center.y)*scale;
        view.transform = CGAffineTransformScale(view.transform, scale, scale);
        
        [view setCenter:(CGPoint){(point.x - vectorX) , (point.y - vectorY)}];
    }
    return view.frame;
}

- (CGPoint)handleBorderOverflow{
    CGPoint rightTop, leftBottom, newCenter;
    newCenter = self.imageView.center;
    CGRect clippingRect = self.gridLayer.clippingRect;
    UIView *view = self.imageView;
    rightTop.x = clippingRect.origin.x + clippingRect.size.width - view.frame.size.width/2;
    rightTop.y = clippingRect.origin.y + clippingRect.size.height - view.frame.size.height/2;
    leftBottom.x = clippingRect.origin.x + view.frame.size.width/2;
    leftBottom.y = clippingRect.origin.y + view.frame.size.height/2;
    

    //图片中心点超出x方向的最大值和最小值
    //
    if(view.center.x < rightTop.x){
        newCenter.x = rightTop.x;
    }else if(view.center.x > leftBottom.x){
        newCenter.x = leftBottom.x;
    }
    
    //图片中心点超出y方向的最大值和最小值
    //
    if(view.center.y < rightTop.y){
        newCenter.y = rightTop.y;
    }else if(view.center.y > leftBottom.y){
        newCenter.y = leftBottom.y;
    }
    
    return newCenter;
}

#pragma mark - 辅助方法

/**
 * 给出高度求宽度
 */
- (CGFloat)scaleFitHeight:(CGFloat)height{
    return (self.imageView.frame.size.width / self.imageView.frame.size.height) * height;
}

/**
 * 给出宽度求高度
 */
- (CGFloat)scaleFitWidth:(CGFloat)width {
    return (self.imageView.frame.size.height / self.imageView.frame.size.width) * width;
}

#pragma mark - 懒加载

- (CPJGridLayar *)gridLayer{
    if(!_gridLayer){
        _gridLayer = [[CPJGridLayar alloc] init];
        _gridLayer.frame = self.bounds;
    }
    return _gridLayer;
}

- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

@end



@interface CPJGridLayar ()

@end

@implementation CPJGridLayar

- (instancetype)initWithClippingRect:(CGRect)clippingRect{
    self = [super init];
    if(self){
        self.clippingRect = clippingRect;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)context
{
    CGRect rct = self.bounds;
    CGContextSetFillColorWithColor(context, self.bgColor.CGColor);
    CGContextFillRect(context, rct);
    
    CGContextClearRect(context, self.clippingRect);
    
    CGContextSetStrokeColorWithColor(context, self.gridColor.CGColor);
    CGContextSetLineWidth(context, 1);
    
    rct = self.clippingRect;
    
    CGContextBeginPath(context);
//    CGFloat dW = 0;

//    CGContextMoveToPoint(context, rct.origin.x, rct.origin.y);
//    CGContextAddLineToPoint(context, rct.origin.x, rct.origin.y+rct.size.height);
//    dW = 0;
    CGContextAddRect(context, self.clippingRect);

    CGContextStrokePath(context);
}

#pragma mark - 懒加载

- (UIColor *)gridColor{
    if(!_gridColor){
        _gridColor = [UIColor colorWithWhite:1 alpha:0.8];
    }
    return _gridColor;
}

- (UIColor *)bgColor{
    if(!_bgColor){
        _bgColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
    return _bgColor;
}



- (CGRect)clippingRect{
    if(_clippingRect.size.width == 0 &&_clippingRect.size.height == 0){
        self.clippingRect = CGRectMake( self.frame.size.width/2 - CPJ_CLIPPING_LENGTH/2,
                                       self.frame.size.height/2 - CPJ_CLIPPING_LENGTH/2,
                                       CPJ_CLIPPING_LENGTH,
                                       CPJ_CLIPPING_LENGTH );
    }
    return _clippingRect;
}
@end



@interface CPJClippingCircle ()

@end

@implementation CPJClippingCircle



@end
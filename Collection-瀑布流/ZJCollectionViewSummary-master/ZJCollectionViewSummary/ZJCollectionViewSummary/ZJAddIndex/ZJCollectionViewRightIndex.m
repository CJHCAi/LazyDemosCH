//
//  ZJCollectionViewRightIndex.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/5/28.
//  Copyright © 2018年 James. All rights reserved.
//

#import "ZJCollectionViewRightIndex.h"

@interface ZJCollectionViewRightIndex()
    
@property (nonatomic, assign) BOOL isLayedOut;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, assign) CGFloat letterHeight;

@property (nonatomic, strong) UILabel *flotageLabel;

@end

@implementation ZJCollectionViewRightIndex

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _isSelectVisible = NO;
    }
    
    return self;
}

-(void)setCollectionDelegate:(id<ZJCollectionViewRightIndexDelegate>)collectionDelegate{
    
    _collectionDelegate = collectionDelegate;
    _isLayedOut = NO;  //如果为yes就是超过此layer的部分都裁剪掉，使用圆角的时候常用到
    [self layoutSubviews];
}

/*---setNeedsDisplay会调用自动调用drawRect方法，这样可以拿到UIGraphicsGetCurrentContext，就可以画画了。而setNeedsLayout会默认调用layoutSubViews，就可以处理子视图中的一些数据。
 宗上所诉，setNeedsDisplay方便绘图，而layoutSubViews方便出来数据。
 
 因为这两个方法都是异步执行的，所以一些元素还是直接绘制的好---*/


/*---使用CAShapeLayer与UIBezierPath可以实现不在view的drawRect方法中就画出一些想要的图形---*/

//UIView的setNeedsLayout时会执行此方法
-(void)layoutSubviews{
    
    [super layoutSubviews];
    [self setup];
    
    if (!_isLayedOut) {
        [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        
        _letterHeight = 16;
        CGFloat fontSize = 12;
        
        __weak typeof(self) weakSelf = self;
        [self.titleIndexes enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            CGFloat originY = idx * weakSelf.letterHeight;
            CATextLayer *ctl = [self textLayerWithSize:fontSize
                                                string:obj
                                              andFrame:CGRectMake(0, originY, self.frame.size.width, weakSelf.letterHeight)];
            
            [self.layer addSublayer:ctl];
        }];
        
        _isLayedOut = YES;
    }
}

#pragma mark- 私有方法

//绘制边框线
-(void)setup{
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.lineWidth = 1.0f;
    _shapeLayer.fillColor = [UIColor blackColor].CGColor;
    _shapeLayer.lineJoin = kCALineCapSquare;
    _shapeLayer.strokeColor = [[UIColor blackColor] CGColor];
    _shapeLayer.strokeEnd = 1.0f;
    
    if (!self.color) {
        self.color = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1.0];
    }
    self.layer.masksToBounds = NO;
}


//绘制字体
- (CATextLayer*)textLayerWithSize:(CGFloat)size string:(NSString*)string andFrame:(CGRect)frame{
    CATextLayer *textLayer = [CATextLayer layer];
    [textLayer setFont:@"ArialMT"];
    [textLayer setFontSize:size];
    [textLayer setFrame:frame];
    [textLayer setAlignmentMode:kCAAlignmentCenter];
    [textLayer setContentsScale:[[UIScreen mainScreen] scale]];
    [textLayer setForegroundColor:self.color.CGColor];
    [textLayer setString:string];
    return textLayer;
}

//根据触摸事件的触摸点来算出点击的是第几个section
- (void)sendEventToDelegate:(UIEvent*)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self];
    
    NSInteger indx = ((NSInteger) floorf(point.y) / _letterHeight);
    
    if (indx< 0 || indx > self.titleIndexes.count - 1) {
        return;
    }
    if (self.collectionDelegate && [self.collectionDelegate respondsToSelector:@selector(collectionViewIndex:didselectionAtIndex:withTitle:)]) {
        
        [self.collectionDelegate collectionViewIndex:self didselectionAtIndex:indx withTitle:self.titleIndexes[indx]];
    }
    
    if (self.isSelectVisible) {
        self.flotageLabel.text = self.titleIndexes[indx];
    }
}
#pragma mark- response事件

//开始触摸
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self sendEventToDelegate:event];
    if (self.collectionDelegate && [self.collectionDelegate respondsToSelector:@selector(collectionViewIndexTouchesBegan:)]) {
        [self.collectionDelegate collectionViewIndexTouchesBegan:self];
    }
    
    if (self.isSelectVisible) {
        self.flotageLabel.alpha = 1;
        self.flotageLabel.hidden = NO;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
   
    [self sendEventToDelegate:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.collectionDelegate && [self.collectionDelegate respondsToSelector:@selector(collectionViewIndexTouchesEnd:)]) {
        [self.collectionDelegate collectionViewIndexTouchesEnd:self];
    }
    __weak typeof(self) weakSelf = self;
    
    if (self.isSelectVisible) {
        void (^animation)(void) = ^{
            weakSelf.flotageLabel.alpha = 0;
        };
        
        [UIView animateWithDuration:0.8 animations:animation completion:^(BOOL finished) {
            weakSelf.flotageLabel.hidden = YES;
        }];
    }
}

- (UILabel *)flotageLabel
{
    if (_flotageLabel == nil) {
        _flotageLabel = [[UILabel alloc] initWithFrame:(CGRect){(SCREEN_WIDTH - 64 ) / 2,(SCREEN_HEIGHT - 64) / 2,64,64}];
        _flotageLabel.backgroundColor = [UIColor blackColor];
        _flotageLabel.hidden = YES;
        [_flotageLabel.layer  setCornerRadius:32];
        _flotageLabel.layer.masksToBounds = YES;
        _flotageLabel.textAlignment = NSTextAlignmentCenter;
        _flotageLabel.textColor = [UIColor whiteColor];
        UIWindow *window = [self getLastWindow];
        [window addSubview:_flotageLabel];
    }
    return _flotageLabel;
}

- (UIWindow *)getLastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator])
    {
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            return window;
    }
    return [UIApplication sharedApplication].keyWindow;
}
@end

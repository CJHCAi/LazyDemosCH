//
//  CropperView.m
//  ImageCropper
//
//  Created by Zhuochenming on 16/1/8.
//  Copyright © 2016年 Zhuochenming. All rights reserved.
//

#import "CropperView.h"
#import "OverlayView.h"

typedef NS_ENUM(NSUInteger, OverlayViewPanningMode) {
    OverlayViewPanningModeNone     = 0,
    OverlayViewPanningModeLeft     = 1 << 0,
    OverlayViewPanningModeRight    = 1 << 1,
    OverlayViewPanningModeTop      = 1 << 2,
    OverlayViewPanningModeBottom   = 1 << 3
};

static CGSize const minSize = {40, 40};

@interface CropperView ()

// Remember first touched point
@property (nonatomic, assign) CGPoint firstTouchedPoint;

// Panning mode for oeverlay view
@property (nonatomic, assign) OverlayViewPanningMode OverlayViewPanningMode;

//是否是透明区域
@property (nonatomic, assign) BOOL isCleanRect;
//触摸的是否是透明区域中心,否则是透明区域中心
@property (nonatomic, assign) BOOL isCenterCleanRect;
//焦点透明区域
@property (nonatomic, assign) NSInteger whichRect;
// Current scale (up to 1)
@property (nonatomic, assign) CGFloat currentScale;

// Image view
@property (nonatomic, strong) UIImageView *imageView;

// Minimum size for image, maximum size for overlay
@property (nonatomic, assign) CGRect baseRect;

// Overlay view
@property (nonatomic, strong) OverlayView *overlayView;

@property (nonatomic, strong) NSMutableArray *rectArray;

@end

@implementation CropperView

- (instancetype)initWithFrame:(CGRect)frame
              image:(UIImage *)image
          rectArray:(NSArray *)rectArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.image = image;
        self.whichRect = 0;
        
        self.imageView = [[UIImageView alloc] initWithImage:image];
        
        CGRect rect;
        rect.size = [self getImageSizeForPreview:image];
        rect.origin = CGPointMake((frame.size.width - rect.size.width) / 2.0, (frame.size.height - rect.size.height) / 2.0);
        
        self.imageView.frame = rect;
        
        self.baseRect = self.imageView.frame;
        
        [self addSubview:_imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:panGestureRecognizer];
        
        // 蒙板
        self.overlayView = [[OverlayView alloc] initWithFrame:self.frame];
        self.overlayView.rectArray = [NSMutableArray arrayWithArray:rectArray];
        
        for (int i = 0; i < rectArray.count; i++) {
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectFromString(rectArray[i])];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.font = [UIFont systemFontOfSize:15];
            lable.text = @"小七说：";
            lable.tag = 1000 + i;
            lable.textColor = [UIColor redColor];
            [self.overlayView addSubview:lable];
        }

        [self addSubview:_overlayView];
        self.overlayView.whichRect = 0;
        [self.overlayView setNeedsDisplay];
    }
    return self;
}

- (void)addCropRect:(CGRect)rect {
    
    UILabel *lable = [[UILabel alloc] initWithFrame:rect];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:15];
    lable.text = @"我是大逗比";
    lable.textColor = [UIColor redColor];
    lable.tag = self.overlayView.rectArray.count + 1000;
    [self.overlayView addSubview:lable];
    
    [self.overlayView.rectArray addObject:NSStringFromCGRect(rect)];
    [self.overlayView setNeedsDisplay];
}

- (void)removeCropRectByIndex:(NSInteger)index {
    
    UILabel *lable = [self.overlayView viewWithTag:1000 + index];
    [lable removeFromSuperview];
    
    self.overlayView.whichRect = 0;
    [self.overlayView.rectArray removeObjectAtIndex:index];
    [self.overlayView setNeedsDisplay];
}

#pragma mark - 获取图片
- (NSArray *)cropedImageArray {
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:0];
    CGFloat scale = self.image.size.width / self.imageView.frame.size.width;
    CGRect rect;
    
    for (int i = 0; i < self.overlayView.rectArray.count; i++) {
        rect = CGRectFromString(self.overlayView.rectArray[i]);
        [mArray addObject:[self cropImageWithScale:scale Rect:rect]];
    }
    return mArray;
}

- (UIImage *)cropImageWithScale:(CGFloat)scale
                           Rect:(CGRect)rect {
    rect.origin.x = (rect.origin.x - self.imageView.frame.origin.x) * scale;
    rect.origin.y = (rect.origin.y - self.imageView.frame.origin.y) * scale;
    rect.size.width *= scale;
    rect.size.height *= scale;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextClipToRect(c, CGRectMake(0, 0, rect.size.width, rect.size.height));
    [self.image drawInRect:CGRectMake(-rect.origin.x, -rect.origin.y, self.image.size.width, self.image.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (CGSize)getImageSizeForPreview:(UIImage *)image {
    CGFloat maxWidth = self.frame.size.width, maxHeight = self.frame.size.height;
    
    CGSize size = image.size;
    
    if (size.width > maxWidth) {
        size.height *= (maxWidth / size.width);
        size.width = maxWidth;
    }
    
    if (size.height > maxHeight) {
        size.width *= (maxHeight / size.height);
        size.height = maxHeight;
    }
    
    if (size.width < minSize.width) {
        size.height *= (minSize.width / size.width);
        size.width = minSize.width;
    }
    
    if (size.height < minSize.height) {
        size.width *= (minSize.height / size.height);
        size.height = minSize.height;
    }
    return size;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if ([touches count] == 1) {
        self.firstTouchedPoint = [(UITouch *)[touches anyObject] locationInView:self];
    }
}

#pragma mark - 点击手势响应
- (void)tapGesture:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:sender.view];
    CGFloat lastRect = self.whichRect;
    NSInteger maxCount = 0;
    for (int i = 0; i < self.overlayView.rectArray.count; i++) {
        CGRect storeRect = self.overlayView.clearRect;
        self.overlayView.clearRect = CGRectFromString(self.overlayView.rectArray[i]);
        if ([self.overlayView isInRectPoint:point]) {
            self.whichRect = i;
            self.overlayView.whichRect = i;
            maxCount += 1;
        }
        if ([self.overlayView isCornerContainsPoint:point] || [self.overlayView isEdgeContainsPoint:point]) {
            self.whichRect = i;
            self.overlayView.whichRect = i;
            maxCount += 1;
        }
        self.overlayView.clearRect = storeRect;
    }
    if (maxCount == 2) {
        self.whichRect = lastRect;
        self.overlayView.whichRect = lastRect;
    }
    [self.overlayView setNeedsDisplay];
}

#pragma mark - 拖动手势响应
- (void)panGesture:(UIPanGestureRecognizer *)sender {
    NSInteger lastRect = self.whichRect;
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint point = self.firstTouchedPoint;
        
        NSInteger centerCount = 0;
        NSInteger edgeCount = 0;
        NSInteger maxCount = 0;
        for (int i = 0; i < self.overlayView.rectArray.count; i++) {
            CGRect storeRect = self.overlayView.clearRect;
            self.overlayView.clearRect = CGRectFromString(self.overlayView.rectArray[i]);
            if ([self.overlayView isInRectPoint:point]) {
                self.whichRect = i;
                self.overlayView.whichRect = i;
                centerCount += 1;
                maxCount += 1;
            }
            if ([self.overlayView isCornerContainsPoint:point] || [self.overlayView isEdgeContainsPoint:point]) {
                self.whichRect = i;
                self.overlayView.whichRect = i;
                edgeCount += 1;
                maxCount += 1;
                self.OverlayViewPanningMode = [self getOverlayViewPanningModeByPoint:point];
            }
            self.overlayView.clearRect = storeRect;
        }
        
        if (centerCount + edgeCount == 0) {
            self.isCleanRect = NO;
        } else {
            self.isCleanRect = YES;
            if (edgeCount > 0) {
                self.isCenterCleanRect = NO;
            } else {
                self.isCenterCleanRect = YES;
            }
        }
        
#pragma mark - 激活透明区域
        if (maxCount == 2) {
            self.whichRect = lastRect;
            self.overlayView.whichRect = lastRect;
            CGRect storeRect = self.overlayView.clearRect;
            self.overlayView.clearRect = CGRectFromString(self.overlayView.rectArray[self.whichRect]);
            if ([self.overlayView isInRectPoint:point]) {
                self.isCenterCleanRect = YES;
            } else {
                self.isCenterCleanRect = NO;
                self.OverlayViewPanningMode = [self getOverlayViewPanningModeByPoint:point];
            }
            self.overlayView.clearRect = storeRect;
        }
    }
    
    if (self.isCleanRect) {
        CGRect storeRect = self.overlayView.clearRect;
        NSString *rectString = self.overlayView.rectArray[self.whichRect];
        self.overlayView.clearRect = CGRectFromString(rectString);
        
        if (self.isCenterCleanRect) {
            [self panCenterOverlayView:sender];
        } else {
            [self panEdgeOverlayView:sender];
        }
        
        self.overlayView.clearRect = storeRect;
    } else {
        //        [self panImage:sender];
    }
    // Reset points
    
    [sender setTranslation:CGPointZero inView:self];
}

#pragma mark - 蒙板手势响应
- (void)panEdgeOverlayView:(UIPanGestureRecognizer *)sender {
    CGPoint d = [sender translationInView:self];
    CGRect oldClearRect = self.overlayView.clearRect;
    CGRect newClearRect = self.overlayView.clearRect;
    if (self.OverlayViewPanningMode & OverlayViewPanningModeLeft) {
        newClearRect.origin.x += d.x;
        newClearRect.size.width -= d.x;
    } else if (self.OverlayViewPanningMode & OverlayViewPanningModeRight) {
        newClearRect.size.width += d.x;
    }
    
    if (self.OverlayViewPanningMode & OverlayViewPanningModeTop) {
        newClearRect.origin.y += d.y;
        newClearRect.size.height -= d.y;
    } else if (self.OverlayViewPanningMode & OverlayViewPanningModeBottom) {
        newClearRect.size.height += d.y;
    }
    
    self.overlayView.clearRect = newClearRect;
    
    // Check x
    if ([self shouldRevertX]) {
        newClearRect.origin.x = oldClearRect.origin.x;
        newClearRect.size.width = oldClearRect.size.width;
    }
    
    // Check y
    if ([self shouldRevertY]) {
        newClearRect.origin.y = oldClearRect.origin.y;
        newClearRect.size.height = oldClearRect.size.height;
    }
    
    [self.overlayView.rectArray removeObjectAtIndex:self.whichRect];
    [self.overlayView.rectArray insertObject:NSStringFromCGRect(newClearRect) atIndex:self.whichRect];
    
    //控制clearrect的lable的frame
    UILabel *lable = [self.overlayView viewWithTag:_whichRect + 1000];
    lable.frame = newClearRect;
    
    [self.overlayView setNeedsDisplay];
}

- (void)panCenterOverlayView:(UIPanGestureRecognizer *)sender {
    CGPoint d = [sender translationInView:self];
    CGRect newClearRect = self.overlayView.clearRect;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = CGRectGetHeight(_imageView.frame) + CGRectGetMinY(_imageView.frame);
    
    newClearRect.origin.x += d.x;
    newClearRect.origin.y += d.y;
    
    if (newClearRect.origin.x <= 0) {
        newClearRect.origin.x = 0;
    } else if (newClearRect.origin.x + newClearRect.size.width >= width) {
        newClearRect.origin.x = width - newClearRect.size.width;
    }
    
    if (newClearRect.origin.y <= CGRectGetMinY(_imageView.frame)) {
        newClearRect.origin.y = CGRectGetMinY(_imageView.frame);
    } else if (newClearRect.origin.y + newClearRect.size.height >= height) {
        newClearRect.origin.y = height - newClearRect.size.height;
    }
    
    [self.overlayView.rectArray removeObjectAtIndex:self.whichRect];
    [self.overlayView.rectArray insertObject:NSStringFromCGRect(newClearRect) atIndex:self.whichRect];
    
    //控制clearrect的lable的frame
    UILabel *lable = [self.overlayView viewWithTag:_whichRect + 1000];
    lable.frame = newClearRect;
    
    [self.overlayView setNeedsDisplay];
}

#pragma mark - 蒙板手势状态
- (OverlayViewPanningMode)getOverlayViewPanningModeByPoint:(CGPoint)point {
    if (CGRectContainsPoint(self.overlayView.topLeftCorner, point)) {
        return (OverlayViewPanningModeLeft | OverlayViewPanningModeTop);
    } else if (CGRectContainsPoint(self.overlayView.topRightCorner, point)) {
        return (OverlayViewPanningModeRight | OverlayViewPanningModeTop);
    } else if (CGRectContainsPoint(self.overlayView.bottomLeftCorner, point)) {
        return (OverlayViewPanningModeLeft | OverlayViewPanningModeBottom);
    } else if (CGRectContainsPoint(self.overlayView.bottomRightCorner, point)) {
        return (OverlayViewPanningModeRight | OverlayViewPanningModeBottom);
    } else if (CGRectContainsPoint(self.overlayView.topEdgeRect, point)) {
        return OverlayViewPanningModeTop;
    } else if (CGRectContainsPoint(self.overlayView.rightEdgeRect, point)) {
        return OverlayViewPanningModeRight;
    } else if (CGRectContainsPoint(self.overlayView.bottomEdgeRect, point)) {
        return OverlayViewPanningModeBottom;
    } else if (CGRectContainsPoint(self.overlayView.leftEdgeRect, point)) {
        return OverlayViewPanningModeLeft;
    }
    return OverlayViewPanningModeNone;
}

- (BOOL)shouldRevertX {
    CGRect clearRect = self.overlayView.clearRect;
    CGRect imageRect = self.imageView.frame;
    
    if (CGRectGetMinX(imageRect) > CGRectGetMinX(clearRect)
        || CGRectGetMaxX(imageRect) < CGRectGetMaxX(clearRect)) {
        return YES;
    }
    
    if (CGRectGetMinX(clearRect) < CGRectGetMinX(self.baseRect)
        || CGRectGetMaxX(clearRect) > CGRectGetMaxX(self.baseRect)) {
        return YES;
    }
    
    if (clearRect.size.width < minSize.width) {
        return YES;
    }
    
    return NO;
}

- (BOOL)shouldRevertY {
    CGRect clearRect = self.overlayView.clearRect;
    CGRect imageRect = self.imageView.frame;
    
    if (CGRectGetMinY(imageRect) > CGRectGetMinY(clearRect)
        || CGRectGetMaxY(imageRect) < CGRectGetMaxY(clearRect)) {
        return YES;
    }
    
    if (CGRectGetMinY(clearRect) < CGRectGetMinY(self.baseRect)
        || CGRectGetMaxY(clearRect) > CGRectGetMaxY(self.baseRect)) {
        return YES;
    }
    
    if (clearRect.size.height < minSize.height) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 图片手势响应事件
- (void)panImage:(UIPanGestureRecognizer *)sender {
    CGPoint d = [sender translationInView:self];
    CGPoint newCenter = CGPointMake(self.imageView.center.x + d.x,
                                    self.imageView.center.y + d.y);
    self.imageView.center = newCenter;
    
    // Check x
    if ([self shouldRevertX]) {
        newCenter.x -= d.x;
    }
    
    // Check y
    if ([self shouldRevertY]) {
        newCenter.y -= d.y;
    }
    
    self.imageView.center = newCenter;
}

- (void)pinchGesture:(UIPinchGestureRecognizer *)sender {
    CGFloat newScale = self.currentScale * sender.scale;
    CGRect oldImageFrame = self.imageView.frame;
    CGSize newSize = CGSizeMake(newScale * self.baseRect.size.width,
                                newScale * self.baseRect.size.height);
    
    // Update frame
    CGRect newFrame = self.imageView.frame;
    newFrame.size = newSize;
    self.imageView.frame = newFrame;
    
    // Move center
    CGPoint d = CGPointMake((oldImageFrame.size.width - newFrame.size.width) / 2.0f,
                            (oldImageFrame.size.height - newFrame.size.height) / 2.0f);
    self.imageView.center = CGPointMake(self.imageView.center.x + d.x,
                                        self.imageView.center.y + d.y);
    
    if (([self shouldRevertX] || [self shouldRevertY])) {
        self.imageView.frame = oldImageFrame;
    } else {
        self.currentScale = newScale;
    }
    
    // Reset scale
    sender.scale = 1;
}


@end

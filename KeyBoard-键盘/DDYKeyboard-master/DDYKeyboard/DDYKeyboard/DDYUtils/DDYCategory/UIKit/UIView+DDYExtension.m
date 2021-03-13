#import "UIView+DDYExtension.h"
#import <objc/runtime.h> 

@implementation UIView (DDYExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self changeOrignalSEL:@selector(hitTest:withEvent:) swizzleSEL:@selector(ddy_HitTest:withEvent:)];
    });
}

+ (void)changeOrignalSEL:(SEL)orignalSEL swizzleSEL:(SEL)swizzleSEL {
    Method originalMethod = class_getInstanceMethod([self class], orignalSEL);
    Method swizzleMethod = class_getInstanceMethod([self class], swizzleSEL);
    if (class_addMethod([self class], orignalSEL, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod))) {
        class_replaceMethod([self class], swizzleSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
}

#pragma mark - 布局
#pragma mark x的setter和getter方法
- (void)setDdy_X:(CGFloat)ddy_X {
    CGRect frame = self.frame;
    frame.origin.x = ddy_X;
    self.frame = frame;
}

- (CGFloat)ddy_X {
    return self.frame.origin.x;
}

- (void)setDdy_Left:(CGFloat)ddy_Left {
    [self setDdy_X:ddy_Left];
}

- (CGFloat)ddy_Left {
    return [self ddy_X];
}

#pragma mark y的setter和getter方法
- (void)setDdy_Y:(CGFloat)ddy_Y {
    CGRect frame = self.frame;
    frame.origin.y = ddy_Y;
    self.frame = frame;
}

- (CGFloat)ddy_Y {
    return self.frame.origin.y;
}

- (void)setDdy_Top:(CGFloat)ddy_Top {
    [self setDdy_Y:ddy_Top];
}

- (CGFloat)ddy_Top {
    return [self ddy_Y];
}

#pragma mark width的setter和getter方法
- (void)setDdy_W:(CGFloat)ddy_W {
    CGRect frame = self.frame;
    frame.size.width = ddy_W;
    self.frame = frame;
}

- (CGFloat)ddy_W {
    return self.frame.size.width;
}

#pragma mark height的setter和getter方法
- (void)setDdy_H:(CGFloat)ddy_H {
    CGRect frame = self.frame;
    frame.size.height = ddy_H;
    self.frame = frame;
}
- (CGFloat)ddy_H {
    return self.frame.size.height;
}
#pragma mark centerX的setter和getter方法
- (void)setDdy_CenterX:(CGFloat)ddy_CenterX {
    CGPoint center = self.center;
    center.x = ddy_CenterX;
    self.center = center;
}

- (CGFloat)ddy_CenterX {
    return self.center.x;
}

#pragma mark centerY的setter和getter方法
- (void)setDdy_CenterY:(CGFloat)ddy_CenterY {
    CGPoint center = self.center;
    center.y = ddy_CenterY;
    self.center = center;
}

- (CGFloat)ddy_CenterY {
    return self.center.y;
}

#pragma mark 右边到 x 轴距离
- (void)setDdy_Right:(CGFloat)ddy_Right {
    CGRect frame = self.frame;
    frame.origin.x = ddy_Right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)ddy_Right
{
    return self.frame.origin.x + self.frame.size.width;
    
}
#pragma mark 底边到 y 轴距离
- (void)setDdy_Bottom:(CGFloat)ddy_Bottom {
    CGRect frame = self.frame;
    frame.origin.y = ddy_Bottom - frame.size.height;
    self.frame = frame;
}

-(CGFloat)ddy_Bottom {
    return self.frame.origin.y + self.frame.size.height;
}

#pragma mark size的setter和getter方法
- (void)setDdy_Size:(CGSize)ddy_Size {
    CGRect frame = self.frame;
    frame.size = ddy_Size;
    self.frame = frame;
}

- (CGSize)ddy_Size {
    return self.frame.size;
}

#pragma mark origin的setter和getter方法
- (void)setDdy_Origin:(CGPoint)ddy_Origin {
    CGRect frame = self.frame;
    frame.origin = ddy_Origin;
    self.frame = frame;
}

- (CGPoint)ddy_Origin {
    return self.frame.origin;
}

#pragma mark - 手势
#pragma mark 点击手势
- (UITapGestureRecognizer *)ddy_AddTapTarget:(id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
    return tap;
}

#pragma mark 点击手势 + 代理
- (UITapGestureRecognizer *)ddy_AddTapTarget:(id)target action:(SEL)action delegate:(id)delegate {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tap.delegate = delegate;
    [self addGestureRecognizer:tap];
    return tap;
}

#pragma mark 点击手势 + 点击数
- (UITapGestureRecognizer *)ddy_AddTapTarget:(id)target action:(SEL)action number:(NSInteger)number {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tap.numberOfTapsRequired = number;
    [self addGestureRecognizer:tap];
    return tap;
}

#pragma mark 点击手势 + 点击数 + 代理
- (UITapGestureRecognizer *)ddy_AddTapTarget:(id)target action:(SEL)action number:(NSInteger)number  delegate:(id)delegate {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tap.numberOfTapsRequired = number;
    tap.delegate = delegate;
    [self addGestureRecognizer:tap];
    return tap;
}

#pragma mark 长按手势
- (UILongPressGestureRecognizer *)ddy_AddLongGestureTarget:(id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:target action:action];
    [self addGestureRecognizer:longGes];
    return longGes;
}

#pragma mark 长按手势 + 长按最短时间
- (UILongPressGestureRecognizer *)ddy_AddLongGestureTarget:(id)target action:(SEL)action minDuration:(CFTimeInterval)minDuration {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:target action:action];
    longGes.minimumPressDuration = minDuration;
    [self addGestureRecognizer:longGes];
    return longGes;
}

#pragma mark 拖动手势
- (UIPanGestureRecognizer *)ddy_AddPanGestureTarget:(id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:panGes];
    return panGes;
}

#pragma mark 拖动手势 + 代理
- (UIPanGestureRecognizer *)ddy_AddPanGestureTarget:(id)target action:(SEL)action delegate:(id)delegate {
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
    panGesture.delegate = delegate;
    [self addGestureRecognizer:panGesture];
    return panGesture;
}

#pragma mark - 截屏
#pragma mark 截屏生成图片
- (UIImage *)ddy_SnapshotImage {
    UIGraphicsBeginImageContext(self.bounds.size);
    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    } else{
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    image = [UIImage imageWithData:imageData];
    return image;
}

#pragma mark 截屏生成PDF
- (NSData *)ddy_SnapshotPDF {
    CGRect bounds = self.bounds;
    NSMutableData* data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

#pragma mark 整个截屏 
+ (UIImage *)ddy_ScreenshotInPNGFormat {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGSize imageSize = UIInterfaceOrientationIsPortrait(orientation) ? [UIScreen mainScreen].bounds.size : CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in UIApplication.sharedApplication.windows) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIImage imageWithData:UIImagePNGRepresentation(image)];
}

#pragma mark - UI
#pragma mark 阴影
- (void)ddy_LayerShadow:(UIColor *)color offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

#pragma mark 部分圆角 UIRectCornerBottomLeft | UIRectCornerBottomRight
- (void)ddy_RoundCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)].CGPath;
    self.layer.mask = maskLayer;
}

#pragma mark - 功能
#pragma mark 移除所有子视图
- (void)ddy_RemoveAllChildView {
    if (self.subviews.count) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

#pragma mark 根据tag找到某个子视图
- (nullable id)ddy_SubviewWithTag:(NSInteger)tag {
    for(UIView *view in [self subviews]){
        if(view.tag == tag){
            return view;
        }
    }
    return nil;
}

#pragma mark 找到视图所在视图控制器
- (UIViewController *)ddy_GetViewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (UIViewController *)ddy_GetResponderViewController {
    UIViewController *responderViewController = nil;
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (keyWindow.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tempWindow in windows) {
            if (tempWindow.windowLevel == UIWindowLevelNormal) {
                keyWindow = tempWindow;
                break;
            }
        }
    }
    UIView *frontView = [[keyWindow subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        responderViewController = nextResponder;
    } else {
        UIViewController *topVC = keyWindow.rootViewController.presentedViewController;
        if (topVC) {
            responderViewController = topVC;
        } else {
            responderViewController = keyWindow.rootViewController;
        }
    }
    return responderViewController;
}

#pragma mark 本视图上的点坐标在某个view上的相对坐标
- (CGPoint)ddy_ConvertPoint:(CGPoint)point toView:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point toWindow:nil];
        } else {
            return [self convertPoint:point toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point toView:view];
    point = [self convertPoint:point toView:from];
    point = [to convertPoint:point fromWindow:from];
    point = [view convertPoint:point fromView:to];
    return point;
}

#pragma mark 某个view上的点坐标在本视图上的相对坐标
- (CGPoint)ddy_ConvertPoint:(CGPoint)point fromView:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point fromWindow:nil];
        } else {
            return [self convertPoint:point fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point fromView:view];
    point = [from convertPoint:point fromView:view];
    point = [to convertPoint:point fromWindow:from];
    point = [self convertPoint:point fromView:to];
    return point;
}

#pragma mark 本视图上的rect在某个view上的相对rect
- (CGRect)ddy_ConvertRect:(CGRect)rect toView:(nullable UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect toWindow:nil];
        } else {
            return [self convertRect:rect toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if (!from || !to) return [self convertRect:rect toView:view];
    if (from == to) return [self convertRect:rect toView:view];
    rect = [self convertRect:rect toView:from];
    rect = [to convertRect:rect fromWindow:from];
    rect = [view convertRect:rect fromView:to];
    return rect;
}

#pragma mark 某个view上的rect在本视图上的相对rect
- (CGRect)ddy_ConvertRect:(CGRect)rect fromView:(nullable UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect fromWindow:nil];
        } else {
            return [self convertRect:rect fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertRect:rect fromView:view];
    rect = [from convertRect:rect fromView:view];
    rect = [to convertRect:rect fromWindow:from];
    rect = [self convertRect:rect fromView:to];
    return rect;
}

- (UIView *)ddy_HitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [self ddy_HitTest:point withEvent:event];
    if (self.isShowHitTestLog && view) {
        NSLog(@"  UIView+DDYExtension:%d %s [self class]%@ [hitView class]:%@", __LINE__, __FUNCTION__, [self class], [view class]);
    }
    return view;
}

- (BOOL)isShowHitTestLog {
    NSNumber *number = objc_getAssociatedObject(self, "ddyHitTestLogKey");
    return number ? [number boolValue] : NO;
}

- (void)setIsShowHitTestLog:(BOOL)isShowHitTestLog {
    NSNumber *number = [NSNumber numberWithBool:isShowHitTestLog];
    objc_setAssociatedObject(self, "ddyHitTestLogKey", number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end

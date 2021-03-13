#import <UIKit/UIKit.h>

@interface UIView (DDYExtension)

#pragma mark - ---------------- 布局 ------------------
@property (nonatomic, assign) CGFloat ddy_X;
@property (nonatomic, assign) CGFloat ddy_Y;
@property (nonatomic, assign) CGFloat ddy_W;
@property (nonatomic, assign) CGFloat ddy_H;
@property (nonatomic, assign) CGFloat ddy_Left;
@property (nonatomic, assign) CGFloat ddy_Right;
@property (nonatomic, assign) CGFloat ddy_Top;
@property (nonatomic, assign) CGFloat ddy_Bottom;
@property (nonatomic, assign) CGFloat ddy_CenterX;
@property (nonatomic, assign) CGFloat ddy_CenterY;
@property (nonatomic, assign) CGSize  ddy_Size;
@property (nonatomic, assign) CGPoint ddy_Origin;

#pragma mark - ---------------- 手势 ------------------
/** 点击手势 */
- (UITapGestureRecognizer *)ddy_AddTapTarget:(id)target action:(SEL)action;
/** 点击手势 + 代理 */
- (UITapGestureRecognizer *)ddy_AddTapTarget:(id)target action:(SEL)action delegate:(id)delegate;
/** 点击手势 + 点击数 */
- (UITapGestureRecognizer *)ddy_AddTapTarget:(id)target action:(SEL)action number:(NSInteger)number;
/** 点击手势 + 点击数 + 代理 */
- (UITapGestureRecognizer *)ddy_AddTapTarget:(id)target action:(SEL)action number:(NSInteger)number  delegate:(id)delegate;
/** 长按手势 */
- (UILongPressGestureRecognizer *)ddy_AddLongGestureTarget:(id)target action:(SEL)action;
/** 长按手势 + 长按最短时间 */
- (UILongPressGestureRecognizer *)ddy_AddLongGestureTarget:(id)target action:(SEL)action minDuration:(CFTimeInterval)minDuration;
/** 拖动手势 */
- (UIPanGestureRecognizer *)ddy_AddPanGestureTarget:(id)target action:(SEL)action;
/** 拖动手势 + 代理 */
- (UIPanGestureRecognizer *)ddy_AddPanGestureTarget:(id)target action:(SEL)action delegate:(id)delegate;

#pragma mark - ---------------- 截图 ------------------
/** 截屏生成图片 */
- (nullable UIImage *)ddy_SnapshotImage;
/** 截屏生成PDF */
- (nullable NSData *)ddy_SnapshotPDF;
/** 整个截屏 */
+ (UIImage *)ddy_ScreenshotInPNGFormat;

#pragma mark - ---------------- UI ------------------
/** 阴影 */
- (void)ddy_LayerShadow:(UIColor *)color offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius;
/** 部分圆角 UIRectCornerBottomLeft | UIRectCornerBottomRight */
- (void)ddy_RoundCorners:(UIRectCorner)corners radius:(CGFloat)radius;

#pragma mark - ---------------- 功能 ------------------
/** 移除所有子视图 */
- (void)ddy_RemoveAllChildView;
/** 根据tag找到某个子视图 */
- (nullable id)ddy_SubviewWithTag:(NSInteger)tag;
/** 找到视图所在视图控制器 */
- (nullable UIViewController *)ddy_GetViewController;
/** 找到视图所在可相应的控制器 */
- (nullable UIViewController *)ddy_GetResponderViewController;
/** 本视图上的点坐标在某个view上的相对坐标 */
- (CGPoint)ddy_ConvertPoint:(CGPoint)point toView:(nullable UIView *)view;
/** 某个view上的点坐标在本视图上的相对坐标 */
- (CGPoint)ddy_ConvertPoint:(CGPoint)point fromView:(nullable UIView *)view;
/** 本视图上的rect在某个view上的相对rect */
- (CGRect)ddy_ConvertRect:(CGRect)rect toView:(nullable UIView *)view;
/** 某个view上的rect在本视图上的相对rect */
- (CGRect)ddy_ConvertRect:(CGRect)rect fromView:(nullable UIView *)view;

/** 是否打印hitTest日志 */
@property (nonatomic, assign) BOOL isShowHitTestLog;

#pragma mark - ---------------- 特效 ------------------

@end

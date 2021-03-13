#import "DDYShakeView.h"
#import "DDYKeyboardConfig.h"

@interface DDYShakeView ()
/** 展示视图 */
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation DDYShakeView

+ (instancetype)viewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 测试颜色
        self.backgroundColor = DDYRandomColor;
    }
    return self;
}



+ (void)shakeWarning:(BOOL)mySend {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    if (mySend) {
        animation.values = @[@(-5),@(-10),@(-15),@(-20),@(-25),@(-20),@(-15),@(-10),@(-5),@(0)];
    } else {
        animation.values = @[@(5),@(10),@(15),@(20),@(25),@(20),@(15),@(10),@(5),@(0)];
    }
    animation.duration = 0.5f;
    animation.repeatCount = 2;
    animation.removedOnCompletion = YES;
    for (UIView *view in [UIApplication sharedApplication].windows) {
        if ([view isKindOfClass:[UIWindow class]] && (view.ddy_W == DDYSCREENW)) {
            [[(UIWindow *)view layer] addAnimation:animation forKey:@"shake"];
        }
    }
}

+ (void)scaleWarning {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.duration = 0.5f;
    animation.repeatCount = 2;
    animation.removedOnCompletion = YES;
    for (UIView *view in [UIApplication sharedApplication].windows) {
        if ([view isKindOfClass:[UIWindow class]] && (view.ddy_W == DDYSCREENW)) {
            [[(UIWindow *)view layer] addAnimation:animation forKey:@"shake"];
        }
    }
}

@end

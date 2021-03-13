#import "UIViewController+DDYExtension.h"
#import <objc/runtime.h>

@implementation UIViewController (DDYExtension)

static BOOL isShowPathLog;

+ (void)load {
    isShowPathLog = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self changeOrignalSEL:@selector(viewDidAppear:) swizzleSEL:@selector(ddy_ViewDidAppear:)];
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

#pragma mark 设置导航条背景颜色
- (void)ddy_navigationBackgroundColor:(UIColor *)color {
    self.navigationController.navigationBar.barTintColor = color;
}

#pragma mark 导航条透明度 alpha范围[0, 1]
- (void)ddy_navigationBarAlpha:(CGFloat)alpha {
    self.navigationController.navigationBar.subviews.firstObject.alpha = alpha;
}

#pragma mark 导航分割线隐藏性 YES则隐藏
- (void)ddy_bottomLineHidden:(BOOL)hidden {
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    for (UIView *view in backgroundView.subviews) {
        if ([view isKindOfClass:[UIImageView class]] && view.frame.size.height < 1) {
            view.hidden = hidden;
        }
    }
}

#pragma mark 只设置导航标题(和tabbar无关,单纯vc.title表示两个都设置)
- (void)ddy_navigationTitle:(NSString *)title {
    self.navigationItem.title = title;
}

- (void)ddy_navigationTitleAttributes:(NSDictionary<NSAttributedStringKey,id> *)attributes {
    self.navigationController.navigationBar.titleTextAttributes = attributes;
}

- (void)ddy_ViewDidAppear:(BOOL)animated {
    if (isShowPathLog) {
        void (^printPath)(NSUInteger) = ^(NSUInteger level) {
            NSString *paddingItem = @"";
            for (NSUInteger i = 0; i < level; i++) {
                paddingItem = [paddingItem stringByAppendingFormat:@"--"];
            }
            NSLog(@"%@-> %@", paddingItem, [self.class description]);
        };
        
        if (self.parentViewController == nil) {
            printPath(0);
        } else if ([self.parentViewController isMemberOfClass:[UITabBarController class]]) {
            printPath(1);
        } else if ([self.parentViewController isMemberOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController *)[self parentViewController];
            printPath([navigationController.viewControllers indexOfObject:self]);
        }
    }
    [self ddy_ViewDidAppear:animated];
}

#pragma mark Y点移动
- (void)ddy_NavigationBarTranslationY:(CGFloat)translationY {
    self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, translationY);
}

#pragma mark 打印控制器跳转路径
+ (void)ddy_ShowPathLog:(BOOL)show {
    isShowPathLog = show;
}

@end

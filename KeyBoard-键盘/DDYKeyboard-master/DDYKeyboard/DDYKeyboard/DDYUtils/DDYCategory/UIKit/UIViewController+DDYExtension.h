#import <UIKit/UIKit.h>

@interface UIViewController (DDYExtension)

/** 设置导航条背景颜色 */
- (void)ddy_navigationBackgroundColor:(UIColor *)color;
/** 导航条透明度 alpha范围[0, 1] */
- (void)ddy_navigationBarAlpha:(CGFloat)alpha;
/** 导航分割线隐藏性 YES则隐藏 */
- (void)ddy_bottomLineHidden:(BOOL)hidden;
/** 只设置导航标题(和tabbar无关,单纯vc.title表示两个都设置) */
- (void)ddy_navigationTitle:(NSString *)title;
/** 设置标题富文本属性 如:@{NSFontAttributeName:[UIFont systemFontOfSize:19], NSForegroundColorAttributeName:[UIColor redColor]} */
- (void)ddy_navigationTitleAttributes:(NSDictionary<NSAttributedStringKey,id> * _Nullable)attributes;
/** Y点移动 */
- (void)ddy_NavigationBarTranslationY:(CGFloat)translationY;

/** 打印控制器跳转路径 */
+ (void)ddy_ShowPathLog:(BOOL)show;

@end

#import <UIKit/UIKit.h>

typedef void (^autoHeightBlock)(CGFloat height);

@interface UITextView (DDYExtension)

/** 占位字符 */
@property (nonatomic, strong) NSString *placeholder;
/** 占位字符颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

/** 普通文本文字size */
@property (nonatomic, assign, readonly) CGSize textSize;
/** 是否开启普通文本自动高度 */
@property (nonatomic, assign) BOOL isAutoHeight;
/** 普通文本自动高度时最小高度 */
@property (nonatomic, assign) CGFloat minHeight;
/** 普通文本自动高度时最大高度 */
@property (nonatomic, assign) CGFloat maxHeight;
/** 普通文本回调最终高度 */
@property (nonatomic, copy) autoHeightBlock autoHeightBlock;
/** 开启普通文本自动高度 给定高度 */
- (void)ddy_AutoHeightWithMinHeight:(CGFloat)minHeight maxHeight:(CGFloat)maxHeight;
/** 开启普通文本自动高度 行数计算 */
- (void)ddy_AutoHeightWithFont:(UIFont *)font minLineNumber:(NSUInteger)minLineNumber maxLineNumber:(NSUInteger)maxLineNumber;

/** 拖动滚动退键盘(输入滚动不会退的) */
- (void)ddy_KeyboardDismissModeOnDrag;
/** layoutManager是否非连续布局，默认YES，NO就不会再自己重置滑动了 */
- (void)ddy_AllowsNonContiguousLayout:(BOOL)allow ;

@end

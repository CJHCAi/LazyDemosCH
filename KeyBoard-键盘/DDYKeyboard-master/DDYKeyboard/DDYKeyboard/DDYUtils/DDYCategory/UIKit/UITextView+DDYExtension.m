#import "UITextView+DDYExtension.h"
#import <objc/runtime.h>

@interface UITextView ()
/** 占位label */
@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation UITextView (DDYExtension)

+ (void)load {
    [self changeOrignalSEL:NSSelectorFromString(@"dealloc") swizzleSEL:@selector(ddy_dealloc)];
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

- (void)adjustPlaceholderLabel {
    [self.placeholderLabel setFont:self.font ? self.font : [UIFont systemFontOfSize:12]];
    [self.placeholderLabel setTextColor:self.placeholderColor];
    [self.placeholderLabel setFrame:CGRectMake(self.textContainerInset.left,
                                               self.textContainerInset.top,
                                               self.bounds.size.width - self.textContainerInset.left - self.textContainerInset.right,
                                               self.bounds.size.height - self.textContainerInset.top - self.textContainerInset.bottom)];
}

#pragma mark 添加给系统属性 _placeholderLabel 在iOS8.3以上版本才有
- (void)addToSystemPlaceholderLabel:(UILabel *)label {
    // 如果有_placeholderLabel则赋值
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(NSClassFromString(@"UITextView"), &count);
    for(int i =0; i < count; i ++) {
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivars[i]) encoding:NSUTF8StringEncoding];
        if ([ivarName isEqualToString:@"_placeholderLabel"]) {
            [self setValue:label forKey:@"_placeholderLabel"];
        }
    }
    free(ivars);
    // 输入/粘贴
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ddy_TextViewDidChange)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    // setText = @"" 赋值
    [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

- (UILabel *)placeholderLabel {
    UILabel *placeholderLabel = objc_getAssociatedObject(self, @selector(placeholderLabel));
    if (!placeholderLabel) {
        placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.textAlignment = self.textAlignment;
        [self addSubview:placeholderLabel];
        [self setPlaceholderLabel:placeholderLabel];
        [self addToSystemPlaceholderLabel:placeholderLabel];
    }
    return placeholderLabel;
}

- (void)setPlaceholderLabel:(UILabel *)placeholderLabel {
    objc_setAssociatedObject(self, @selector(placeholderLabel), placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)placeholder {
    return objc_getAssociatedObject(self, @selector(placeholder));
}

- (void)setPlaceholder:(NSString *)placeholder {
    objc_setAssociatedObject(self, @selector(placeholder), placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.placeholderLabel setText:self.placeholder];
    [self layoutIfNeeded];
}

- (UIColor *)placeholderColor {
    UIColor *placeholderColor = objc_getAssociatedObject(self, @selector(placeholderColor));
    if (!placeholderColor) {
        placeholderColor = [UIColor lightGrayColor];
    }
    return placeholderColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    objc_setAssociatedObject(self, @selector(placeholderColor), placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self layoutIfNeeded];
}

- (CGSize)textSize {
    // 边框margin
    CGFloat boardMargin = self.contentInset.left
    + self.contentInset.right
    + self.textContainerInset.left
    + self.textContainerInset.right
    + self.textContainer.lineFragmentPadding
    + self.textContainer.lineFragmentPadding;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.textContainer.lineBreakMode;
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (self.font) attributes[NSFontAttributeName] = self.font;
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    
    return [self.text boundingRectWithSize:CGSizeMake(self.bounds.size.width - boardMargin, MAXFLOAT)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:attributes
                                   context:nil].size;
}

- (BOOL)isAutoHeight {
    NSNumber *isAutoHeight = objc_getAssociatedObject(self, @selector(isAutoHeight));
    if (!isAutoHeight) {
        isAutoHeight = [NSNumber numberWithBool:NO];
    }
    return [isAutoHeight boolValue];
}

- (void)setIsAutoHeight:(BOOL)isAutoHeight {
    objc_setAssociatedObject(self, @selector(isAutoHeight), [NSNumber numberWithBool:isAutoHeight], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)minHeight {
    NSNumber *minHeightNumber = objc_getAssociatedObject(self, @selector(minHeight));
    if (!minHeightNumber) {
        minHeightNumber = [NSNumber numberWithFloat:self.bounds.size.height];
    }
    return [minHeightNumber floatValue];
}

- (void)setMinHeight:(CGFloat)minHeight {
    objc_setAssociatedObject(self, @selector(minHeight), [NSNumber numberWithFloat:minHeight], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)maxHeight {
    NSNumber *maxHeightNumber = objc_getAssociatedObject(self, @selector(maxHeight));
    if (!maxHeightNumber) {
        maxHeightNumber = [NSNumber numberWithFloat:self.bounds.size.height];
    }
    return [maxHeightNumber floatValue];
}

- (void)setMaxHeight:(CGFloat)maxHeight {
    objc_setAssociatedObject(self, @selector(maxHeight), [NSNumber numberWithFloat:maxHeight], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (autoHeightBlock)autoHeightBlock {
    autoHeightBlock autoHeightBlock = objc_getAssociatedObject(self, "AutoHeightBlockKey");
    return autoHeightBlock;
}

- (void)setAutoHeightBlock:(autoHeightBlock)autoHeightBlock {
    objc_setAssociatedObject(self, "AutoHeightBlockKey", autoHeightBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)ddy_AutoHeightWithMinHeight:(CGFloat)minHeight maxHeight:(CGFloat)maxHeight {
    self.isAutoHeight = YES;
    self.minHeight = MIN(minHeight, maxHeight);
    self.maxHeight = MAX(minHeight, maxHeight);
    [self handleAutoHeight];
}

- (void)ddy_AutoHeightWithFont:(UIFont *)font minLineNumber:(NSUInteger)minLineNumber maxLineNumber:(NSUInteger)maxLineNumber {
    self.font = font;
    [self ddy_AutoHeightWithMinHeight:font.lineHeight * minLineNumber maxHeight:font.lineHeight * maxLineNumber];
}

#pragma mark 拖动滚动退键盘(输入滚动不会退的)
- (void)ddy_KeyboardDismissModeOnDrag {
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

#pragma mark layoutManager是否非连续布局，默认YES，NO就不会再自己重置滑动了
- (void)ddy_AllowsNonContiguousLayout:(BOOL)allow {
    self.layoutManager.allowsNonContiguousLayout = allow;
}

- (void)ddy_TextViewDidChange {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.3) {
        self.placeholderLabel.hidden = self.text.length>0 ? YES : NO;
    }
    if (self.isAutoHeight) {
        [self handleAutoHeight];
    }
}

- (void)handleAutoHeight {
    self.textContainer.lineFragmentPadding = 0;
    
    void (^setHeight)(CGFloat) = ^(CGFloat height) {
        CGRect frame = self.frame;
        frame.size.height = height;
        self.frame = frame;
        if (self.autoHeightBlock) {
            self.autoHeightBlock(height);
        }
    };
    // 边框margin
    CGFloat boardMargin = self.contentInset.top + self.contentInset.bottom + self.textContainerInset.top + self.textContainerInset.bottom;
    
    if (self.textSize.height + boardMargin < self.minHeight) {
        self.scrollEnabled = NO;
        setHeight(self.minHeight);
    } else if (self.textSize.height+boardMargin > self.maxHeight) {
        self.scrollEnabled = YES;
        setHeight(self.maxHeight);
    } else {
        self.scrollEnabled = NO;
        setHeight(self.textSize.height+boardMargin);
    }
    NSLog(@"%@ %@", NSStringFromCGSize(self.textSize), NSStringFromCGSize(self.textContainer.size));
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self adjustPlaceholderLabel];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self ddy_TextViewDidChange];
}

- (instancetype)ddy_Init {
    
    return [self ddy_Init];
}

- (void)ddy_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    @try { [self removeObserver:self forKeyPath:@"text"]; } @catch (NSException *exception) { }
    [self ddy_dealloc];
}

@end

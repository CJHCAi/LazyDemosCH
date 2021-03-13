#import "UIButton+DDYExtension.h"
#import "UIView+DDYExtension.h"
#import "UIImage+DDYExtension.h"
#import <objc/runtime.h>

@implementation UIButton (DDYExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self changeOrignalSEL:@selector(layoutSubviews) swizzleSEL:@selector(ddy_LayoutSubviews)];
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

- (void)ddy_LayoutSubviews {
    [self ddy_LayoutSubviews];
    
    if (self.imageView.image && self.titleLabel.text)
    {
        switch (self.btnStyle)
        {
            case DDYBtnStyleImgLeft:
                [self layoutHorizontalWithLeftView:self.imageView rightView:self.titleLabel];
                break;
            case DDYBtnStyleImgRight:
                [self layoutHorizontalWithLeftView:self.titleLabel rightView:self.imageView];
                break;
            case DDYBtnStyleImgTop:
                [self layoutVerticalWithUpView:self.imageView downView:self.titleLabel];
                break;
            case DDYBtnStyleImgDown:
                [self layoutVerticalWithUpView:self.titleLabel downView:self.imageView];
                break;
            case DDYBtnStyleNaturalImgLeft:
                [self layoutNaturalWithLeftView:self.imageView rightView:self.titleLabel];
                break;
            case DDYBtnStyleNaturalImgRight:
                [self layoutNaturalWithLeftView:self.titleLabel rightView:self.imageView];
                break;
            case DDYBtnStyleImgLeftThenLeft:
                [self layoutLeftStyleWithLeftView:self.imageView rightView:self.titleLabel];
                break;
            case DDYBtnStyleImgRightThenLeft:
                [self layoutLeftStyleWithLeftView:self.titleLabel rightView:self.imageView];
                break;
            case DDYBtnStyleImgRightThenRight:
                [self layoutRightStyleWithLeftView:self.titleLabel rightView:self.imageView];
                break;
            case DDYBtnStyleImgLeftThenRight:
                [self layoutRightStyleWithLeftView:self.imageView rightView:self.titleLabel];
                break;
            default:
                [self layoutHorizontalWithLeftView:self.imageView rightView:self.titleLabel];
                break;
        }
    }
}

- (void)layoutHorizontalWithLeftView:(UIView *)leftView rightView:(UIView *)rightView {
    CGFloat totalW = leftView.ddy_W + self.padding + rightView.ddy_W;
    
    leftView.ddy_X = (self.ddy_W - totalW)/2.0;
    leftView.ddy_Y = (self.ddy_H - leftView.ddy_H)/2.0;
    rightView.ddy_X = leftView.ddy_Right + self.padding;
    rightView.ddy_Y = (self.ddy_H - rightView.ddy_H)/2.0;
}

- (void)layoutVerticalWithUpView:(UIView *)upView downView:(UIView *)downView {
    CGFloat totalH = upView.ddy_H + self.padding + downView.ddy_H;
    
    upView.ddy_X = (self.ddy_W - upView.ddy_W)/2.0;
    upView.ddy_Y = (self.ddy_H - totalH)/2.0;
    downView.ddy_X = (self.ddy_W - downView.ddy_W)/2.0;
    downView.ddy_Y = upView.ddy_Bottom + self.padding;
}

- (void)layoutNaturalWithLeftView:(UIView *)leftView rightView:(UIView *)rightView {
    leftView.ddy_X = 0;
    rightView.ddy_Right = self.ddy_W;
}

- (void)layoutLeftStyleWithLeftView:(UIView *)leftView rightView:(UIView *)rightView {
    leftView.ddy_X = 0;
    rightView.ddy_X = leftView.ddy_Right + self.padding;
}

- (void)layoutRightStyleWithLeftView:(UIView *)leftView rightView:(UIView *)rightView {
    rightView.ddy_Right = self.ddy_W;
    leftView.ddy_Right = rightView.ddy_X - self.padding;
}

- (void)setBtnStyle:(DDYBtnStyle)btnStyle {
    NSNumber *number = [NSNumber numberWithInteger:(NSInteger)btnStyle];
    objc_setAssociatedObject(self, "ddyBtnStyleKey", number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (DDYBtnStyle)btnStyle {
    NSNumber *number = objc_getAssociatedObject(self, "ddyBtnStyleKey");
    return number ? (DDYBtnStyle)[number integerValue] : DDYBtnStyleImgLeft;
}

- (void)setPadding:(CGFloat)padding {
    NSNumber *number = [NSNumber numberWithFloat:padding];
    objc_setAssociatedObject(self, "ddyPaddingKey", number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (CGFloat)padding {
    NSNumber *number = objc_getAssociatedObject(self, "ddyPaddingKey");
    return number ? [number floatValue] : 0.f;
}

- (void)ddy_SetStyle:(DDYBtnStyle)style padding:(CGFloat)padding {
    self.btnStyle = style;
    self.padding = padding;
}

#pragma mark - 对touchUpInside进行block
- (void)ddy_TouchUpInsideBlock:(DDYButtonTouchUpInsideBlock)block {
    if (block) objc_setAssociatedObject(self, "DDYTouchUpInsideKey", block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(handleTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleTouchUpInside:(UIButton *)sender {
    DDYButtonTouchUpInsideBlock block = objc_getAssociatedObject(self, "DDYTouchUpInsideKey");
    block(sender);
}

#pragma mark 使用颜色设置按钮背景
- (void)ddy_BackgroundColor:(UIColor *)bgColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIImage ddy_RectImageWithColor:bgColor size:CGSizeMake(1, 1)] forState:state];
}

@end

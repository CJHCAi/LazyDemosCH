//
//  HLAlertView.m
//  HLAlertView
//
//  Created by benjaminlmz@qq.com on 2020/4/29.
//  Copyright © 2020 Tony. All rights reserved.
//

#import "HLAlertView.h"
#import "HLPopupView.h"

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#define kBKTag 101001
@interface HLAlertView ()<UITextFieldDelegate>
@property (nonatomic ,strong) HLPopupView *popView;

@property (nonatomic ,strong) NSMutableArray *actionArray;
@property (nonatomic ,strong) NSMutableArray *buttonArray;
@property (nonatomic ,strong) NSMutableArray *imageViewArray;
@property (nonatomic ,strong) NSMutableArray *labelArray;
@property (nonatomic ,strong) NSMutableArray *textFieldArray;
@property (nonatomic ,strong) NSLayoutConstraint *centerY;
@property (nonatomic ,strong) NSLayoutConstraint *popViewWidthConstraint;
@property (nonatomic ,strong) NSLayoutConstraint *popViewHeightConstraint;
@property (nonatomic ,assign) CGFloat mul;
@end
static HLAlertView *hAC = nil;

@implementation HLAlertView

//初始化
+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message {
    if (hAC == nil) {
        hAC = [[HLAlertView alloc] init];
        [hAC setTranslatesAutoresizingMaskIntoConstraints:NO];
        hAC.tag = kBKTag;
        hAC.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];   //背景颜色
        hAC.shadowAction = NO;
        hAC.mul = 1;
        [[NSNotificationCenter defaultCenter] addObserver:hAC selector:@selector(statusBarOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    
    hAC.actionArray = [[NSMutableArray alloc] initWithCapacity:0];
    hAC.buttonArray = [[NSMutableArray alloc] initWithCapacity:0];
    hAC.labelArray = [[NSMutableArray alloc] initWithCapacity:0];
    hAC.textFieldArray = [[NSMutableArray alloc] initWithCapacity:0];
    hAC.popView = [[HLPopupView alloc] init];
    /* title */
   

    
    if (title != nil) {
        HLLabel *titleLabel = [HLLabel labelWithTitle:title block:^(Constraint * _Nonnull constraint, HLLabelModel * _Nonnull labelModel) {
            constraint.left = 15;
            constraint.right = -15;
            constraint.bottom = 5;
            labelModel.textFont = [UIFont systemFontOfSize:17 weight:1];
            labelModel.textAlignment = NSTextAlignmentCenter;
        }];
        [hAC addLabel:titleLabel];
    }
    if (message != nil) {
        /* message */
        HLLabel *messageLabel = [HLLabel labelWithTitle:message block:^(Constraint * _Nonnull constraint, HLLabelModel * _Nonnull labelModel) {
            constraint.left = 15;
            constraint.right = -15;
            constraint.bottom = 5;
            labelModel.textFont = [UIFont systemFontOfSize:13];
            labelModel.textAlignment = NSTextAlignmentCenter;
        }];
        [hAC addLabel:messageLabel];
    }

    [hAC addSubview:hAC.popView];
    
    return hAC;
}
- (void)addLabel:(id)label {
    [hAC appendToLabels:label];
}


- (void)addAciton:(HLAction *)action {
    [hAC appendToActions:action];
}

- (void)addButton:(id)object {
    if (object != nil && [object isMemberOfClass:[HLButton class]]) {
        HLButtonModel *buttonModel = [object valueForKey:@"buttonModel"];
        UIButton *button = [object valueForKey:@"button"];
        [button setTitleColor:buttonModel.textColor forState:UIControlStateNormal];
        [button setBackgroundImage:[HLAlertView imageWithColor:buttonModel.normalColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[HLAlertView imageWithColor:buttonModel.highlightedColor] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[HLAlertView imageWithColor:buttonModel.disabledColor] forState:UIControlStateDisabled];
        button.layer.cornerRadius  = buttonModel.cornerRadius;
        button.layer.masksToBounds = buttonModel.maskToBounds;
        [hAC.popView addItemToArrayWithObject:object];
    }
}

- (void)addImageView:(HLImageView *)imageView {
    [hAC appendToImageView:imageView];
}

- (void)appendToLabels:(id)label {
    if (label != nil && ([label isMemberOfClass:[HLLabel class]] || [label isMemberOfClass:[HMLabel class]])) {
        // HQLabel 字体格式设置
        if ([label isMemberOfClass:[HMLabel class]] == YES) {
            HMLabel *obj = label;
            UITextView *textView = [obj valueForKey:@"textView"];
            HLTextModel *textModel = [obj valueForKey:@"textModel"];
            
            textView.font = textModel.textFont;
            textView.textAlignment = textModel.textAlignment;
            textView.textColor = textModel.textColor;
            textView.backgroundColor = textModel.backgroundColor;
            textView.layer.cornerRadius = textModel.cornerRadius;
            textView.scrollEnabled = textModel.scrollEnable;
            textView.layer.masksToBounds = YES;
        }else if ([label isMemberOfClass:[HLLabel class]] == YES){
            HLLabel *obj = label;
            UILabel *label = [obj valueForKey:@"label"];
            HLLabelModel *labelModel = [obj valueForKey:@"labelModel"];
            label.font = labelModel.textFont;
            label.textAlignment = labelModel.textAlignment;
            label.textColor = labelModel.textColor;
            label.backgroundColor = labelModel.backgroundColor;
            label.layer.cornerRadius = labelModel.cornerRadius;
            label.layer.masksToBounds = YES;
        }
        [hAC.labelArray addObject:label];
        [hAC.popView addItemToArrayWithObject:label];
    }
}

//action Array
- (void)appendToActions:(HLAction *)action {
    if (action != nil) {
        [hAC.actionArray addObject:action];
        [hAC.popView addItemToArrayWithObject:action];
        _actions = hAC.actionArray;
    }
}

- (void)appendToImageView:(HLImageView *)imageView {
    if (imageView != nil) {
        [hAC.imageViewArray addObject:imageView];
        [hAC.popView addItemToArrayWithObject:imageView];
    }
}

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(HLTextField *textField))configurationHandler {
    HLTextField *tf = [[HLTextField alloc] init];
    tf.delegate = hAC;
    [hAC.textFieldArray addObject:tf];
    [hAC.popView addItemToArrayWithObject:tf];
    configurationHandler(tf);
}
//约束
- (void)updateConstraint:(UIDeviceOrientation)orientation {
    [hAC setTranslatesAutoresizingMaskIntoConstraints:NO];

    //背景约束
    NSLayoutConstraint *cWidth1 = [NSLayoutConstraint  constraintWithItem:hAC
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1
                                                                 constant:[UIScreen mainScreen].bounds.size.width];
    
    NSLayoutConstraint *height1 = [NSLayoutConstraint constraintWithItem:hAC
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeHeight
                                                              multiplier:1
                                                                constant:[UIScreen mainScreen].bounds.size.height];
    [hAC addConstraints:@[cWidth1,height1]];
    
    NSLayoutConstraint *top1 = [NSLayoutConstraint constraintWithItem:[[[UIApplication sharedApplication] windows] firstObject] attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:hAC
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0
                                                                constant:0];
    NSLayoutConstraint *left1 = [NSLayoutConstraint constraintWithItem:[[[UIApplication sharedApplication] windows] firstObject] attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:hAC
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1.0
                                                                constant:0];
    NSLayoutConstraint *right1 = [NSLayoutConstraint constraintWithItem:[[[UIApplication sharedApplication] windows] firstObject] attribute:NSLayoutAttributeRight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:hAC
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1.0
                                                                constant:0];
    NSLayoutConstraint *bottom1 = [NSLayoutConstraint constraintWithItem:[[[UIApplication sharedApplication] windows] firstObject] attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:hAC
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0];
    [[[[UIApplication sharedApplication] windows] firstObject] addConstraints:@[top1,left1,right1,bottom1]];

    
    hAC.popViewWidthConstraint = [NSLayoutConstraint  constraintWithItem:hAC.popView
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeWidth
                                                              multiplier:1
                                                                constant:hAC.popView.frame.size.width];
    [hAC.popView addConstraints:@[hAC.popViewWidthConstraint]];

    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:hAC.popView attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:hAC
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0];
    hAC.centerY = [NSLayoutConstraint constraintWithItem:hAC.popView attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:hAC
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0 * hAC.mul
                                                                constant:0];
    [hAC addConstraints:@[centerX,hAC.centerY]];
    
    
    [hAC.popView removeConstraint:hAC.popViewHeightConstraint];
    hAC.popViewHeightConstraint = [NSLayoutConstraint constraintWithItem:hAC.popView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeHeight
                                                                 multiplier:1
                                                                   constant:[hAC.popView getCurrentHeight]];
    [hAC.popView addConstraint:hAC.popViewHeightConstraint];
}

//重新设置弹框宽高
- (void)alertSize:(CGSize)size {
    [hAC.popView fixSize:size];
}

// textField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [hAC removeConstraint:hAC.centerY];
    hAC.mul = 0.7;
    hAC.centerY = [NSLayoutConstraint constraintWithItem:hAC.popView attribute:NSLayoutAttributeCenterY
        relatedBy:NSLayoutRelationEqual
           toItem:hAC
        attribute:NSLayoutAttributeCenterY
       multiplier:1.0 * hAC.mul
         constant:0];
    [hAC addConstraints:@[hAC.centerY]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [hAC removeConstraint:hAC.centerY];
    [UIView animateWithDuration:0.5 animations:^{
        hAC.mul = 1;
//        hAC.centerY = [NSLayoutConstraint constraintWithItem:hAC.popView attribute:NSLayoutAttributeCenterY
//                                                   relatedBy:NSLayoutRelationEqual
//                                                      toItem:hAC
//                                                   attribute:NSLayoutAttributeCenterY
//                                                  multiplier:1.0 * hAC.mul
//                                                    constant:0];
//        [hAC addConstraints:@[hAC.centerY]];
//
        [hAC.popView setCenter:CGPointMake(kWidth /2, kHeight/2)];
    }];
    
}


//展示
+ (void)show {
    UIView *oldView = [[[[UIApplication sharedApplication] windows] firstObject] viewWithTag:kBKTag];
    if (oldView) {
        [oldView removeFromSuperview];
    }
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:hAC];
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    [hAC updateConstraint:orientation];
    hAC.popView.alpha = 0;
    hAC.popView.transform = CGAffineTransformScale(hAC.popView.transform,1.2,1.2);
    [UIView animateWithDuration:0.3 animations:^{
        hAC.popView.transform = CGAffineTransformIdentity;
        hAC.popView.alpha = 1;
    }];
    if (hAC.textFieldArray.count != 0) {
        UITextField * tf = [hAC.textFieldArray firstObject];
        [tf becomeFirstResponder];
    }
}

+ (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        hAC.alpha = 0;
    } completion:^(BOOL finished) {
        [hAC removeFromSuperview];
        hAC = nil;
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (hAC.shadowAction == YES) {
        [hAC removeFromSuperview];
        hAC = nil;
    }
    
    [self.textFieldArray enumerateObjectsUsingBlock:^(HLTextField* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               [obj resignFirstResponder];
           }];
}

- (void)statusBarOrientationChange:(NSNotification *)notification {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    [self updateConstraint:orientation];
}
- (void)dealloc {
    NSLog(@"HLAlertView dealloc...");
}
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

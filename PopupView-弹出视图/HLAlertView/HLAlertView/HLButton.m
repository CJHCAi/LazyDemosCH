//
//  HLButton.m
//  HLAlertView
//
//  Created by benjaminlmz@qq.com on 2020/5/8.
//  Copyright © 2020 Tony. All rights reserved.
//

#import "HLButton.h"

@interface HLButton()
@property (nonatomic ,copy) void(^hander)(HLButton *button);

@property (nonatomic ,strong) Constraint *constraint;
@property (nonatomic ,strong) HLButtonModel *buttonModel;
@property (nonatomic ,strong) UIButton *button;
@end
@implementation HLButton
- (id)init {
    self = [super init];
    if (self) {
        self.button = [[UIButton alloc] init];
        self.constraint = [[Constraint alloc] init];
        self.buttonModel = [[HLButtonModel alloc] init];
        [self.button setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return self;
}

+ (instancetype)buttonWithTitle:(NSString *)title block:(void(^)(Constraint *,HLButtonModel *))block handler:(void(^ __nullable)(HLButton *action))handler {
    HLButton *object = [[HLButton alloc] init];
    [object.button setTitle:title forState:UIControlStateNormal];
    [object.button addTarget:object action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    object.hander = handler;
    block(object.constraint,object.buttonModel);
    return object;
}

- (void)setTitle:(NSString *)title {
    _title = title;
}

- (void)clicked:(HLButton *)sender {
    self.hander(self);
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

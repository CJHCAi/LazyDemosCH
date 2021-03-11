//
//  HLAction.m
//  HLAlertView
//
//  Created by 梁明哲 on 2020/5/4.
//  Copyright © 2020 Tony. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "HLAction.h"

//#define HLActionProperty(propertyModifier, propertyName) @property(nonatomic,propertyModifier) void(^propertyName)(HLAction *action);

@interface HLAction()
@property (nonatomic ,copy) void(^hander)(HLAction *action);
@end


@implementation HLAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void(^ __nullable)(HLAction *action))handler {
    HLAction *action = [[HLAction alloc] initWithFrame:CGRectMake(0, 0, 299, 199)];
    action.titleLabel.font = [UIFont systemFontOfSize:17 weight:0];
    action.title = title;

    HLActionModel *model = [[HLActionModel alloc] init];
    model.leftBorder = 0.0f;
    model.textColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.9 alpha:1];

    model.rightBorder = 0.0f;
    model.height = 50;
    model.alignment = NSTextAlignmentCenter;
    action.model = model;

    [action setTitle:title forState:UIControlStateNormal];
    [action setTitleColor:model.textColor forState:UIControlStateNormal];
    [action setBackgroundImage:[HLAction imageWithColor:[UIColor colorWithWhite:0.9 alpha:0.8]] forState:UIControlStateHighlighted];
    [action addTarget:action action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    action.hander = handler;
    [action setTranslatesAutoresizingMaskIntoConstraints:NO];
    return action;
}

- (void)setTitle:(NSString *)title {
    _title = title;
}

- (void)clicked:(HLAction *)sender {
    sender.hander(sender);
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

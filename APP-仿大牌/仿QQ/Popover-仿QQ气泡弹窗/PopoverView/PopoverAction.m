//
//  PopoverAction.m
//  Popover
//
//  Created by StevenLee on 2016/12/10.
//  Copyright © 2016年 lifution. All rights reserved.
//

#import "PopoverAction.h"

@interface PopoverAction ()

@property (nonatomic, strong, readwrite) UIImage *image; ///< 图标
@property (nonatomic, copy, readwrite) NSString *title; ///< 风格
@property (nonatomic, copy, readwrite) void(^handler)(PopoverAction *action); ///< 选择回调

@end

@implementation PopoverAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(PopoverAction *action))handler {
    return [self actionWithImage:nil title:title handler:handler];
}

+ (instancetype)actionWithImage:(UIImage *)image title:(NSString *)title handler:(void (^)(PopoverAction *action))handler {
    PopoverAction *action = [[self alloc] init];
    action.image = image;
    action.title = title ? : @"";
    action.handler = handler ? : NULL;
    
    return action;
}

@end

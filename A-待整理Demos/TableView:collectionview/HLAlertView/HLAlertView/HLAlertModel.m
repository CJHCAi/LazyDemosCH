//
//  HLAlertModel.m
//  HLAlertView
//
//  Created by 梁明哲 on 2020/5/4.
//  Copyright © 2020 Tony. All rights reserved.
//

#import "HLAlertModel.h"
@implementation HLAlertModel
- (id)init {
    self = [super init];
    if (self) {
        _topBorder = 15;
        _leftBorder  = 15.0f;
        _rightBorder = -15.0f;
        _height = 0.0f;
        _font = [UIFont systemFontOfSize:17.0f weight:0];
        _alignment = NSTextAlignmentCenter;
        _textColor = [UIColor blackColor];
        _backgroundColor = [UIColor clearColor];
        _cornerRadius = 0;
        _maskToBounds = NO;
    }
    return self;
}
@end


@implementation HLLabelModel
- (id)init {
    self = [super init];
    if (self) {
        _textFont = [UIFont systemFontOfSize:17.0f weight:0];
        _textAlignment = NSTextAlignmentCenter;
        _textColor = [UIColor blackColor];
        _backgroundColor = [UIColor clearColor];
        _cornerRadius = 0;
        _maskToBounds = NO;
    }
    return self;
}
@end

@implementation HMLabelModel
- (id)init {
    self = [super init];
    if (self) {
        _topBorder = 15;
        _leftBorder  = 15.0f;
        _rightBorder = -15.0f;
        _height = 0.0f;
        _font = [UIFont systemFontOfSize:17.0f weight:0];
        _alignment = NSTextAlignmentCenter;
        _textColor = [UIColor blackColor];
        _backgroundColor = [UIColor clearColor];
        _cornerRadius = 0;
        _maskToBounds = NO;
    }
    return self;
}
@end
// HLImageViewModel
@implementation HLImageViewModel

- (id)init {
    _topBorder = 0;
    _leftBorder  = 0;
    _rightBorder = 0;
    _height = 60.0f;
    _cornerRadius = 0;
    _maskToBounds = NO;
    return self;
}
@end

@implementation HLActionModel
- (id)init {
    self = [super init];
    if (self) {
        _topBorder = 15.0f;
        _leftBorder  = 15.0f;
        _rightBorder = -15.0f;
        _height = 0.0f;
        _font = [UIFont systemFontOfSize:17.0f weight:0];
        _alignment = NSTextAlignmentCenter;
        _textColor = [UIColor blackColor];
        _backgroundColor = [UIColor clearColor];
        _cornerRadius = 0;
        _maskToBounds = NO;
    }
    return self;
}
@end

@implementation HLButtonModel
- (id)init {
    self = [super init];
    if (self) {
        _font = [UIFont systemFontOfSize:17.0f weight:0];
        _textAlignment = NSTextAlignmentCenter;
        _textColor = [UIColor blackColor];
        _backgroundColor = [UIColor clearColor];
        _normalColor = [UIColor whiteColor];
        _highlightedColor = [UIColor whiteColor];
        _disabledColor = [UIColor whiteColor];
        _cornerRadius = 0;
        _maskToBounds = NO;
    }
    return self;
}
@end

@implementation Constraint
- (id)init {
    self = [super init];
    if (self) {
        _top = 15.0f;
        _bottom  = 0.0f;
        _left = -15.0f;
        _right = 0.0f;
        _autoRelation = YES;
    }
    return self;
}
@end


@implementation HLTextModel
- (id)init {
    self = [super init];
    if (self) {
        _textFont = [UIFont systemFontOfSize:17.0f];
        _textAlignment  = NSTextAlignmentCenter;
        _textColor = [UIColor blackColor];
        _backgroundColor = nil;
        _cornerRadius = 0;
        _maskToBounds = YES;
    }
    return self;
}
@end
/**
 @property (nonatomic,copy)  UIFont *textFont;
 @property (nonatomic,assign) NSTextAlignment textAlignment;
 @property (nonatomic,copy) UIColor *textColor;
 @property (nonatomic,copy) UIColor *backgroundColor;
 @property (nonatomic,assign) CGFloat cornerRadius;
 @property (nonatomic,assign) BOOL maskToBounds;
 */

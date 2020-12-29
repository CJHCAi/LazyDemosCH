//
//  UIButton+LLExtension.m
//  Andy_Category
//
//  Created by 933 on 15/12/29.
//  Copyright © 2015年 Andy. All rights reserved.
//

#import "UIButton+LLExtension.h"


/**
 *  内部类声明、实现
 */
@interface LLExtensionButton : UIButton

@property(nonatomic,copy) ButtonActionBlock actionSel;

@end

@implementation LLExtensionButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)buttonClick:(UIButton *)button
{
    if (self.actionSel)
    {
        self.actionSel(self);
    }
}

@end

@implementation UIButton (LLExtension)

//创建普通文字button
+(instancetype)LL_buttonCustomButtonFrame:(CGRect)frame
                                    title:(NSString *)title
                        currentTtileColor:(UIColor *)titleColor
                                actionSel:(ButtonActionBlock)actionSel
{
    LLExtensionButton *button = [LLExtensionButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.actionSel = actionSel;
    return button;
}

//创建图片button
+(instancetype)LL_buttonCustomButtonFrame:(CGRect)frame
                        normalImageString:(NSString *)normalImgString
                                actionSel:(ButtonActionBlock)actionSel
{
    LLExtensionButton *button =  [LLExtensionButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:normalImgString] forState:UIControlStateNormal];
    button.actionSel = actionSel;
    return button;
}

@end

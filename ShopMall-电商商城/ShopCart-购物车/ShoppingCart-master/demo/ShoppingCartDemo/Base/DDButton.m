//
//  DDButton.m
//  ShoppingCartDemo
//
//  Created by dry on 2017/12/5.
//  Copyright © 2017年 MorrisMeng. All rights reserved.
//

#import "DDButton.h"

@implementation DDButton

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    
    //复写父类方法，设置项目中默认button字体颜色
    [self setTitleColor:WORD_COLOR forState:UIControlStateNormal];
}

@end

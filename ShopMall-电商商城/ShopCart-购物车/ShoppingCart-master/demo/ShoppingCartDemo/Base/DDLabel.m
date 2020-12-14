//
//  DDLabel.m
//  ShoppingCartDemo
//
//  Created by dry on 2017/12/5.
//  Copyright © 2017年 MorrisMeng. All rights reserved.
//

#import "DDLabel.h"

@implementation DDLabel

- (void)setText:(NSString *)text {
    [super setText:text];
    
    //复写父类方法，设置项目中默认label字体颜色
    [self setTextColor:WORD_COLOR];
}

@end

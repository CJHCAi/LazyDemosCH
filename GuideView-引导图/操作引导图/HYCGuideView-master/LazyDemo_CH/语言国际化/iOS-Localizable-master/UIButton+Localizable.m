//
//  UIButton+Localizable.m
//  Internationalization
//
//  Created by Qiulong-CQ on 2016/12/7.
//  Copyright © 2016年 xiaoheng. All rights reserved.
//

#import "UIButton+Localizable.h"

@implementation UIButton(Localizable)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setNewText:(NSString *)newText
{
    [self setTitle:GDLocalizedString(newText) forState:0];
}

-(NSString *)newText{
    return self.titleLabel.text;
}

@end

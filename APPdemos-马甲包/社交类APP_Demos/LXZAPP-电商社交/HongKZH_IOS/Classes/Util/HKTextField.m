//
//  HKTextField.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKTextField.h"

@implementation HKTextField

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 0; //像右边偏15
    return iconRect;
}

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    if (self.leftView) {
        return CGRectInset(bounds, 18+5, 0);
    }
    return bounds;
    
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    if (self.leftView) {
        return CGRectInset(bounds, 18+5, 0);
    }
    return bounds;
}


@end

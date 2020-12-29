//
//  UIBarButtonItem+CH.m
//  XiYou_IOS
//
//  Created by regan on 15/11/19.
//  Copyright © 2015年 regan. All rights reserved.
//

#import "UIBarButtonItem+CH.h"
#import "UIImage+CH.h"
@implementation UIBarButtonItem (CH)
+(UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(nullable id)target action:(nullable SEL)action
{
    UIButton *btn=[[UIButton alloc]init];
    // 这里需要注意：由于是想让图片右移，所以left需要设置为正，right需要设置为负。正在是相反的。
    // 让按钮图片左移15
    //[btn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [btn setImage:[UIImage resizedImage:icon] forState:UIControlStateNormal];
    [btn setImage:[UIImage resizedImage:highIcon] forState:UIControlStateHighlighted];
    btn.frame=CGRectMake(0, 20, btn.currentImage.size.width, btn.currentImage.size.height);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

@end

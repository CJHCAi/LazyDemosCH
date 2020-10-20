//
//  TLMenuButton.m
//  MiShu
//
//  Created by tianlei on 16/6/21.
//  Copyright © 2016年 Qzy. All rights reserved.
//

#import "TLMenuButton.h"

@implementation TLMenuButton
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(20.5, 8, 14, 16);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0,26, self.bounds.size.width, 20);
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
}
+ (instancetype)buttonWithTitle:(NSString *)title imageTitle:(NSString *)imageTitle center:(CGPoint)point color:(UIColor *)color{
    //CGSize size = CGSizeMake(44, 44);
    CGRect frame = CGRectMake(0, 0, 55, 55);
    TLMenuButton *menu4 = [[TLMenuButton alloc] initWithFrame:frame];
    menu4.center = point;
    menu4.backgroundColor = color;
    menu4.layer.cornerRadius = 55/2.0;
    [menu4 setTitle:title forState:UIControlStateNormal];
    [menu4 setImage:[UIImage imageNamed:imageTitle] forState:UIControlStateNormal];
    return menu4;
}
@end

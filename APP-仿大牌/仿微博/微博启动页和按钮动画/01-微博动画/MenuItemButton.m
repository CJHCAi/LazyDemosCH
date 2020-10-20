//
//  MenuItemButton.m
//  01-微博动画
//
//  Created by xiaomage on 15/6/26.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "MenuItemButton.h"
#define kImageRatio 0.8

@implementation MenuItemButton

- (void)awakeFromNib
{
    [self setUp];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted{}

- (void)setUp
{
    self.imageView.contentMode = UIViewContentModeCenter;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

// 以后如果通过代码设置子控件的位置，一般都是在layoutSubviews里面去写
// layoutSubviews什么时候调用，只要父控件的frame一改变就会调用layoutSubviews，重新布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // UIImageView
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = self.bounds.size.width;
    CGFloat imageH = self.bounds.size.height * kImageRatio;
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    
    // UILabel
    CGFloat labelY = imageH;
    CGFloat labelH = self.bounds.size.height - labelY;
    self.titleLabel.frame = CGRectMake(imageX, labelY, imageW, labelH);
    
}
// 注意：按钮touchesBegan和监听方法会冲突
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"%s",__func__);
//}
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [UIView animateWithDuration:0.5 animations:^{
//        self.transform = CGAffineTransformMakeScale(2.0, 2.0);
//        self.alpha = 0;
//        
//    }];
//    NSLog(@"%s",__func__);
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

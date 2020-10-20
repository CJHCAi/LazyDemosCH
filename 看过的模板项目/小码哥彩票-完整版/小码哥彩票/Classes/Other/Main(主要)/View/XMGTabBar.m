//
//  XMGTabBar.m
//  小码哥彩票
//
//  Created by xiaomage on 15/6/26.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGTabBar.h"

#import "XMGTabBarButton.h"
// 我们自己的tabBar的按钮也需要模型，UITabBar上的按钮交给UITabBarItem


@interface XMGTabBar ()

@property (nonatomic, weak) XMGTabBarButton *selButton;

@end

@implementation XMGTabBar

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    // UITabBarItem保存按钮上的图片
    for (UITabBarItem *item in items) {
        
        UIButton *btn = [XMGTabBarButton buttonWithType:UIButtonTypeCustom];
        
        btn.tag = self.subviews.count;
        
        [btn setBackgroundImage:item.image forState:UIControlStateNormal];
        
        [btn setBackgroundImage:item.selectedImage forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:btn];
        
        if (self.subviews.count == 1) {
            // 默认选中第一个
            [self btnClick:btn];
        }
    }
    
}


- (void)btnClick:(XMGTabBarButton *)button
{
    _selButton.selected = NO;
    
    button.selected = YES;
    
    _selButton = button;
    
    // 通知tabBarVc切换控制器
    if ([_delegate respondsToSelector:@selector(tabBar:didClickBtn:)]) {
        [_delegate tabBar:self didClickBtn:button.tag];
    }
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int count = self.subviews.count;
    
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = [UIScreen mainScreen].bounds.size.width / count;
    
    CGFloat h = self.height;
    
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        
        x = i * w;
        
        btn.frame = CGRectMake(x, y, w, h);
    }
}

- (void)setUp
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

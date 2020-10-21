//
//  HQTabBar.m
//  TableBar
//
//  Created by HanQi on 16/8/9.
//  Copyright © 2016年 HanQi. All rights reserved.
//

#import "HQTabBar.h"

@interface HQTabBar()

@property (nonatomic, assign) int tabBarSize;
@property (nonatomic, strong) UIButton *centerButtton;

@end

@implementation HQTabBar

- (instancetype)initWithFrame:(CGRect)frame tabBarSize:(int)size
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.tabBarSize = size;
        
//        self.backgroundImage = [UIImage imageNamed:@"tabbar_background"];
        
        UIButton *button = [[UIButton alloc] init];
        
        button.frame = CGRectMake(0, 0, 60, 60);
        
        [button setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius=30;
        button.layer.masksToBounds=YES;
        button.backgroundColor=[UIColor redColor];
        [self addSubview:button];
        self.centerButtton = button;
        
        
    }
    return self;
}


- (void)btnClick:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(hQTabBar:btnDidClick:)]) {
    
        [self.delegate hQTabBar:self btnDidClick:button];
    
    }

}

-(void)layoutSubviews {

    [super layoutSubviews];
    
    CGPoint btnCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.centerButtton.center = btnCenter;
    
    CGFloat tabBarX = (self.frame.size.width - self.centerButtton.frame.size.width)/(self.tabBarSize - 1);
    int tabBarIndex = 0;
    
    for (UIView *subview in self.subviews) {
        
        Class class = NSClassFromString(@"UITabBarButton");
        if ([subview isKindOfClass:class]) {
            
            if (tabBarIndex < (self.tabBarSize-1)/2) {
                
                CGRect frame = subview.frame;
                frame.origin.x = tabBarIndex * tabBarX;
                subview.frame = frame;
                
                CGRect frameCh = subview.frame;
                frameCh.size.width = tabBarX;
                subview.frame = frameCh;
                
            
            } else if (tabBarIndex > (self.tabBarSize-1)/2) {
            
                CGRect frame = subview.frame;
                frame.origin.x = (tabBarIndex-1) * tabBarX + self.centerButtton.frame.size.width;
                subview.frame = frame;
                
                CGRect frameCh = subview.frame;
                frameCh.size.width = tabBarX;
                subview.frame = frameCh;
                
            
            }

            tabBarIndex++;
            if (tabBarIndex == (self.tabBarSize-1)/2) {
                tabBarIndex++;
            }
        }
        
       
        
    }

}



@end
